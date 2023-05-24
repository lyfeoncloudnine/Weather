//
//  ListViewReactor.swift
//  Weather
//
//  Created by lyfeoncloudnine on 2023/05/24.
//

import Foundation

import ReactorKit

final class ListViewReactor: Reactor {
    enum Action {
        case refresh
    }
    
    enum Mutation {
        case setSeoulWeathers(SectionOfWeather)
        case setLondonWeathers(SectionOfWeather)
        case setChicagoWeathers(SectionOfWeather)
        case setLoading(Bool)
        case setErrorMessage(String)
    }
    
    struct State {
        var seoulWeathers = [SectionOfWeather]()
        var londonWeathers = [SectionOfWeather]()
        var chicagoWeathers = [SectionOfWeather]()
        var isLoading = false
        var title = "Weather"
        @Pulse var errorMessage: String?
    }
    
    let initialState = State()
    
    private let networkService: NetworkServiceType
    
    init(networkService: NetworkServiceType) {
        self.networkService = networkService
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            let loadingOn: Observable<Mutation> = .just(.setLoading(true))
            let requests = Observable.merge(weathers(.seoul), weathers(.london), weathers(.chicago))
            let loadingOff: Observable<Mutation> = .just(.setLoading(false))
            
            return .concat(loadingOn, requests, loadingOff)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setSeoulWeathers(let weathers):
            newState.seoulWeathers = [weathers]
            
        case .setLondonWeathers(let weathers):
            newState.londonWeathers = [weathers]
            
        case .setChicagoWeathers(let weathers):
            newState.chicagoWeathers = [weathers]
            
        case .setLoading(let isLoading):
            newState.isLoading = isLoading
            
        case .setErrorMessage(let errorMessage):
            newState.errorMessage = errorMessage
        }
        
        return newState
    }
}

private extension ListViewReactor {
    func weathers(_ availableCity: AvailableCity) -> Observable<Mutation> {
        geocodeCity(city: availableCity)
            .flatMap { [weak self] city -> Observable<Mutation> in
                guard let self else { return .empty() }
                return fetchWeather(city: city, for: availableCity)
            }
            .catch { .just(.setErrorMessage($0.localizedDescription)) }
    }
    
    func geocodeCity(city: AvailableCity) -> Observable<City> {
        networkService.request(.geocoding(city: city))
            .map([City].self)
            .compactMap { $0.first }
    }
    
    func fetchWeather(city: City, for availableCity: AvailableCity) -> Observable<Mutation> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        return networkService.request(.forecast(city: city))
            .map([Weather].self, atKeyPath: "daily", using: decoder)
            .map { Array($0.prefix(5)) }
            .map { SectionOfWeather(header: city.name, items: $0) }
            .map { section in
                switch availableCity {
                case .seoul:
                    return .setSeoulWeathers(section)
                    
                case .london:
                    return .setLondonWeathers(section)
                    
                case .chicago:
                    return .setChicagoWeathers(section)
                }
            }
    }
}

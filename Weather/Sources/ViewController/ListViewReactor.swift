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
        case setSeoulWeathers
        case setLondonWeathers
        case setChicagoWeathers
        case setLoading(Bool)
        case setErrorMessage(String)
    }
    
    struct State {
        var seoulWeathers = [Any]()
        var londonWeathers = [Any]()
        var chicagoWeathers = [Any]()
        var isLoading = false
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
            return .merge(.just(.setSeoulWeathers), .just(.setLondonWeathers), .just(.setChicagoWeathers))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setSeoulWeathers:
            newState.seoulWeathers = [1, 2, 3]
            
        case .setLondonWeathers:
            newState.londonWeathers = [1, 2]
            
        case .setChicagoWeathers:
            newState.chicagoWeathers = [1, 2]
            
        case .setLoading(let isLoading):
            newState.isLoading = isLoading
            
        case .setErrorMessage(let errorMessage):
            newState.errorMessage = errorMessage
        }
        
        return newState
    }
}

//
//  NetworkProvider.swift
//  AppsHeroModPanel
//
//  Created by Ildar Khabibullin on 22.05.2025.
//

import Foundation
import Moya
import CombineMoya
import Combine

protocol NetworkProviderProtocol {
    func request<T: Decodable>(_ target: UsersTarget, type: T.Type) -> AnyPublisher<T, Error>
}

class NetworkProvider: NetworkProviderProtocol {
    private let provider = MoyaProvider<UsersTarget>()
    
    func request<T: Decodable>(_ target: UsersTarget, type: T.Type) -> AnyPublisher<T, Error> {
        return provider.requestPublisher(target)
            .filterSuccessfulStatusCodes()
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

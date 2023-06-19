//
//  NetworkClient.swift
//  MovieQuizTests
//
//  Created by Avtor_103 on 15.06.2023.
//

import Foundation
@testable import MovieQuiz

class StubNetworkClient: NetworkClientProtocol {
    private var emulateError: Bool
    
    init(emulateError: Bool) {
        self.emulateError = emulateError
    }
    
    func fetch(url: URL, onSuccess: @escaping (Data) -> Void, onFailure: @escaping (String) -> Void) {
        if emulateError {
            onFailure(MockResponseData.error)
        } else {
            onSuccess(MockResponseData.response)
        }
    }
}

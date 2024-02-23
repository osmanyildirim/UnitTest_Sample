//
//  NetworkResult.swift
//  UnitTest_Sample
//
//  Created by osmanyildirim on 24.05.2023.
//

import Foundation

public enum NetworkResult<T> {
    /// Successful response
    case success(T)
    
    /// Unsuccessful  response
    case failure(Error)
}

extension NetworkResult {
    /// Response is successful or unsuccessful
    var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }

    /// Error message when Response is unsuccessful
    /// errorMessage is nil when the Response is successful
    var errorMessage: String? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return (error as? CustomError)?.description ?? error.localizedDescription
        }
    }

    /// Model of response with generic T type
    var model: T? {
        switch self {
        case .success(let model):
            return model
        default:
            return nil
        }
    }
}

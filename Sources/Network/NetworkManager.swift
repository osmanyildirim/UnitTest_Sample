//
//  NetworkManager.swift
//  UnitTest_Sample
//
//  Created by osmanyildirim on 24.05.2023.
//

import Foundation

protocol NetworkProvider {
    @available(iOS 15.0, *)
    func requestAsync<T: Decodable>(_ service: APIs) async throws -> NetworkResult<T>

    func request<T: Decodable>(_ service: APIs, completion: @escaping (NetworkResult<T>) -> Void)
}

final class NetworkManager: NetworkProvider {
    let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    @available(iOS 15.0, *)
    func requestAsync<T: Decodable>(_ service: APIs) async throws -> NetworkResult<T> {
        guard let url = service.url else {
            throw CustomError.invalidURL
        }

        let request = URLRequest(url: url)
        let (data, response) = try await session.data(for: request)

        guard let response = response as? HTTPURLResponse else {
            throw CustomError.requestFailed
        }

        guard response.statusCode == 200 else {
            throw CustomError.badRequest
        }

        do {
            let model: T = try service.decoder.decode(T.self, from: data)
            return .success(model)
        } catch {
            throw CustomError.decodeError
        }
    }

    func request<T: Decodable>(_ service: APIs, completion: @escaping (NetworkResult<T>) -> Void) {
        guard let url = service.url else {
            completion(.failure(CustomError.invalidURL))
            return
        }

        let request = URLRequest(url: url)
        session.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(CustomError.requestFailed))
                return
            }

            guard httpResponse.statusCode == 200 else {
                completion(.failure(CustomError.badRequest))
                return
            }

            guard let error else {
                guard let data else {
                    completion(.failure(CustomError.invalidData))
                    return
                }

                do {
                    let model: T = try service.decoder.decode(T.self, from: data)
                    completion(.success(model))
                } catch {
                    completion(.failure(CustomError.decodeError))
                }

                return
            }
            completion(.failure(error))
        }.resume()
    }
}

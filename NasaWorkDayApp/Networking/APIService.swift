//
//  APIService.swift
//  NasaWorkDayApp
//
//  Created by Isiah Parra on 4/17/23.
//

import Foundation

struct APIService {
    func perform(_ request: URLRequest, completion: @escaping (Result<Data, NetworkingError>) -> Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.thrownError(error)))
            }
            if let response = response as? HTTPURLResponse {
                print("Completed with a response of", response.statusCode)
            }
            guard let data = data else {
                completion(.failure(.noData)); return
            }
            completion(.success(data))
        }.resume()
    }
}

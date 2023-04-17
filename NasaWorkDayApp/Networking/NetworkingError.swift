//
//  NetworkingError.swift
//  NasaWorkDayApp
//
//  Created by Isiah Parra on 4/13/23.
//

import Foundation
enum NetworkingError: LocalizedError {

    case invalidURL
    case thrownError(Error)
    case noData
    case unableToDecode
    case emptyArray
    case invalidStatusCode

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL. Check your endpoint."
        case .thrownError(let error):
            return "Thrown error. Error was \(error.localizedDescription)"
        case .noData:
            return "No data received from successful network fetch."
        case .unableToDecode:
            return "Unable to decode model object from data."
        case .emptyArray:
            return "Recipe Array from Recipe fetch returned an empty array."
        case .invalidStatusCode:
            return "Fetch returned an unsuccessful status code. Code was not 200."
        }
    }
}

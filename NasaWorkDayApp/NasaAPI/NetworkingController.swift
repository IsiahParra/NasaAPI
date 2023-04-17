//
//  NetworkingController.swift
//  NasaWorkDayApp
//
//  Created by Isiah Parra on 4/13/23.
//

import Foundation
import UIKit

struct NetworkController {
    
    /// Abstracted Struct to hold the URLSession.DataTask
    static let service = APIService()
    
#warning("Interviewer Note: I started with three functions. One to fetch with a search term, one to fetch an image, and one to fetch the next page. I took a moment and reflected on the duplication of code and set out to refactor to a single function solution. The image fetch I moved to a custome UIImage class. See ServiceRequestingIamgeView. The Search and the pagination functions I'll leave commented out below for you to review.")
    
    //    //MARK: Base URL
    //    static let baseURLString = "https://images-api.nasa.gov"
    
    //    //MARK: Fetching NASA data with a search term
    //    static func fetchNasaItemWith(searchTerm: String, completion: @escaping (Result<TopLevelAPIResponse, NetworkingError>) -> Void) {
    //        guard let baseURL = URL(string: baseURLString) else { completion(.failure(.invalidURL)); return}
    //
    //        let searchKey = URLQueryItem(name: "q", value: searchTerm)
    //        let mediaKey = URLQueryItem(name: "media_type", value: "image")
    //
    //        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
    //        urlComponents?.path = "/search"
    //        urlComponents?.queryItems = [searchKey,mediaKey]
    //
    //        guard let finalURL = urlComponents?.url else {
    //            completion(.failure(.invalidURL)); return}
    //        let request = URLRequest(url: finalURL)
    //        print(finalURL)
    //
    //        service.perform(request) { result in
    //            switch result {
    //            case .failure(let error):
    //                completion(.failure(.thrownError(error)))
    //            case .success(let nasaData):
    //                do {
    //                    let data = try JSONDecoder().decode(TopLevelAPIResponse.self, from: nasaData)
    //                    completion(.success(data))
    //                } catch {
    //                    completion(.failure(.unableToDecode))
    //                }
    //            }
    //        }
    //    }
    //
    //    //MARK: - Pagination Version 1
    //    static func fetchNextAssets(with urlString: String?, completion: @escaping (Result<TopLevelAPIResponse, NetworkingError>) -> Void) {
    //
    //        guard let urlString = urlString, let finalURL = URL(string: urlString) else { completion(.failure(.invalidURL)); return}
    //
    //        let request = URLRequest(url: finalURL)
    //        print(finalURL)
    //
    //        service.perform(request) { result in
    //            switch result {
    //            case .failure(let error):
    //                completion(.failure(.thrownError(error)))
    //            case .success(let nasaData):
    //                do {
    //                    let data = try JSONDecoder().decode(TopLevelAPIResponse.self, from: nasaData)
    //                    completion(.success(data))
    //                } catch {
    //                    completion(.failure(.unableToDecode))
    //                }
    //            }
    //        }
    //    }
    
    static func fetchNasaAssets(with endpoint: NasaEndpoint, completion: @escaping (Result<TopLevelAPIResponse, NetworkingError>) -> Void) {
        guard let url = endpoint.url else {return}
        let request = URLRequest(url: url)
        service.perform(request) { result in
            switch result {
            case .failure(let error):
                completion(.failure(.thrownError(error)))
            case .success(let nasaData):
                do {
                    let data = try JSONDecoder().decode(TopLevelAPIResponse.self, from: nasaData)
                    completion(.success(data))
                } catch {
                    completion(.failure(.unableToDecode))
                }
            }
        }
    }
}

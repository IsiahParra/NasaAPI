//
//  NasaEndpoint.swift
//  NasaWorkDayApp
//
//  Created by Isiah Parra on 4/17/23.
//

import Foundation
// lighteight and value typed
enum NasaEndpoint {
    case search(String)
    case nextPage(String)
    
    var url: URL? {
        switch self {
        case .search(let searchTerm):
            // return a fully formated URL with the search term
            guard let baseURL = URL(string: "https://images-api.nasa.gov") else {return nil}
            
            let searchKey = URLQueryItem(name: "q", value: searchTerm)
            let mediaKey = URLQueryItem(name: "media_type", value: "image")
            var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
            urlComponents?.path = "/search"
            urlComponents?.queryItems = [searchKey,mediaKey]
        
            return urlComponents?.url
        case .nextPage(let nextURLString):
            // retrun a fully formatted URL that is the next URL
            let nextURL = URL(string: nextURLString)
            return nextURL
        }
    }
}

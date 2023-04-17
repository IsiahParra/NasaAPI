//
//  NasaModel.swift
//  NasaWorkDayApp
//
//  Created by Isiah Parra on 4/13/23.
//

import Foundation
struct TopLevelAPIResponse: Decodable {
    let collection: NasaCollection
}

struct NasaCollection: Decodable {
    private enum CodingKeys: String, CodingKey {
        case currentURL = "href"
        case assets = "items"
        case pageLinks = "links"
    }
    
    let currentURL: String
    let assets: [Asset]
    let pageLinks: [PageLink]
}

/// Pagination links
struct PageLink: Decodable {
    private enum CodingKeys: String, CodingKey {
        case rel
        case prompt
        case urlString = "href"
    }
    let rel: String
    let prompt: String
    let urlString: String
}
/// Single Nasa Asset. Holds all applicable data
struct Asset: Decodable {
    private enum CodingKeys: String, CodingKey {
        case assetsArray = "data"
        case links
    }
    let assetsArray: [MetaData]
    let links: [MetaDataLinks]
}

/// Metadata for Nasa Assets
struct MetaData: Decodable {
    let title: String
    let description: String
    let keywords: [String]
}

/// Links from each Asset to indiviudal Image
struct MetaDataLinks: Decodable {
    private enum CodingKeys: String, CodingKey {
        case imageString = "href"
    }
    let imageString: String// coding key here
}

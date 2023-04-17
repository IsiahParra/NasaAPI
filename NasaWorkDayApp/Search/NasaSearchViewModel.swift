//
//  NasaSearchViewModel.swift
//  NasaWorkDayApp
//
//  Created by Isiah Parra on 4/17/23.
//

import Foundation
protocol NasaSearchViewModelDelegate: AnyObject {
    func dataLoadedSuccessfully()
    func encountered(_ error: Error)
}

class NasaSearchViewModel {
    
    var nasaItems: [Asset] = []
    var topLevelDictionary: TopLevelAPIResponse?
    let dataProvider: NasaAssetDataProvider
    weak var delegate: NasaSearchViewModelDelegate?
    // Dependency Injection.
    init(delegate: NasaSearchViewModelDelegate, dataProvider: NasaAssetDataProvider = NasaAssetDataProvider()) {
        self.delegate = delegate
        self.dataProvider = dataProvider
    }
    // Fetch the data
    func fetch(with searchTerm: String?) {
        if let searchTerm = searchTerm {
            dataProvider.fetchNasaAssets(with: NasaEndpoint.search(searchTerm)) { [weak self] result in
                switch result {
                case.failure(let error):
                    self?.delegate?.encountered(error)
                case .success(let tld):
                    self?.topLevelDictionary = tld
                    self?.nasaItems =
                    tld.collection.assets
                    self?.delegate?.dataLoadedSuccessfully()
                }
            }
        } else {
            guard let nextDict = topLevelDictionary?.collection.pageLinks.filter({$0.prompt == "Next"}) else {return}
            let urlString = nextDict[0].urlString
            dataProvider.fetchNasaAssets(with: NasaEndpoint.nextPage(urlString)) { [weak self] result in
                switch result {
                case.failure(let error):
                    self?.delegate?.encountered(error)
                case .success(let tld):
                    self?.topLevelDictionary = tld
                    self?.nasaItems.append(contentsOf: tld.collection.assets)
                    self?.delegate?.dataLoadedSuccessfully()
                }
            }
        }
    }
}

//
//  NasaSearchTableViewController.swift
//  NasaWorkDayApp
//
//  Created by Isiah Parra on 4/13/23.
//

import UIKit

class NasaSearchTableViewController: UITableViewController {
    //MARK: Outlets
    @IBOutlet var nasaSearchBar: UISearchBar!
    
    //MARK: Properties
    var nasaItems: [Asset] = []
    var topLevelDictionary: TopLevelAPIResponse?
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        nasaSearchBar.delegate = self
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nasaItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NasaCell", for: indexPath) as? NasaTableViewCell else {return UITableViewCell()}
        let nasaItem = nasaItems[indexPath.row]
        cell.configure(for: nasaItem)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // When do I want to fetch more results?
        // When the user gets close to the end of the TableView, I'll fetch the next page
        let lastIndex = tableView.numberOfRows(inSection: indexPath.section) - 1
        if indexPath.row == lastIndex {
            // fetch more data
            guard let nextDict = topLevelDictionary?.collection.pageLinks.filter({$0.prompt == "Next"}) else {return}
            let urlString = nextDict[0].urlString
            //Capturing the closure weakly to prevent a retain cycle. Using a Capture List to do so.
            NetworkController.fetchNasaAssets(with: NasaEndpoint.nextPage(urlString)) { [weak self] result in
                guard let self = self else {return}
                switch result {
                case .success(let apiResponse):
                    DispatchQueue.main.async {
                        // Adding the new data to the local array
                        self.nasaItems.append(contentsOf: apiResponse.collection.assets)
                        self.topLevelDictionary = apiResponse
                        self.tableView.reloadData()
                    }
                case .failure(let searchError):
                    print(searchError.errorDescription!)
                }
            }
        }
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "toDetailVC",
              let indexPath = tableView.indexPathForSelectedRow,
              let cell = sender as? NasaTableViewCell,
              let destination = segue.destination as? NasaDetailViewController else { return }
        // Sending the image from the cell to the DetailVC so we do not need to perform another network call.
        destination.image = cell.nasaImageView.image
        // Pulling the `assest` from our array that matches the row the user segued from.
        destination.nasaItem = nasaItems[indexPath.row]
    }
}

extension NasaSearchTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text else { return }
        NetworkController.fetchNasaAssets(with: NasaEndpoint.search(searchTerm)) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let apiResponse):
                DispatchQueue.main.async {
                    // Setting the inital state of our local array
                    self.nasaItems = apiResponse.collection.assets
                    self.topLevelDictionary = apiResponse
                    self.tableView.reloadData()
                }
            case .failure(let searchError):
                print(searchError.errorDescription!)
            }
        }
    }
    //        NetworkController.fetchNasaItemWith(searchTerm: searchTerm) { [weak self] result in
    //            guard let self = self else {return}
    //            switch result {
    //            case .success(let apiResponse):
    //                DispatchQueue.main.async {
    //                    self.nasaItems = apiResponse.collection.assets
    //                    self.topLevelDictionary = apiResponse
    //                    self.tableView.reloadData()
    //                }
    //            case .failure(let searchError):
    //                print(searchError.errorDescription!)
    //            }
    //        }
//}
}

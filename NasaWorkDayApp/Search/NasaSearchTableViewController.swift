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
    var viewModel: NasaSearchViewModel!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = NasaSearchViewModel(delegate: self)
        nasaSearchBar.delegate = self
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.nasaItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NasaCell", for: indexPath) as? NasaTableViewCell else {return UITableViewCell()}
        let nasaItem = viewModel.nasaItems[indexPath.row]
        cell.configure(for: nasaItem)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // When do I want to fetch more results?
        // When the user gets close to the end of the TableView, I'll fetch the next page
        let lastIndex = tableView.numberOfRows(inSection: indexPath.section) - 1
        if indexPath.row == lastIndex {
            // fetch more data
            viewModel.fetch(with: nil)
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
        destination.nasaItem = viewModel.nasaItems[indexPath.row]
    }
}

extension NasaSearchTableViewController: NasaSearchViewModelDelegate {
    
    func encountered(_ error: Error) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Close", style: .cancel))
            self.present(alertController, animated: true)
        }
    }
    
    func dataLoadedSuccessfully() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
extension NasaSearchTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.fetch(with: searchBar.text)
    }
}

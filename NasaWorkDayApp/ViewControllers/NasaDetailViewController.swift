//
//  NasaDetailViewController.swift
//  NasaWorkDayApp
//
//  Created by Isiah Parra on 4/13/23.
//

import UIKit

class NasaDetailViewController: UIViewController {
    
    @IBOutlet var searchedImageView: UIImageView!
    @IBOutlet var searchedTitleLabel: UILabel!
    @IBOutlet var nasaDescriptionLabel: UILabel!
    
    var nasaItem: Asset?
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        guard let nasaItem = nasaItem else {return}
        nasaDescriptionLabel.text = nasaItem.assetsArray.first?.description
        searchedTitleLabel.text = nasaItem.assetsArray.first?.title
        searchedImageView.image = image ?? UIImage(systemName: "photo")
    }
}

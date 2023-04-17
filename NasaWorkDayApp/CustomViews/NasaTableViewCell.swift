//
//  NasaTableViewCell.swift
//  NasaWorkDayApp
//
//  Created by Isiah Parra on 4/13/23.
//

import UIKit

class NasaTableViewCell: UITableViewCell {
    
    @IBOutlet var nasaImageView: ServiceRequestingImageView!
    @IBOutlet var nasaTitleLabel: UILabel!
    
    override func prepareForReuse() {
        nasaTitleLabel.text = nil
        nasaImageView.image = nil
    }
    
    func configure(for nasaAsset: Asset) {
        nasaTitleLabel.text = nasaAsset.assetsArray.first?.title
        guard let imageURL = URL(string: nasaAsset.links[0].imageString) else {return}
        nasaImageView.fetchImage(using: imageURL)
    }
}

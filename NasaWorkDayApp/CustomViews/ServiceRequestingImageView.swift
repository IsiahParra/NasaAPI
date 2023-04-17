//
//  ServiceRequestingImageView.swift
//  NasaWorkDayApp
//
//  Created by Isiah Parra on 4/17/23.
//

import UIKit
// custom imageview 
class ServiceRequestingImageView: UIImageView {
    private let service = APIService()
    func fetchImage(using url: URL) {
        let request = URLRequest(url: url)
        service.perform(request) { [weak self] result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else {
                    self?.setDefaultImage()
                    return
                }
                DispatchQueue.main.async {
                    self?.contentMode = .scaleAspectFill
                    self?.image = image
                }
            case .failure:
                self?.setDefaultImage()
            }
        }
    }
    
    func setDefaultImage() {
        DispatchQueue.main.async {
            self.contentMode = .scaleAspectFit
            self.image = UIImage(systemName: "photo")
        }
    }
}


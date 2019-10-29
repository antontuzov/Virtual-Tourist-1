//
//  ImagesCollectionVC.swift
//  Virtual Tourist
//
//  Created by Vitaliy Paliy on 10/29/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit

class ImagesCollectionVC: UIViewController {

    var locationImages = [String]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    

}

extension ImagesCollectionVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return locationImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCollectionViewCell
        
        let image = locationImages[indexPath.row]
        
        FlickrClient.downloadImage(img: image) { (data, error) in
            if let data = data {
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    cell.imageView.image = image
                }
            }
        }
        
        
        return cell
    }
    
    
}

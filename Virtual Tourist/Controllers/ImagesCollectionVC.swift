//
//  ImagesCollectionVC.swift
//  Virtual Tourist
//
//  Created by Vitaliy Paliy on 10/29/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import MapKit

class ImagesCollectionVC: UIViewController {

    var selectedPin: MKPointAnnotation?
    var selectedImgURL: [String]!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        
        print("Refresh button pressed")
        
    }
    
}

extension ImagesCollectionVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImgURL.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCollectionViewCell
        
        let image = selectedImgURL[indexPath.row]
        
        FlickrClient.downloadImage(img: image) { (data, error) in
            if let data = data {
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    cell.imageView.image = image
                }
                cell.setNeedsLayout()
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedImgURL.remove(at: indexPath.row)
        collectionView.reloadData()
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
}

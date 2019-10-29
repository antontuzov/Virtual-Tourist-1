//
//  ViewController.swift
//  Virtual Tourist
//
//  Created by Vitaliy Paliy on 10/28/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController {
    
    let lat = 55.751742
    let long = 37.618337
    
    var imageUrls = [String]()
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func addPressed(_ sender: Any) {
    
        FlickrClient.getSearchURL(lat: lat, long: long, totalPageNum: 50) { (images, pages, error) in
            guard error == nil else {
                print("Error!")
                return
            }
            for i in images {
                self.imageUrls.append(i.url_m)
            }
            print(self.imageUrls.count)
            let controller = self.storyboard?.instantiateViewController(identifier: "ImagesCollectionVC") as! ImagesCollectionVC
            controller.locationImages = self.imageUrls
            self.show(controller, sender: nil)
        }
    
    }
    
    
    
}


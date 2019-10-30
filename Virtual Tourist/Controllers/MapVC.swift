//
//  ViewController.swift
//  Virtual Tourist
//
//  Created by Vitaliy Paliy on 10/28/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController{
    
    var lat = Double()
    var long = Double()
    var imageURL = [String]()
    var selectedAnnotation: MKPointAnnotation?
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        let longPressGestureRecogn = UILongPressGestureRecognizer(target: self, action: #selector(self.addAnnotation(press:)))
        longPressGestureRecogn.minimumPressDuration = 0.5
        mapView.addGestureRecognizer(longPressGestureRecogn)
        
    }
    
    @objc func addAnnotation(press: UILongPressGestureRecognizer) {
        
        if press.state == .began {
            
            let location = press.location(in: mapView)
            let coordinates = mapView.convert(location, toCoordinateFrom: mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            lat = annotation.coordinate.latitude
            long = annotation.coordinate.longitude
            mapView.addAnnotation(annotation)
            let cl = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
            CLGeocoder().reverseGeocodeLocation(cl) { (placemark, error) in
                if error != nil {
                    annotation.title = "Unknown"
                }else{
                    if let place = placemark?[0] {
                        annotation.title = "\(place.locality ?? "Unknown"), \(place.country ?? "Unknown")"
                    }
                }
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        imageURL = []
    }
    
    func handleGetImages(){
        FlickrClient.getSearchURL(lat: selectedAnnotation?.coordinate.latitude ?? 0, long: selectedAnnotation?.coordinate.longitude ?? 0, totalPageNum: 50) { (images, pages, error) in
            guard error == nil else {
                print("Error!")
                return
            }
            for i in images {
                self.imageURL.append(i.url_m)
            }
            print(self.imageURL.count)
            let controller = self.storyboard?.instantiateViewController(identifier: "ImagesCollectionVC") as! ImagesCollectionVC
            controller.selectedPin = self.selectedAnnotation
            controller.selectedImgURL = self.imageURL
            self.show(controller, sender: nil)
        }
    }
    
}

extension MapVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil{
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }else{
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView{
            handleGetImages()
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.selectedAnnotation = view.annotation as? MKPointAnnotation
    }
    
    
}

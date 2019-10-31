//
//  ViewController.swift
//  Virtual Tourist
//
//  Created by Vitaliy Paliy on 10/28/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapVC: UIViewController, NSFetchedResultsControllerDelegate, MKMapViewDelegate{
    
    var dataController: DataController!
    var fetchresultController: NSFetchedResultsController<Pin>!
    
    @IBOutlet weak var mapView: MKMapView!
    
    func setupFRC() {
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        fetchRequest.sortDescriptors = []
        fetchresultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchresultController.delegate = self
        do {
            try fetchresultController.performFetch()
        }catch {
            print("Error while trying to fetch data: \(error.localizedDescription)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFRC()
        mapView.addAnnotations(fetchresultController.fetchedObjects ?? [])
        setupLongPressGesture()
        mapView.delegate = self
    }
    
    func setupLongPressGesture() {
        let longPressGestureRecogn = UILongPressGestureRecognizer(target: self, action: #selector(self.addAnnotation(press:)))
        longPressGestureRecogn.minimumPressDuration = 0.5
        mapView.addGestureRecognizer(longPressGestureRecogn)
    }

    func annotationHandler(location: CLLocationCoordinate2D){
        let annotation = Pin(context: dataController.viewContext)
        annotation.latitude = location.latitude
        annotation.longitude = location.longitude
        if dataController.viewContext.hasChanges {
            try? dataController.viewContext.save()
        }
        mapView.addAnnotation(annotation)
    }
    
    @objc func addAnnotation(press: UILongPressGestureRecognizer) {
        if press.state == .began {
            let place = press.location(in: mapView)
            let location = mapView.convert(place, toCoordinateFrom: mapView)
            annotationHandler(location: location)
        }
    }
    
    
    
}

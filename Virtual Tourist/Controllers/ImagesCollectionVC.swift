//
//  ImagesCollectionVC.swift
//  Virtual Tourist
//
//  Created by Vitaliy Paliy on 10/29/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class ImagesCollectionVC: UIViewController {
    
    var selectedPin: Pin!
    var dataController: DataController!
    var fetchedResultsController: NSFetchedResultsController<Photo>!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func setupFRC(){
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        let predicate = NSPredicate(format: "pin == %@", selectedPin)
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = predicate
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        }catch{
            print("Error: \(error.localizedDescription)")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupFRC()
        if fetchedResultsController.fetchedObjects?.count == 0{
            FlickrClient.getSearchURL(lat: selectedPin.coordinate.latitude, long: selectedPin.coordinate.longitude, totalPageNum: 25, completion: handlerPhotoSearch(photosResponse:error:))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fetchedResultsController = nil
    }
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        print("Refresh button pressed")
    }
 
    func handlerPhotoSearch(photosResponse: [PhotoStruct], error: Error?){
        if photosResponse.count == 0 {
            print("No images")
        }
        for i in photosResponse {
            FlickrClient.downloadImage(farm: i.farm, serverId: i.server, photoId: i.id, secret: i.secret, completion: downloadHandler(data:error:))
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    func downloadHandler(data: Data?, error: Error?){
        print("It ss")
        if data == nil { return }
        let photo = Photo(context: dataController.viewContext)
        photo.image = data
        photo.pin = selectedPin
        photo.creationDate = Date()
        if dataController.viewContext.hasChanges {
            try? dataController.viewContext.save()
        }
    }
    
}

extension ImagesCollectionVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let images = fetchedResultsController.fetchedObjects {
            return images.count
        }else{
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCollectionViewCell
        cell.imageView.image = UIImage(data: fetchedResultsController.object(at: indexPath).image!)
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        selectedImgURL.remove(at: indexPath.row)
//        collectionView.reloadData()
//        collectionView.deselectItem(at: indexPath, animated: true)
//    }
    
}

extension ImagesCollectionVC: NSFetchedResultsControllerDelegate {
    
}

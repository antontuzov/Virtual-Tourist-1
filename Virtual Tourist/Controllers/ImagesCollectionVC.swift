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
    var fetchedResults = 0
    @IBOutlet weak var statusIndicator: UIActivityIndicatorView!
    @IBOutlet weak var informationView: UIView!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
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
            informationView.isHidden = true
            getImages()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        if fetchedResults != 0 {
            informationView.isHidden = true
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fetchedResultsController = nil
    }
    
    func getImages(){
        FlickrClient.getSearchURL(lat: selectedPin.coordinate.latitude, long: selectedPin.coordinate.longitude, totalPageNum: 25, completion: handlerPhotoSearch(photosResponse:error:))
    }
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        checkStatus(true)
        let delete = fetchedResultsController.fetchedObjects
        for i in 0...delete!.count{
            if i <= delete!.count - 1{
                print("For i:\(i)")
                dataController.viewContext.delete(delete![i])
                print("Count: \(delete!.count)")
                try? dataController.viewContext.save()
            }
            
        }
        getImages()
        if dataController.viewContext.hasChanges {
            try? dataController.viewContext.save()
        }
        informationView.isHidden = true
        
    }
    
    func handlerPhotoSearch(photosResponse: [PhotoStruct], error: Error?){
        if photosResponse.count == 0 {
            print("No images")
            informationView.isHidden = false
        }else{
            for i in photosResponse {
                FlickrClient.downloadImage(farm: i.farm, serverId: i.server, photoId: i.id, secret: i.secret, completion: downloadHandler(data:error:))
            }
            fetchedResults = fetchedResultsController.fetchedObjects?.count ?? 0
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.informationView.isHidden = true
            }
            refreshButton.isEnabled = true
        }
        checkStatus(false)
    }
    
    func downloadHandler(data: Data?, error: Error?){
        print("Loading images")
        if data == nil { return }
        let photo = Photo(context: dataController.viewContext)
        photo.image = data
        photo.pin = selectedPin
        photo.creationDate = Date()
        if dataController.viewContext.hasChanges {
            try? dataController.viewContext.save()
        }
    }
    
    func checkStatus(_ status: Bool){
        if status {
            DispatchQueue.main.async {
                self.statusIndicator.startAnimating()
            }
        }else{
            DispatchQueue.main.async {
                self.statusIndicator.stopAnimating()
            }
        }
        refreshButton.isEnabled = !status
    }
    
}

extension ImagesCollectionVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCollectionViewCell
        cell.imageView.image = UIImage(data: fetchedResultsController.object(at: indexPath).image!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageToRemove = fetchedResultsController.object(at: indexPath)
        dataController.viewContext.delete(imageToRemove)
        if dataController.viewContext.hasChanges {
            try? dataController.viewContext.save()
        }
    }
    
}


extension ImagesCollectionVC: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            collectionView.insertItems(at: [newIndexPath!])
        case .delete:
            collectionView.deleteItems(at: [indexPath!])
        default:
            break
        }
    }
    
}

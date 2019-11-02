//
//  NSFRC + Extension.swift
//  Virtual Tourist
//
//  Created by Vitaliy Paliy on 11/1/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import Foundation
import CoreData

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

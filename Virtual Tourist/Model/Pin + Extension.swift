//
//  Pin + Extension.swift
//  Virtual Tourist
//
//  Created by Vitaliy Paliy on 10/31/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import Foundation
import MapKit

extension Pin:MKAnnotation {
    public var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude as Double, longitude: longitude as Double)
    }
}

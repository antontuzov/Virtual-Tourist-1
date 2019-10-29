//
//  FlickrResponse.swift
//  Virtual Tourist
//
//  Created by Vitaliy Paliy on 10/29/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import Foundation

struct FlickrResponse: Codable {
    let photos: Photos
    let stat: String
}

struct Photos: Codable{
    let page: Int
    let pages: Int
    let perpage: Int
    let total: String
    let photo: [PhotoStruct]
}

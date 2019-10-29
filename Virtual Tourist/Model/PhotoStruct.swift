//
//  PhotoStruct.swift
//  Virtual Tourist
//
//  Created by Vitaliy Paliy on 10/29/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import Foundation
import UIKit

struct PhotoStruct: Codable {
    var photoImage: UIImage?
    let id, owner, secret, server: String
    let farm: Int
    let title: String
    let ispublic, isfriend, isfamily: Int
    let url_m: String
    
    enum CodingKeys: String, CodingKey {
        case id, owner, secret, server, farm, title, ispublic, isfriend, isfamily
        case url_m = "url_m"
    }
}

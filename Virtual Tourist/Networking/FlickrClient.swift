//
//  Networking.swift
//  Virtual Tourist
//
//  Created by Vitaliy Paliy on 10/28/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import Foundation

class FlickrClient {
    
    static let ApiKey = "&api_key=\(API.key)"
    
    static let secret = "\(API.secret)"
    
    enum Endpoints {
        static var base = "https://www.flickr.com/services/rest/?method=flickr.photos.search"
        static var radius = 20
        case searchURL(Double, Double, Int, Int)
        
        var urlString: String {
            switch self {
            case .searchURL(let latitude, let longitude, let perPage, let pageNum):
                return Endpoints.base + ApiKey + "&lat=\(latitude)" + "&lon=\(longitude)" + "&radius=\(Endpoints.radius)" + "&per_page=\(perPage)" + "&page=\(pageNum)" + "&format=json&nojsoncallback=1&extras=url_m"
            }
        }
        
        var url: URL {
            return URL(string: urlString)!
        }
        
    }
    
    // Get links to the images.
    
    class func getSearchURL(lat: Double, long: Double, totalPageNum: Int = 0,completion: @escaping ([PhotoStruct], Int, Error?) -> Void){
        
        let url = Endpoints.searchURL(lat, long, totalPageNum, 100).url
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print("Error happened while getting search URL: \(error!.localizedDescription)")
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(FlickrResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject.photos.photo,responseObject.photos.pages,nil)
                }
                print("Success")
            }catch{
                print("Error while trying to get response object")
            }
        }
        task.resume()
    }
    
    class func downloadImage(img: String, completion: @escaping (Data?, Error?) -> Void){
        
        let url = URL(string: img)
        
        guard let imageURL = url else {
            print("Error while downloading images")
            DispatchQueue.main.async {
                completion(nil, nil)
            }
            return
        }
        let request = URLRequest(url: imageURL)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                completion(data, nil)
            }
        }
        task.resume()
    }
    
}

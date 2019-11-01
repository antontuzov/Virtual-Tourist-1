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
        static var test = "https://farm8.staticflickr.com/7409/9256183076_faf2883a07.jpg"
        static var base = "https://www.flickr.com/services/rest/?method=flickr.photos.search"
        static var radius = 20
        case searchURL(Double, Double, Int, Int)
        case downloadImage(Int, String, String, String)
        
        var urlString: String {
            switch self {
            case .searchURL(let latitude, let longitude, let perPage, let pageNum):
                return Endpoints.base + ApiKey + "&lat=\(latitude)" + "&lon=\(longitude)" + "&radius=\(Endpoints.radius)" + "&per_page=\(perPage)" + "&page=\(pageNum)" + "&format=json&nojsoncallback=1&extras=url_m"
            case .downloadImage(let farm, let serverId, let photoId, let secret): return "https://farm\(farm).staticflickr.com/\(serverId)/\(photoId)_\(secret).jpg"
            }
        }
        
        var url: URL {
            return URL(string: urlString)!
        }
        
    }
    
   
    
    class func getRandomPage() -> Int{
        
        return Int(arc4random_uniform(50))
    
    }
   
    // Get links to the images.
    
    class func getSearchURL(lat: Double, long: Double, totalPageNum: Int = 0,completion: @escaping ([PhotoStruct], Error?) -> Void){
        
        let url = Endpoints.searchURL(lat, long, totalPageNum, getRandomPage()).url
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print("Error happened while getting search URL: \(error!.localizedDescription)")
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(FlickrResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject.photos.photo,nil)
                }
                print("Success")
            }catch{
                print("Error while trying to get response object")
            }
        }
        task.resume()
    }
    
    // Loads pictures
    
    class func downloadImage(farm: Int, serverId: String, photoId: String, secret: String, completion: @escaping (Data?, Error?) -> Void){
        
        let request = Endpoints.downloadImage(farm, serverId, photoId, secret).url
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                print("Error while trying to download an image")
                completion(nil, error)
                return
            }
            completion(data, nil)
        }
        task.resume()
    }
    
}

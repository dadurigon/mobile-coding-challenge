//
//  UnsplashClient.swift
//  UnsplashDemo
//
//  Created by Developer on 2018-01-09.
//  Copyright © 2018 Dion Durigon. All rights reserved.
//

import Foundation

class UnspashClient: NSObject, URLSessionDelegate {
    
    func fetchCuratedPhotos(page: Int = 1, completion: @escaping ([Photo]) -> ()) {
        
        let sessionConfig = URLSessionConfiguration.default
        
        /* Create session, and optionally set a URLSessionDelegate. */
        let session = URLSession(configuration: sessionConfig, delegate: self, delegateQueue: OperationQueue.main)
        
        guard let URL = URL(string: "https://api.unsplash.com/photos/curated?page=\(page)") else {return}
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        
        // Headers
        request.addValue("v1", forHTTPHeaderField: "Accept-Version")
        request.addValue("Client-ID 8373eb3329552967edf00c1b7fd9bfd1ab0f0c5b42cade19d49e55cffc57717d", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            guard error == nil else {
                print("error calling GET on /photos/curated")
                print(error!)
                return
            }
            
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            //            let statusCode = (response as! HTTPURLResponse).statusCode
            //            print("URL Session Task Succeeded: HTTP \(statusCode)")
            
            do {
                guard let photos = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [[String:Any?]] else {
                        print("error trying to convert data to JSON")
                        return
                }
                
                var newPhotos: [Photo] = []
                
                for photo in photos {
                    guard let photoID = photo["id"] as? String else {
                        print("Could not get id title from JSON")
                        return
                    }
                    
                    let width = photo["width"] as? Int ?? 0
                    let height = photo["height"] as? Int ?? 0
                    let likedByUser = photo["liked_by_user"] as? Bool ?? false
                    let description = photo["description"] as? String ?? ""
                    let urls = photo["urls"] as? [String:String] ?? [:]
                    
                    let newPhoto = Photo(id: photoID, width: width, height: height, likes: 0, likedByUser: likedByUser, description: description, urls: urls, photoImage: nil)
                    
                    newPhotos.append(newPhoto)
                }
                
                completion(newPhotos)
                
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
            
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        completionHandler(.useCredential, urlCredential)
    }
}

//
//  Photo.swift
//  UnsplashDemo
//
//  Created by Developer on 2018-01-09.
//  Copyright © 2018 Dion Durigon. All rights reserved.
//

import UIKit

enum PhotoSize: String {
    case raw
    case full
    case regular
    case small
    case thumb
}

struct Photo {
    let id: String
    let width: Int
    let height: Int
    let likes: Int
    let likedByUser: Bool
    let description: String
    let urls: [String:String]
    var photoImage: UIImage?
    
    var photoURL: URL? {
        get {
            if let stringURL = urls[PhotoSize.regular.rawValue] {
                return URL(string: stringURL)
            }
            
            return nil
        }
    }
}

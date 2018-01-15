//
//  PhotoCollectionViewCell.swift
//  UnsplashDemo
//
//  Created by Developer on 2018-01-09.
//  Copyright © 2018 Dion Durigon. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
    }
    
    override func willTransition(from oldLayout: UICollectionViewLayout, to newLayout: UICollectionViewLayout) {
        if newLayout is CarouselLayout {
            self.infoView.isHidden = false
        } else {
            self.infoView.isHidden = true
        }
    }
}

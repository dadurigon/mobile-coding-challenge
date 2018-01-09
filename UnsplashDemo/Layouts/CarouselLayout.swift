//
//  CarouselLayout.swift
//  UnsplashDemo
//
//  Created by Developer on 2018-01-08.
//  Copyright © 2018 Dion Durigon. All rights reserved.
//

import UIKit

class CarouselLayout: UICollectionViewFlowLayout {

    var itemHeight: CGFloat = 250

    init(itemHeight: CGFloat) {
        super.init()
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0

        self.scrollDirection = UICollectionViewScrollDirection.horizontal
        self.itemHeight = itemHeight
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var itemSize: CGSize {
        get {
            if let collectionView = collectionView {
                let itemWidth: CGFloat = collectionView.frame.width
                let itemHeight: CGFloat = collectionView.frame.height
                return CGSize(width: itemWidth, height: itemHeight)
            }

            // Default fallback
            return CGSize(width: 150, height: 150)
        }
        set {
            super.itemSize = newValue
        }
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return proposedContentOffset
    }
    
}

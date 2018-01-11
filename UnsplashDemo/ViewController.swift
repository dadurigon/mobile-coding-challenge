//
//  ViewController.swift
//  UnsplashDemo
//
//  Created by Developer on 2018-01-08.
//  Copyright © 2018 Dion Durigon. All rights reserved.
//

import UIKit

private let reuseIdentifier = "cell"

class ViewController: UIViewController  {

    @IBOutlet weak var collectionView: UICollectionView!
 
    var gridLayout: GridLayout!
    lazy var carouselLayout: CarouselLayout = {
        var carouselLayout = CarouselLayout(itemHeight: 180)
        return carouselLayout
    }()
    
    var photos: [Photo] = []
    var page = 1
    var currentIndex: IndexPath?
    
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    func switchLayout() {
        if collectionView.collectionViewLayout == gridLayout {
            // carousel layout
            self.collectionView.isPagingEnabled = true
            self.collectionView.alwaysBounceVertical = false
            self.collectionView.alwaysBounceHorizontal = true
            UIView.animate(withDuration: 1.0, animations: {
                self.collectionView.collectionViewLayout.invalidateLayout()
                
                self.collectionView.setCollectionViewLayout(self.carouselLayout, animated: true)
            })
        } else {
            // grid layout
            self.collectionView.isPagingEnabled = false
            self.collectionView.alwaysBounceVertical = true
            self.collectionView.alwaysBounceHorizontal = false
            UIView.animate(withDuration: 1.0, animations: {
                self.collectionView.collectionViewLayout.invalidateLayout()
                
                self.collectionView.setCollectionViewLayout(self.gridLayout, animated: true)
            })
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Unsplash"
        self.view.addSubview(activityView)
        activityView.hidesWhenStopped = true
        activityView.center = self.view.center
        activityView.startAnimating()
        
        loadData(page: 1)
        
        gridLayout = GridLayout(numberOfColumns: 3)
        collectionView.collectionViewLayout = gridLayout
        collectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadData(page: Int) {
        UnspashClient().fetchCuratedPhotos(page: page) { photoArray in
            if photoArray.count > 0 {
                self.photos += photoArray
                self.collectionView?.reloadData()
                self.activityView.stopAnimating()
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCollectionViewCell
        
//        debugPrint("Layout: \(self.collectionView.collectionViewLayout)")
        
        let unsplash = self.photos[indexPath.row]
        
        cell.nameLabel.text = unsplash.id
        cell.descriptionLabel.text = unsplash.description
        
        
        if let photo = unsplash.photoImage {
            cell.imageView.image = photo
        } else if let url = unsplash.photoURL {
            DispatchQueue.global().async {
                if let photoData = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        let image = UIImage(data: photoData)
                        self.photos[indexPath.row].photoImage = image
                        cell.imageView.image = image
                    }
                }
            }
        }
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switchLayout()
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        var shouldLoadMore = false
        
        if collectionView.collectionViewLayout == carouselLayout {
            self.collectionView?.contentOffset.x = scrollView.contentOffset.x
            
            let offsetX = scrollView.contentOffset.x
            let scrollWidth = scrollView.frame.size.width
            let contentWidth = scrollView.contentSize.width
            
            if ((offsetX + scrollWidth) >= contentWidth) {
                shouldLoadMore = true
            }
            
        } else {
            let offsetY = scrollView.contentOffset.y
            let scrollHeight = scrollView.frame.size.height
            let contentHeight = scrollView.contentSize.height
            
            if ((offsetY + scrollHeight) >= contentHeight) {
                shouldLoadMore = true
            }
        }
        
        if shouldLoadMore {
            self.page += 1
            loadData(page: self.page)
        }
    }
}

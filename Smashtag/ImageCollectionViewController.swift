//
//  ImageCollectionViewController.swift
//  Smashtag
//
//  Created by nevercry on 10/1/15.
//  Copyright © 2015 nevercry. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class ImageCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var tweets: [[Tweet]] = [] {
        didSet {
            images = tweets.reduce([], combine: +).map {
                tweet in tweet.media.map { TweetMedia(tweet: tweet, media: $0) }
            }.reduce([], combine: +)
        }
    }
    
    var images = [TweetMedia]()
    
    struct TweetMedia: CustomStringConvertible {
        var tweet: Tweet
        var media: MediaItem
        
        var description: String { return "\(tweet): \(media)" }
    }
    
    var cache = NSCache()
    
    var scale: CGFloat = 1 { didSet { collectionView?.collectionViewLayout.invalidateLayout() } }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: "zoom:"))
    }
    
    func zoom(gesture: UIPinchGestureRecognizer) {
        if gesture.state == .Changed {
            scale *= gesture.scale
            gesture.scale = 1.0
        }
    }

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: - UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    private struct Storyboard {
        static let CellResueIdentifier = "Image Cell"
        static let CellArea: CGFloat = 4000
        static let SegueIdentifier = "Show Tweet"
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Storyboard.CellResueIdentifier, forIndexPath: indexPath) as! ImageCollectionViewCell
        
        cell.cache = cache
        cell.imageURL = images[indexPath.row].media.url
    
        return cell
    }

    // MARK: UICollectionViewDelegateFlowLayout

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize {
        let ratio = CGFloat(images[indexPath.row].media.aspectRatio)
        let width = min(sqrt(ratio * Storyboard.CellArea) * scale, collectionView.bounds.size.width)
        let height = width / ratio
        return CGSize(width: width, height: height)
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Storyboard.SegueIdentifier {
            if let ttvc = segue.destinationViewController as? TweetTableViewController {
                if let cell = sender as? ImageCollectionViewCell {
                    ttvc.tweets = [[images[collectionView!.indexPathForCell(cell)!.row].tweet]]
                }
            }
        }
    }
    
    
}

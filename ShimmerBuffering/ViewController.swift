//
//  ViewController.swift
//  ShimmerBuffering
//
//  Created by Diep Nguyen Hoang on 8/24/15.
//  Copyright (c) 2015 CodenTrick. All rights reserved.
//

import UIKit
import Shimmer
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var shimmeringView: FBShimmeringView!
    
    let queuePlayer = AVQueuePlayer()
    var songItem: AVPlayerItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UILabel(frame: self.shimmeringView.bounds)
        label.textAlignment = .Center
        label.text = "A Song For You"
        self.shimmeringView.contentView = label
        self.shimmeringView.shimmering = true
        
        let streamUrl = "http://bit.ly/1h1PYoh"
        songItem = AVPlayerItem(URL: NSURL(string: streamUrl))
        queuePlayer.insertItem(songItem, afterItem: nil)
        queuePlayer.play()
        
        songItem?.addObserver(self, forKeyPath: "playbackBufferEmpty", options: .New, context: nil)
        songItem?.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: .New, context: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDidFinishPlaying:", name: AVPlayerItemDidPlayToEndTimeNotification, object: songItem)
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if let item = object as? AVPlayerItem {
            if (keyPath == "playbackBufferEmpty") {
                if (item.playbackBufferEmpty) {
                    self.shimmeringView.shimmering = true
                }
            } else if (keyPath == "playbackLikelyToKeepUp") {
                if (item.playbackLikelyToKeepUp) {
                    self.shimmeringView.shimmering = false
                }
            }
        }
    }
    
    func itemDidFinishPlaying(notification: NSNotification) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: AVPlayerItemDidPlayToEndTimeNotification, object: notification.object)
        self.songItem?.removeObserver(self, forKeyPath: "playbackBufferEmpty")
        self.songItem?.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp")
    }
}


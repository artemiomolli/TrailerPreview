//
//  InfoViewController.swift
//  TrailerPreview
//
//  Created by Артём Гуральник on 3/23/19.
//  Copyright © 2019 Guralnyk Artem. All rights reserved.
//

import UIKit
import AVKit
import YoutubeDirectLinkExtractor
import SVProgressHUD

class InfoViewController: UIViewController {
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var genres: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var overview: UITextView!
    @IBOutlet weak var watchButton: UIButton!
    
    var player: AVPlayer!
    var playerViewController: AVPlayerViewController!
    
    var currentMovie: Movie!
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = currentMovie.movieImage {
            
            movieImage.image = image
        }
        
        movieName.text = currentMovie.movieName
        
        if currentMovie.movieGenres != "" {
            
            genres.text = "\(currentMovie.movieGenres)"
        }
        
        date.text = currentMovie.movieDate
        overview.text = currentMovie.movieOverview
    }
    
    //MARK: - Actions
    
    @IBAction func backAction(_ sender: Any) {
        
        self.currentMovie = nil
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func startWatchingAction(_ sender: Any) {
        
        SVProgressHUD.show()
        
        watchButton.isEnabled = false
        
        playerViewController = AVPlayerViewController()
        
        guard let videoURL = URL(string: currentMovie.movieTrailerURL) else {return}
        //Getting playable link
        let youtubeExtractor = YoutubeDirectLinkExtractor()
        youtubeExtractor.extractInfo(for: .url(videoURL), success: { (videoInfo) in
            
            SVProgressHUD.dismiss()
 
            guard let playURL = URL(string:  videoInfo.highestQualityPlayableLink!) else {return}
            
            self.player = AVPlayer(url: playURL)
            
            self.playerViewController.player = self.player
            DispatchQueue.main.sync {
                
                self.present(self.playerViewController, animated: true) {
                    
                    NotificationCenter.default.addObserver(self, selector: #selector(self.didPlayToEnd), name: .AVPlayerItemDidPlayToEndTime, object: nil)
                }
                
                 self.player.play()
                
                 self.watchButton.isEnabled = true
            }

        }) { (error) in
            
            print(error.localizedDescription)
        }
    }
    
    //MARK: - Player Handling
    
    @objc func didPlayToEnd() {
        
        NotificationCenter.default.removeObserver(self)
        
        self.playerViewController.dismiss(animated: true, completion: nil)
        
    }
    
    
    deinit{
        print("deinit")
    }
}

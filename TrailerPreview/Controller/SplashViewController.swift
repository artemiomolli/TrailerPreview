//
//  SplashViewController.swift
//  TrailerPreview
//
//  Created by Артём Гуральник on 3/23/19.
//  Copyright © 2019 Guralnyk Artem. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD
import Reachability

class SplashViewController: UIViewController {
    
    var moviesArray = Array<Movie>()
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let reachability = Reachability()
        
        //Check if app has network
        if reachability?.connection != Reachability.Connection.none {
            SVProgressHUD.show()
            
            let apiManager = ApiManager()
            
            //Get movie trailers
            apiManager.performRequest("https://api.themoviedb.org/3/movie/popular?api_key=9c10248ddead577b706f0cd08d3b0200") { (json, error) in
                
                SVProgressHUD.dismiss()
                
                if let results = json?["results"].array {
                    
                    
                    for dictionary in results {
                        
                        let movie = Movie(imagePath: "http://image.tmdb.org/t/p/w185\(String(describing:dictionary["poster_path"]))", trailerName: String(describing:dictionary["title"]), date: String(describing:dictionary["release_date"]), trailerOverview: String(describing:dictionary["overview"]), id: String(describing:dictionary["id"]))
                        
                        self.moviesArray.append(movie)
                    }
                }
                
                self.performSegue(withIdentifier: "infoPage", sender: nil)
                
            }
        }else {
            
            let alert = UIAlertController(title: "Warning", message: "This app is fobidden to work without network.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Naviation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination.isKind(of: FilmListViewController.self) {
            
            let destinationVC = segue.destination as! FilmListViewController
            
            destinationVC.moviesArray = moviesArray
        }
    }
}

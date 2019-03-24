//
//  Film.swift
//  TrailerPreview
//
//  Created by Артём Гуральник on 3/23/19.
//  Copyright © 2019 Guralnyk Artem. All rights reserved.
//

import Foundation
import SwiftyJSON

class Movie {
    
    var movieImage: UIImage!
    var movieName = ""
    var movieDate = ""
    var movieOverview = ""
    var movieTrailerURL = ""
    var movieGenres = ""
    
    let apiManaer = ApiManager()
    
    init(imagePath: String, trailerName: String, date: String, trailerOverview: String, id: String) {
        
        self.movieName = trailerName
        self.movieDate = date
        self.movieOverview = trailerOverview
        
        let url = "http://api.themoviedb.org/3/movie/\(id)?api_key=9c10248ddead577b706f0cd08d3b0200"
        
        //Getting genres and video url from server
        DispatchQueue.main.async {
            
            self.apiManaer.performRequest(url, completion: { (json, error) in
                
                if let results = json?.dictionary {
                    
                    if let genre = results["genres"]?.array {
                        
                        for genr in genre {
                            
                            guard let name = genr["name"].string else {return}
                            
                            if self.movieGenres == "" {
                                
                                self.movieGenres = name
                            }else {
                                
                                self.movieGenres = self.movieGenres + "," + name
                            }
                        }
                    }
                }
            })
            
            self.apiManaer.performRequest("http://api.themoviedb.org/3/movie/\(id)/videos?api_key=9c10248ddead577b706f0cd08d3b0200", completion: { (json, error) in
                
                if let results = json?["results"].array {
                    
                    for jsonDict in results {
                        
                        if let pathForVied = jsonDict["key"].string {
                            
                            self.movieTrailerURL = "https://www.youtube.com/watch?v=\(pathForVied)"
                        }
                    }
                }
            })
            
        }
        
        //Loadi Image
        let imageURL:NSURL = NSURL(string:imagePath)!
        
        autoreleasepool { () -> () in
            
            do {
                
                let data: NSData =  try NSData(contentsOf: imageURL as URL)
                self.movieImage = UIImage(data: data as Data)
            }catch {
                
                print(error.localizedDescription)
            }
            
        }
    }
}


//
//  MovieTableViewCell.swift
//  TrailerPreview
//
//  Created by Артём Гуральник on 3/23/19.
//  Copyright © 2019 Guralnyk Artem. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    var currentMovie: Movie!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    //MARK: - Cell Init
    
    func populateCell(with movie: Movie) {
        
        currentMovie = movie
        
        if let image = movie.movieImage {
            
            movieImage.image = image
        }
        movieName.text = movie.movieName
    }
    
}

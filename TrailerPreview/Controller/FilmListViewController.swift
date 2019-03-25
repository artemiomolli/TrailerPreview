//
//  FilmListViewController.swift
//  TrailerPreview
//
//  Created by Артём Гуральник on 3/23/19.
//  Copyright © 2019 Guralnyk Artem. All rights reserved.
//

import UIKit

class FilmListViewController: UIViewController {
    
    var moviesArray = Array<Movie>()
    var defaultArray = Array<Movie>()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchHeight: NSLayoutConstraint!
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaultArray = moviesArray
        
        self.searchHeight.constant = 0
        
        UIView.animate(withDuration: 0.3) {
            
            self.view.layoutIfNeeded()
        }
        
        tableView.reloadData()
        
        //Keyboard Notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    //MARK: - Keyboard Notification Handling
    
    @objc func keyboardWillShow(notification: Notification) {
        
        let userInfo = notification.userInfo!
        let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        var keyboardHeight = keyboardSize.height
        
        if #available(iOS 11.0, *) {
            let bottomInset = view.safeAreaInsets.bottom
            keyboardHeight -= bottomInset
        }
        
        self.searchHeight.constant = keyboardHeight
    
        self.view.layoutIfNeeded()
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        
        self.searchHeight.constant = 0
        
        UIView.animate(withDuration: 0.3) {
            
            self.view.layoutIfNeeded()
        }
    }
}

//MARK: - Search Delegate

extension FilmListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        moviesArray = defaultArray
        
        if searchText != "" {
            
            moviesArray =  moviesArray.filter {$0.movieName.range(of: searchText) != nil }
            
            tableView.isHidden = moviesArray.count == 0
            
            tableView.reloadData()
        }else {
            
            tableView.isHidden = searchText != ""
            moviesArray = defaultArray
            
            tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        view.endEditing(true)
    }
}

//MARK: - Table View Delegate

extension FilmListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieTableViewCell
        
        cell.populateCell(with: moviesArray[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return moviesArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            
            return tableView.bounds.height / 3
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell = tableView.cellForRow(at: indexPath) as! MovieTableViewCell
        
        let infoVC = InfoViewController()
        
        infoVC.currentMovie = selectedCell.currentMovie
        
        //Use weak self to  present Info Controller
        
        let closureOpen = { [weak self] in
            guard let strongSelf = self else { return }
            
            strongSelf.present(infoVC, animated: true, completion: nil)
        }
        
        closureOpen()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

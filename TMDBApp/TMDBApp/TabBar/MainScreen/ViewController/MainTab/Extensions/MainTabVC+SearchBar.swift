//
//  MainTabVC+SearchBar.swift
//  TMDBApp
//
//  Created by Artyom Butorin on 23.01.23.
//

import Foundation
import UIKit

extension MainTabViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        self.searchMovies(with: searchText)
        print(searchingMovies)
        if searchText .isEmpty {
            searchBar.showsCancelButton = false
            self.isSearching = false
            self.loadingIndicator.stopAnimating()
            self.searchingMovies.removeAll()
        } else {
            self.isSearching = true
            searchBar.showsCancelButton = true
            self.loadingIndicator.stopAnimating()
        }
        self.collectionView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.searchingMovies.removeAll()
        self.loadingIndicator.stopAnimating()
        self.collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar, searchText: String) {
//        if let searchText = searchBar.text {
//            self.searchMovies(with: searchText)
//        }
        print("Searching Clicked!!!!!!!!!!!!!!")
    }

}

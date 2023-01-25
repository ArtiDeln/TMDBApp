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
        self.searchMovies(with: searchText)
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
}

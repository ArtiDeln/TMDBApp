//
//  MainTabVC+SearchBar.swift
//  TMDBApp
//
//  Created by Artyom Butorin on 23.01.23.
//

import Foundation
import UIKit

extension MainTabViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        self.searchMovies(with: searchText)
    }
}

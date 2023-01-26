//
//  MainTabVC+CollectionView.swift
//  TMDBApp
//
//  Created by Artyom Butorin on 23.01.23.
//

import Foundation
import UIKit

extension MainTabViewController: UICollectionViewDelegate,
                                 UICollectionViewDataSource,
                                 UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        switch (isSearching,
                UserDefaults.standard.bool(forKey: "section1SelectedKey"),
                UserDefaults.standard.bool(forKey: "section2SelectedKey")) {
        case (true, _, _):
            return 1
        case (false, true, false):
            return 1
        case (false, false, true):
            return 1
        case (false, true, true):
            return 2
        default:
            return 2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        switch(isFiltering,
               isSearching,
               UserDefaults.standard.bool(forKey: "section1SelectedKey"),
               UserDefaults.standard.bool(forKey: "section2SelectedKey")) {
        case (_, true, _, _): return self.searchingMovies.count
        case (false, false, _, _): return 0
        case (true, _, true, false): return self.popularMovies.count
        case (true, _, false, true): return self.upcomingMovies.count
        case (_, false, false, false):
            return 0
        case (true, false, true, true):
            return self.popularMovies.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell",
                                                            for: indexPath) as? MovieCell else {
            return UICollectionViewCell()
        }
        let movie: Movie
        
        switch(isSearching,
               UserDefaults.standard.bool(forKey: "section1SelectedKey"),
               UserDefaults.standard.bool(forKey: "section2SelectedKey")) {
        case (true, _, _):
            guard !self.searchingMovies.isEmpty else { return UICollectionViewCell() }
            movie = self.searchingMovies[indexPath.item]
        case (false, true, false):
            guard !self.popularMovies.isEmpty else { return UICollectionViewCell() }
            movie = self.popularMovies[indexPath.item]
        case (false, false, true):
            guard !self.upcomingMovies.isEmpty else { return UICollectionViewCell() }
            movie = self.upcomingMovies[indexPath.item]
        case (false, true, true):
            if indexPath.section == 0 {
                guard !self.popularMovies.isEmpty else { return UICollectionViewCell() }
                movie = self.popularMovies[indexPath.item]
            } else {
                guard !self.upcomingMovies.isEmpty else { return UICollectionViewCell() }
                movie = self.upcomingMovies[indexPath.item]
            }
        case (false, _, _):
            return UICollectionViewCell()
        }
        
        cell.backgroundColor = .systemBackground
        cell.layer.cornerRadius = 12
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.layer.shadowRadius = 2
        cell.configure(with: movie)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 30) / 2
        return CGSize(width: width, height: width + 90)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if !selectedSections.contains(indexPath.section) {
            return UICollectionReusableView()
        }
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                   withReuseIdentifier: "HeaderView",
                                                                                   for: indexPath) as? HeaderView else {
                print("viewForSupplementaryElementOfKind = Error")
                return UICollectionReusableView()
            }
            
            switch (isSearching,
                    UserDefaults.standard.bool(forKey: "section1SelectedKey"),
                    UserDefaults.standard.bool(forKey: "section2SelectedKey")) {
            case (true, _, _): headerView.titleLabel.text = "Search result"
            case (_, true, false): headerView.titleLabel.text = "Popular Movies"
            case (_, false, true): headerView.titleLabel.text = "Upcoming Movies"
            case (_, true, true):
                if indexPath.section == 0 {
                    headerView.titleLabel.text = "Popular Movies"
                } else {
                    headerView.titleLabel.text = "Upcoming Movies"
                }
            case (false, false, false):
                if indexPath.section == 0 {
                    headerView.titleLabel.text = "Select the type of films in the \"Filter\" button"
                } else {
                    headerView.titleLabel.text = ""
                }
            }
            return headerView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let selectedMovie: Movie
        
        switch (isSearching,
                UserDefaults.standard.bool(forKey: "section1SelectedKey"),
                UserDefaults.standard.bool(forKey: "section2SelectedKey")) {
        case (true, _, _): selectedMovie = searchingMovies[indexPath.item]
        case (false, true, false): selectedMovie = popularMovies[indexPath.item]
        case (false, false, true): selectedMovie = upcomingMovies[indexPath.item]
        case (false, true, true):
            if indexPath.section == 0 {
                selectedMovie = popularMovies[indexPath.item]
            } else {
                selectedMovie = upcomingMovies[indexPath.item]
            }
        case (false, false, false):
            selectedMovie = popularMovies[indexPath.item]
        }
        
        self.showMovieDetails(for: selectedMovie)
    }
    
    func showMovieDetails(for movie: Movie) {
        let movieDetailsViewController = MovieDetailsViewController()
        movieDetailsViewController.movie = movie
        navigationController?.pushViewController(movieDetailsViewController, animated: true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.searchBar.resignFirstResponder()
    }
}

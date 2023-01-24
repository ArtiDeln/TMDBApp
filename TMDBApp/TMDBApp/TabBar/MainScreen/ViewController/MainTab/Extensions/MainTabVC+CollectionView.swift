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
        if isSearching {
            return 1
        } else {
            return self.selectedSections.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if !selectedSections.contains(section) {
            return 0
        }

        if self.isSearching {
            return self.searchingMovies.count
        } else if section == 0 {
            return self.popularMovies.count
        } else {
            return self.upcomingMovies.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell",
                                                            for: indexPath) as? MovieCell else {
            return UICollectionViewCell()
        }
        let movie: Movie
        
        if !selectedSections.contains(indexPath.section) {
            return UICollectionViewCell()
        }
        if self.isSearching {
            guard !self.searchingMovies.isEmpty else { return UICollectionViewCell() }
            movie = self.searchingMovies[indexPath.item]
            print("Filtering testing")
        } else if self.test == 1 {
            guard !self.upcomingMovies.isEmpty else { return UICollectionViewCell() }
            movie = self.upcomingMovies[indexPath.item]
        } else if indexPath.section == 0 {
            guard !self.popularMovies.isEmpty else { return UICollectionViewCell() }
            movie = self.popularMovies[indexPath.item]
        } else {
            guard !self.upcomingMovies.isEmpty else { return UICollectionViewCell() }
            movie = self.upcomingMovies[indexPath.item]
        }
        
        cell.backgroundColor = .systemBackground
        cell.layer.cornerRadius = 12
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.layer.shadowRadius = 2
        cell.configure(with: movie)
        
        self.favoritedMovies = cell.favoritedMovies
        
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
            if isSearching {
                headerView.titleLabel.text = "Search result"
            } else {
                headerView.titleLabel.text = indexPath.section == 0 ? "Popular Movies" : "Upcoming Movies"
            }
            return headerView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let selectedMovie: Movie
        if isSearching {
            selectedMovie = searchingMovies[indexPath.item]
        } else if indexPath.section == 0 {
            selectedMovie = popularMovies[indexPath.item]
        } else {
            selectedMovie = upcomingMovies[indexPath.item]
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

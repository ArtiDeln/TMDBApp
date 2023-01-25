//
//  FavoritesVC+CollectionView.swift
//  TMDBApp
//
//  Created by Artyom Butorin on 25.01.23.
//

import UIKit

extension FavoritesViewController: UICollectionViewDelegate,
                                   UICollectionViewDataSource,
                                   UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if favorites.isEmpty {
            return UICollectionViewCell()
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell",
                                                            for: indexPath) as? MovieCell else {
            return UICollectionViewCell()
        }
        let movie: Movie
        guard !self.favorites.isEmpty else { return UICollectionViewCell() }
        movie = self.favorites[indexPath.item]
        cell.backgroundColor = .systemBackground
        cell.layer.cornerRadius = 12
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.layer.shadowRadius = 2
        cell.configure(with: movie)
        return cell
    }
    
    func showMovieDetails(for movie: Movie) {
        let movieDetailsViewController = MovieDetailsViewController()
        movieDetailsViewController.movie = movie
        navigationController?.pushViewController(movieDetailsViewController, animated: true)
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
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                   withReuseIdentifier: "HeaderView",
                                                                                   for: indexPath) as? HeaderView else {
                print("viewForSupplementaryElementOfKind = Error")
                return UICollectionReusableView()
            }
                headerView.titleLabel.text = "Licked result"
            return headerView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let selectedMovie: Movie
            selectedMovie = favorites[indexPath.item]
        self.showMovieDetails(for: selectedMovie)
        
    }
    
    func showFavoriteMovieDetails(for movie: Movie) {
        let movieDetailsViewController = MovieDetailsViewController()
        movieDetailsViewController.movie = movie
        navigationController?.pushViewController(movieDetailsViewController, animated: true)
    }
}

//
//  FavoritesViewController.swift
//  TMDBApp
//
//  Created by Artyom Butorin on 20.01.23.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: "MovieCell")
        return collectionView
    }()
    
    let mainTabVC = MainTabViewController()
    var favorites: [Movie] {
        get {
            return mainTabVC.favoritedMovies
        }
        set {
            mainTabVC.favoritedMovies = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if favorites.isEmpty {
            let label = UILabel()
            label.text = "No favorites yet"
            label.textAlignment = .center
            collectionView.backgroundView = label
        }
        
        favorites = mainTabVC.favoritedMovies
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundColor = .systemBackground
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: "MovieCell")
        collectionView.register(HeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "HeaderView")
        //        collectionView.refreshControl = refreshControl
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.headerReferenceSize = CGSize(width: view.frame.width, height: 50)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let movieCell = MovieCell()
        super.viewWillAppear(animated)
        self.favorites = movieCell.favoritedMovies
        self.collectionView.reloadData()
    }

}

extension FavoritesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
        let movie = favorites[indexPath.item]
        cell.configure(with: movie)
        return cell
    }
}

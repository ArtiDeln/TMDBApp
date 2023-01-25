//
//  FavoritesViewController.swift
//  TMDBApp
//
//  Created by Artyom Butorin on 20.01.23.
//

import UIKit
import Alamofire

class FavoritesViewController: UIViewController {
    
    let mainTabVC = MainTabViewController()
//    var favorites: [Movie] {
//        get {
//            let data = UserDefaults.standard.data(forKey: "favoriets")
//            var favorites = MovieData.init(results: [Movie]())
//            if (data != nil) {
//                do {
//                    favorites = try JSONDecoder().decode(MovieData.self, from: data!)
//                } catch {
//                    print("saved data parsing error")
//                }
//            }
//            return favorites.results
//        }
//        set {
//            do {
//                try UserDefaults.standard.set(JSONEncoder().encode(MovieData.init(results: newValue)),forKey: "favoriets")
//            } catch {
//                print("writing favorites error")
//            }
//        }
//    }
    
    var favorites: [Movie] {
           get {
               let data = UserDefaults.standard.data(forKey: "favoriets")
               var favorites = MovieData.init(results: [Movie]())
               if data != nil {
                   do {
                       favorites = try JSONDecoder().decode(MovieData.self, from: data!)
                   } catch {
                       print("saved data parsing error")
                   }
               }
               return favorites.results
           }
           set {
               do {
                   try UserDefaults.standard.set(JSONEncoder().encode(MovieData
                    .init(results: newValue)), forKey: "favoriets")
               } catch {
                   print("writing favorites error")
               }
           }
       }

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: "MovieCell")
        return collectionView
    }()
    
    private(set) lazy var favoritesIsEmptylabel: UILabel = {
        let label = UILabel()
        label.text = "No favorites yet"
        label.textAlignment = .center
        return label
    }()
    private(set) lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.style = .large
        return indicator
    }()
    
    private(set) lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refreshCollectionView), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(favorites)
  
        self.initView()
        self.constraints()
        self.collectionViewSettings()
        self.collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshCollectionView()
    }
    
    private func initView() {
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.loadingIndicator)
    }
    
    private func constraints() {
        self.collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        self.loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func collectionViewSettings() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.backgroundColor = .systemBackground
        self.collectionView.register(MovieCell.self, forCellWithReuseIdentifier: "MovieCell")
        self.collectionView.register(HeaderView.self,
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                     withReuseIdentifier: "HeaderView")
        self.collectionView.refreshControl = self.refreshControl
        
        if let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.headerReferenceSize = CGSize(width: view.frame.width, height: 50)
        }
    }
    
    @objc private func refreshCollectionView() {
        self.collectionView.reloadData()
        print("ViewWillAppear")
        print("Favorites is", favorites)
        if favorites.isEmpty {
            favoritesIsEmptylabel.isHidden = false
            collectionView.backgroundView = favoritesIsEmptylabel
        } else {
            favoritesIsEmptylabel.isHidden = true
        }
        self.refreshControl.endRefreshing()
    }
}

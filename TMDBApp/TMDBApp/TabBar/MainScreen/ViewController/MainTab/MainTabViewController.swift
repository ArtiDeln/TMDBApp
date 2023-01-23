//
//  MainTabViewController.swift
//  TMDBApp
//
//  Created by Artyom Butorin on 20.01.23.
//

import UIKit
import SnapKit
import Alamofire
import Kingfisher
import Foundation

class MainTabViewController: UIViewController {
    
    // MARK: - Variables
    
    var selectedSections: Set<Int> = [0, 1]
    
    var popularMovies: [Movie] = []
    var upcomingMovies: [Movie] = []
    var filteredMovies: [Movie] = []
    var favoritedMovies: [Movie] = []
    
    var isFiltering = false
    private var isSearching = false
    
    // MARK: - GUI
    
    private(set) lazy var searchBar = UISearchBar()
    
    private(set) lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: "MovieCell")
        return collectionView
    }()
    
    private(set) lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.style = .large
        return indicator
    }()
    
    private(set) lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetchMovies), for: .valueChanged)
        return refreshControl
    }()
    
    // MARK: - Initialisation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
        self.constraints()
        self.setNavBar()
        self.collectionViewSettings()
        self.fetchMovies()
        self.userDefaultsFavorites()
        
        self.loadingIndicator.startAnimating()
    }
    
    private func initView() {
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.loadingIndicator)
    }
    
    // MARK: - Constraints
    
    private func constraints() {
        self.collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        self.loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func userDefaultsFavorites() {
        do {
            if let data = UserDefaults.standard.value(forKey: "favorites") as? Data {
                self.favoritedMovies = try PropertyListDecoder().decode([Movie].self, from: data)
            }
        } catch {
            print("Error retrieving favorites: (error)")
        }
    }
    
    private func setNavBar() {
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        searchBar.placeholder = "Search movies"
        navigationItem.title = "Movies"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(filterButtonTapped))
    }
    
    private func collectionViewSettings() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.backgroundColor = .systemBackground
        self.collectionView.register(MovieCell.self, forCellWithReuseIdentifier: "MovieCell")
        self.collectionView.register(HeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "HeaderView")
        self.collectionView.refreshControl = refreshControl
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.headerReferenceSize = CGSize(width: view.frame.width, height: 50)
        }
    }
    
    func searchMovies(with searchText: String) {
        isSearching = true
        let url = "https://api.themoviedb.org/3/search/movie"
        let parameters: Parameters = ["api_key": Constants.apiKey, "query": searchText]
        AF.request(url, parameters: parameters).responseDecodable(of: MovieData.self) { (response) in
            guard let movieData = response.value else { return }
            self.filteredMovies = movieData.results
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - @obj funcs
    
    @objc private func fetchMovies() {
        loadingIndicator.startAnimating()
        let group = DispatchGroup()
        group.enter()
        AF.request("\(Constants.baseURL)/popular?api_key=\(Constants.apiKey)")
            .responseDecodable(of: MovieData.self) { response in
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                let movieData = try decoder.decode(MovieData.self, from: data)
                self.popularMovies = movieData.results
                group.leave()
            } catch {
                print("Error decoding popular movies: \(error)")
                group.leave()
            }
        }
        
        group.enter()
        AF.request("\(Constants.baseURL)/upcoming?api_key=\(Constants.apiKey)")
            .responseDecodable(of: MovieData.self) { response in
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                let movieData = try decoder.decode(MovieData.self, from: data)
                self.upcomingMovies = movieData.results
                group.leave()
            } catch {
                print("Error decoding upcoming movies: \(error)")
                group.leave()
            }
        }
        group.notify(queue: .main) {
            self.collectionView.reloadData()
            self.refreshControl.endRefreshing()
            self.loadingIndicator.stopAnimating()
        }
    }
    
    @objc private func filterButtonTapped() {
        let alertController = UIAlertController(title: "Filter",
                                                message: "Select the sections to be displayed",
                                                preferredStyle: .actionSheet)
        let popularAction = UIAlertAction(title: "Popular Movies", style: .default) { _ in
            if self.selectedSections.contains(0) {
                self.selectedSections.remove(0)
            } else {
                self.selectedSections.insert(0)
            }
            self.collectionView.reloadData()
        }
        let upcomingAction = UIAlertAction(title: "Upcoming Movies", style: .default) { _ in
            if self.selectedSections.contains(1) {
                self.selectedSections.remove(1)
            } else {
                self.selectedSections.insert(1)
            }
            self.collectionView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(popularAction)
        alertController.addAction(upcomingAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
}

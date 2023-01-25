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
    var searchingMovies: [Movie] = []
    
    var test = Int()
    var isFiltering: Bool {
           return UserDefaults.standard.bool(forKey: "section1SelectedKey")
                || UserDefaults.standard.bool(forKey: "section2SelectedKey")
    }
    
    var isSearching = false
    
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
        self.configureNavBar()
        self.collectionViewSettings()
        self.fetchMovies()
        
        self.loadingIndicator.startAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchMovies()
        self.collectionView.reloadData()
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
    
    private func configureNavBar() {
        self.navigationItem.titleView = self.searchBar
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter",
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(self.filterButtonTapped))
        self.searchBar.delegate = self
        self.searchBar.placeholder = "Search movies"
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
    
    func searchMovies(with searchText: String) {
        self.loadingIndicator.startAnimating()
        isSearching = true
        let url = "https://api.themoviedb.org/3/search/movie"
        let parameters: Parameters = ["api_key": Constants.apiKey, "query": searchText]
        AF.request(url, parameters: parameters).responseDecodable(of: MovieData.self,
                                                                  decoder: JSONDecoder()) { (response) in
            guard let movieData = response.value else { return print("error") }
            self.searchingMovies = movieData.results
            self.collectionView.reloadData()
            self.loadingIndicator.stopAnimating()
        }
        self.collectionView.reloadData()
        self.loadingIndicator.stopAnimating()
    }
    
    // MARK: - @obj funcs
    
    @objc func fetchMovies() {
        loadingIndicator.startAnimating()
        let group = DispatchGroup()
        if UserDefaults.standard.bool(forKey: "section1SelectedKey") {
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
        }
        
        if UserDefaults.standard.bool(forKey: "section2SelectedKey") {
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
        }
        
        group.notify(queue: .main) {
            self.collectionView.reloadData()
            self.refreshControl.endRefreshing()
            self.loadingIndicator.stopAnimating()
        }
    }
    
    @objc private func filterButtonTapped() {

        let filterViewController = FilterViewController()
        filterViewController.modalPresentationStyle = .fullScreen
        present(filterViewController, animated: true)
    }
}

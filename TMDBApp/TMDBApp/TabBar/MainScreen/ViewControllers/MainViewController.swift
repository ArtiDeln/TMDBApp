//
//  MainViewController.swift
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
    
    var selectedSections: Set<Int> = [0, 1]
    private var popularMovies: [Movie] = []
    private var upcomingMovies: [Movie] = []
    private var filteredMovies: [Movie] = []
    private var isFiltering = false
    
    private var isSearching = false
    private let apiKey = "79d5894567be5b76ab7434fc12879584"
    
    private let searchBar = UISearchBar()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: "MovieCell")
        return collectionView
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        searchBar.placeholder = "Search movies"
        
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
        collectionView.refreshControl = refreshControl
        
        view.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.headerReferenceSize = CGSize(width: view.frame.width, height: 50)
        }
        
        loadingIndicator.startAnimating()
        
        navigationItem.title = "Movies"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(filterButtonTapped))
        
        definesPresentationContext = true
        
        self.fetchMovies()
        
    }
    
    private func searchMovies(with searchText: String) {
        isSearching = true
        let url = "https://api.themoviedb.org/3/search/movie"
        let parameters: Parameters = ["api_key": apiKey, "query": searchText]
        AF.request(url, parameters: parameters).responseDecodable(of: MovieData.self) { (response) in
            guard let movieData = response.value else { return }
            self.filteredMovies = movieData.results
            self.collectionView.reloadData()
        }
    }
    
    @objc private func fetchMovies() {
        loadingIndicator.startAnimating()
        let baseAPIURL = "https://api.themoviedb.org/3/movie"
        let apiKey = "79d5894567be5b76ab7434fc12879584"
        let group = DispatchGroup()
        group.enter()
        AF.request("\(baseAPIURL)/popular?api_key=\(apiKey)").responseDecodable(of: MovieData.self) { response in
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
        AF.request("\(baseAPIURL)/upcoming?api_key=\(apiKey)").responseDecodable(of: MovieData.self) { response in
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

extension MainTabViewController: UICollectionViewDelegate,
                                 UICollectionViewDataSource,
                                 UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return selectedSections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering {
            return filteredMovies.count
        } else if section == 0 {
            return popularMovies.count
        } else {
            return upcomingMovies.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell",
                                                            for: indexPath) as? MovieCell else {
            return UICollectionViewCell()
        }
        let movie: Movie
        if isFiltering {
            guard !filteredMovies.isEmpty else { return UICollectionViewCell() }
            movie = filteredMovies[indexPath.item]
            print("Filtering testing")
        } else if indexPath.section == 0 {
            guard !popularMovies.isEmpty else { return UICollectionViewCell() }
            movie = popularMovies[indexPath.item]
        } else {
            guard !upcomingMovies.isEmpty else { return UICollectionViewCell() }
            movie = upcomingMovies[indexPath.item]
        }
        cell.backgroundColor = .yellow
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
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                   withReuseIdentifier: "HeaderView",
                                                                                   for: indexPath) as? HeaderView else {
                print("viewForSupplementaryElementOfKind = Error")
                return UICollectionReusableView()
            }
            headerView.titleLabel.text = indexPath.section == 0 ? "Popular Movies" : "Upcoming Movies"
            return headerView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Show movie details when a movie is selected
    }
}

extension MainTabViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        searchMovies(with: searchText)
    }
}

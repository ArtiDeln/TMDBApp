//
//  MovieCell.swift
//  TMDBApp
//
//  Created by Artyom Butorin on 22.01.23.
//

import UIKit

class MovieCell: UICollectionViewCell {
    
    var favoritedMovies: [Movie] = []
    var movie: Movie!
    
    let favoritesVC = FavoritesViewController()
    
    private(set) lazy var genreToString = MovieGenresDecoder.shared
    
    // MARK: - GUI
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 1
        return label
    }()
    
    private let yearGenreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 1
        return label
    }()
    
    private(set) lazy var heartButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.addTarget(self, action: #selector(self.likeButtonTapped), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initView()
        self.constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        self.contentView.addSubview(posterImageView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(yearGenreLabel)
        self.contentView.addSubview(heartButton)
    }
    
    func constraints() {
        posterImageView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(self.contentView.snp.width).offset(40)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.posterImageView.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(8)
        }
        yearGenreLabel.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(8)
        }
        heartButton.snp.makeConstraints {
            $0.top.equalTo(self.posterImageView.snp.top).offset(8)
            $0.right.equalTo(self.posterImageView.snp.right).offset(-8)
            $0.width.height.equalTo(30)
        }
    }
    
    @objc func likeButtonTapped() {
        if movie != nil {
            let data = UserDefaults.standard.data(forKey: "favoriets")
            var favorites = MovieData.init(results: [Movie]())
            if data != nil {
                do {
                    favorites = try JSONDecoder().decode(MovieData.self, from: data!)
                } catch {
                    print("saved data parsing error")
                }
            }
            do {
                if (favorites.results.contains {$0.id == movie.id}) {
                    let newResults = favorites.results.filter { $0.id != movie.id }
                    try UserDefaults.standard.set(JSONEncoder()
                        .encode(MovieData.init(results: newResults)),
                                                  forKey: "favoriets")
                    self.heartButton.tintColor = .white
                } else {
                    var newResults = favorites.results
                    newResults.append(movie)
                    try UserDefaults.standard.set(JSONEncoder()
                        .encode(MovieData.init(results: newResults)),
                                                  forKey: "favoriets")
                    self.heartButton.tintColor = .red
                }
            } catch {
                print("writing favorites error")
            }
        }
    }

    func configure(with movie: Movie) {
        
        let posterURL = URL(string: "\(Constants.basePosterURL)\(movie.posterPath ?? "")")
        let genreArray = "\(genreToString.decodeMovieGenreIDs(idNumbers: movie.genreIds))"
        let genre = genreArray.components(separatedBy: ",").first

        self.posterImageView.kf.setImage(with: posterURL)
        self.titleLabel.text = movie.title
        self.yearGenreLabel.text = "\(movie.releaseDate.prefix(4)) - \(genre ?? "")"
        let data = UserDefaults.standard.data(forKey: "favoriets")
        var favorites = MovieData.init(results: [Movie]())
        if data != nil {
            do {
                favorites = try JSONDecoder().decode(MovieData.self, from: data!)
            } catch {
                print("saved data parsing error")
            }
        }
        let isLiked = favorites.results.contains { $0.id == movie.id }
        if isLiked {
            self.heartButton.tintColor = .red
        } else {
            self.heartButton.tintColor = .white
        }
                
        self.movie = movie
    }
}

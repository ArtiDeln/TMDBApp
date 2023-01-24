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
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.addTarget(self, action: #selector(self.likeButtonTapped), for: .touchUpInside)
        button.tintColor = .red
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
        
    }

    func configure(with movie: Movie) {
        let posterURL = URL(string: "\(Constants.basePosterURL)\(movie.posterPath)")
        let genre = "\(genreToString.decodeMovieGenreIDs(idNumbers: movie.genreIds))"
        
        self.posterImageView.kf.setImage(with: posterURL)
        self.titleLabel.text = movie.title
        self.yearGenreLabel.text = "\(movie.releaseYear) - \(genre)"
        self.heartButton.setImage(UIImage(systemName: movie.isLiked ? "heart.fill" : "heart"), for: .normal)
                
        self.movie = movie
    }
}

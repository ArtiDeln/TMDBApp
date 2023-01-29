//
//  MovieDetailsViewController.swift
//  TMDBApp
//
//  Created by Artyom Butorin on 22.01.23.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    // MARK: - Properties
    
    private(set) lazy var genreToString = MovieGenresDecoder.shared

    var movie: Movie!
    
    // MARK: - GUI
    
    private(set) lazy var moviePosterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .label
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        return label
    }()
    
    private(set) lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private(set) lazy var genresLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        return label
    }()
    
    private(set) lazy var voteAverageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private(set) lazy var overviewTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.textColor = .label
        textView.isEditable = false
        textView.isSelectable = false
        return textView
    }()
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = movie.title
        
        self.initView()
        self.constraints()
        self.configureMovieDetails()
    }
    
    private func initView() {
        self.view.addSubview(self.moviePosterImageView)
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.releaseDateLabel)
        self.view.addSubview(self.genresLabel)
        self.view.addSubview(self.voteAverageLabel)
        self.view.addSubview(self.overviewTextView)
    }
    
    // MARK: - Configuration
    
    private func configureMovieDetails() {
        self.titleLabel.text = movie.title
        self.releaseDateLabel.text = "Release date: \(movie.releaseDate.prefix(4))"
        self.genresLabel.text = "Genres: \(genreToString.decodeMovieGenreIDs(idNumbers: movie.genreIds))"
        self.overviewTextView.text = "Overview: \(movie.overview)"
        self.voteAverageLabel.text = "Vote average: \(movie.voteAverage)"
        let posterPath = "\(Constants.basePosterURL)\(movie.posterPath ?? "")"
        let url = URL(string: posterPath)
        self.moviePosterImageView.kf.setImage(with: url)
    }
    
    // MARK: - Constraints
    
    private func constraints() {
        self.moviePosterImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(102)
            $0.leading.equalToSuperview().inset(16)
            $0.width.equalTo(120)
            $0.height.equalTo(180)
        }
        self.titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.moviePosterImageView)
            $0.leading.equalTo(self.moviePosterImageView.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().inset(16)
        }
        self.releaseDateLabel.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(8)
            $0.leading.equalTo(self.titleLabel)
            $0.trailing.equalTo(self.titleLabel)
        }
        self.genresLabel.snp.makeConstraints {
            $0.top.equalTo(self.releaseDateLabel.snp.bottom).offset(8)
            $0.leading.equalTo(self.releaseDateLabel)
            $0.trailing.equalTo(self.releaseDateLabel)
        }
        self.voteAverageLabel.snp.makeConstraints {
            $0.top.equalTo(self.genresLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(self.genresLabel)
        }
        self.overviewTextView.snp.makeConstraints {
            $0.top.equalTo(self.moviePosterImageView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(32)
        }
    }
}

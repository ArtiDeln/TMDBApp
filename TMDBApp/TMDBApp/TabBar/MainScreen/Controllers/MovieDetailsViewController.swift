//
//  MovieDetailsViewController.swift
//  TMDBApp
//
//  Created by Artyom Butorin on 22.01.23.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    private let genreToString = MovieGenresDecoder.shared

    var movie: Movie!
    
    private let moviePosterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .label
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        return label
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let genresLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        return label
    }()
    
    private let voteAverageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let overviewTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.textColor = .label
        textView.isEditable = false
        textView.isSelectable = false
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = movie.title
        setupViews()
        configureMovieDetails()
    }
    
    private func setupViews() {
        view.addSubview(moviePosterImageView)
        moviePosterImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(102)
            make.leading.equalToSuperview().inset(16)
            make.width.equalTo(120)
            make.height.equalTo(180)
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(moviePosterImageView)
            make.leading.equalTo(moviePosterImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().inset(16)
        }
        
        view.addSubview(releaseDateLabel)
        releaseDateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(titleLabel)
            make.trailing.equalTo(titleLabel)
        }
        view.addSubview(genresLabel)
        genresLabel.snp.makeConstraints { make in
            make.top.equalTo(releaseDateLabel.snp.bottom).offset(8)
            make.leading.equalTo(releaseDateLabel)
            make.trailing.equalTo(releaseDateLabel)
        }
        view.addSubview(voteAverageLabel)
        voteAverageLabel.snp.makeConstraints {
            $0.top.equalTo(genresLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(genresLabel)
        }
        view.addSubview(overviewTextView)
        overviewTextView.snp.makeConstraints { make in
            make.top.equalTo(moviePosterImageView.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(32)
        }
    }
    
    private func configureMovieDetails() {
        titleLabel.text = movie.title
        releaseDateLabel.text = "Release date: \(movie.releaseYear)"
        genresLabel.text = "Genres: \(genreToString.decodeMovieGenreIDs(idNumbers: movie.genreIds))"
        overviewTextView.text = "Overview: \(movie.overview)"
        voteAverageLabel.text = "Vote average: \(movie.voteAverage)"
        
        let posterPath = "https://image.tmdb.org/t/p/w500\(movie.posterPath)"
        let url = URL(string: posterPath)
        moviePosterImageView.kf.setImage(with: url)
    }
}

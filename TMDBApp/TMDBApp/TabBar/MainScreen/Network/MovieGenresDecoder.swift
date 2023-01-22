//
//  MovieGenresDecoder.swift
//  TMDBApp
//
//  Created by Artyom Butorin on 22.01.23.
//

import Foundation

struct MovieGenresDecoder {
    static let shared = MovieGenresDecoder()
    private let genres: [Int: String] = [
        28: "Action",
        12: "Adventure",
        16: "Animation",
        35: "Comedy",
        80: "Crime",
        99: "Documentary",
        18: "Drama",
        10751: "Family",
        14: "Fantasy",
        36: "History",
        27: "Horror",
        10402: "Music",
        9648: "Mystery",
        10749: "Romance",
        878: "Science Fiction",
        10770: "TV Movie",
        53: "Thriller",
        10752: "War",
        37: "Western",
        10765: "Sci-Fi & Fantasy",
        10766: "Soap",
        10767: "Talk",
        10768: "War & Politics",
        10764: "Reality",
        10763: "News",
        10762: "Kids",
        10759: "Action & Adventure"
    ]

    private init() {}

    func decodeMovieGenreIDs(idNumbers: [Int] ) -> String {
        if idNumbers.isEmpty {
            return "Genre is not specified"
        } else {
            let genres = idNumbers.compactMap { self.genres[$0] }
            return genres.joined(separator: ", ")
        }
    }
}

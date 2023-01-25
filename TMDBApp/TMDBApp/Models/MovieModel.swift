//
//  MovieModel.swift
//  TMDBApp
//
//  Created by Artyom Butorin on 21.01.23.
//

import Foundation

// MARK: - Movie model

struct MovieData: Decodable, Encodable {
    let results: [Movie]
}

struct Movie: Decodable, Equatable, Encodable {
    let id: Int
    let title: String
    let posterPath: String?
    let releaseDate: String
    var isLiked: Bool = false
    var genreIds: [Int]
    let overview: String
    let voteAverage: Double
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case genreIds = "genre_ids"
        case overview
        case voteAverage = "vote_average"
    }
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        id = try container.decode(Int.self, forKey: .id)
//        title = try container.decode(String.self, forKey: .title)
//        posterPath = try container.decode(String.self, forKey: .posterPath)
//        let date = try container.decode(String.self, forKey: .releaseYear)
//        releaseYear = String(date.prefix(4))
//        genreIds = try container.decode([Int].self, forKey: .genreIds)
//        overview = try container.decode(String.self, forKey: .overview)
//        voteAverage = try container.decode(Double.self, forKey: .voteAverage)
//    }
}

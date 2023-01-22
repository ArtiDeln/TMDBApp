//
//  MainScreenModels.swift
//  TMDBApp
//
//  Created by Artyom Butorin on 21.01.23.
//

import Foundation

// MARK: - Movie model

struct MovieData: Decodable {
    let results: [Movie]
}

struct Movie: Decodable {
    var genreArray: [Genre] = []
    let id: Int
    let title: String
    let posterPath: String
    let releaseYear: String
    var genre: String = ""
    var isLiked: Bool = false
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
        case releaseYear = "release_date"
        case genreIds = "genre_ids"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        posterPath = try container.decode(String.self, forKey: .posterPath)
        let date = try container.decode(String.self, forKey: .releaseYear)
        releaseYear = String(date.prefix(4))
        let genreIds = try container.decode([Int].self, forKey: .genreIds)
        for id in genreIds {
            for genre in genreArray where genre.id == id {
                self.genre += genre.name + ", "
            }
        }
        genre = String(genre.dropLast(2))
    }
}

struct Genre: Decodable {
    let id: Int
    let name: String
}

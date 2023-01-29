//
//  Constants.swift
//  TMDBApp
//
//  Created by Artyom Butorin on 23.01.23.
//

import Foundation

struct Constants {
    static let apiKey = "79d5894567be5b76ab7434fc12879584"
    static let baseURL = "https://api.themoviedb.org/3/movie"
    static let basePosterURL = "https://image.tmdb.org/t/p/w500"
    static let searchingMovieURL = "https://api.themoviedb.org/3/search/movie"
    static let mainSiteURL = "https://www.themoviedb.org/"
    static let errorConnection = """
    Unable to connect to the server,
    check the internet connection or use a VPN,
    then restart the application.
    """
    
    static let popularKey = "popularSectionSelectedKey"
    static let upcomingKey = "upcomingSectionSelectedKey"
    static let favorietsKey = "favorietsKey"
}

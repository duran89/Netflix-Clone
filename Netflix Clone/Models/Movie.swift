//
//  Movie.swift
//  Netflix Clone
//
//  Created by 권정근 on 3/4/24.
//

import Foundation


struct TrendingMoviesResponse {
    let results: [Movie]
}


struct Movie {
    let id: Int
    let media_type: String?
    let original_name: String?
    let original_title: String?
    let poster_path: String?
    let overview: String?
    let vote_count: Int
    let release_date: String?
    let vote_average: Double
}

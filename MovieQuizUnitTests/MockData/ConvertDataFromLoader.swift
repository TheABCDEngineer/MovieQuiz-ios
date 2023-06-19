//
//  ConvertDataFromLoader.swift
//  MovieQuizTests
//
//  Created by Avtor_103 on 15.06.2023.
//

import Foundation
@testable import MovieQuiz

struct MockConvertData {
    static var movies: [MovieModel] = [
        MovieModel(
            id: "tt11866324",
            imageUrl: URL(string: "https://m.media-amazon.com/images/M/MV5BMDBlMDYxMDktOTUxMS00MjcxLWE2YjQtNjNhMjNmN2Y3ZDA1XkEyXkFqcGdeQXVyMTM1MTE1NDMx._V0_UX600_.jpg"),
            movieRank: 7.2
        ),
        MovieModel(
            id: "tt1649418",
            imageUrl: URL(string: "https://m.media-amazon.com/images/M/MV5BOWY4MmFiY2QtMzE1YS00NTg1LWIwOTQtYTI4ZGUzNWIxNTVmXkEyXkFqcGdeQXVyODk4OTc3MTY@._V0_UX600_.jpg"),
            movieRank: 6.5
        )
    ]
}

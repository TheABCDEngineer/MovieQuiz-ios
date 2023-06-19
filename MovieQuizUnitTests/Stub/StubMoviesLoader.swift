//
//  NetworkLoader.swift
//  MovieQuizTests
//
//  Created by Avtor_103 on 15.06.2023.
//

import Foundation
@testable import MovieQuiz

class StubMoviesLoader: MoviesLoaderProtocol {
    var requaredMoviesCount: Int
    init(requaredMoviesCount: Int) {
        self.requaredMoviesCount = requaredMoviesCount
    }
    
    func getMoviesList(onSuccess: @escaping ([MovieQuiz.MovieModel]) -> Void, onFailure: @escaping (String) -> Void) {
        onSuccess(
            getMoviesList(listCount: requaredMoviesCount)
        )
    }
}
private extension StubMoviesLoader {
    func getMoviesList(listCount: Int) -> [MovieModel] {
        let mockMovie = MockConvertData.movies[0]
        var movieList = [MovieModel]()
        for index in 0...listCount-1 {
            let movie = MovieModel(
                id: mockMovie.id + String(index),
                imageUrl: mockMovie.imageUrl,
                movieRank: mockMovie.movieRank
            )
            movieList.append(movie)
        }
        return movieList
    }
}

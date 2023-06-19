import Foundation

protocol MoviesLoaderProtocol {
    func getMoviesList(
        onSuccess: @escaping ([MovieModel]) -> Void,
        onFailure: @escaping (String) -> Void
    )
}

import Foundation

protocol NetworkLoaderProtocol {
    func getMoviesList(
        onSuccess: @escaping ([MovieModel]) -> Void,
        onFailure: @escaping (String) -> Void
    )
}

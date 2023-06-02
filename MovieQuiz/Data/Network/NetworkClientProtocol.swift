import Foundation

protocol NetworkClientProtocol {
    func fetch(
        url: URL,
        onSuccess: @escaping (Data) -> Void,
        onFailure: @escaping (String) -> Void
    )
}

import Foundation

struct ResponseDto: Codable {
    let errorMessage: String
    let items: [MovieDto]
}

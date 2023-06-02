import Foundation

struct MovieDto: Codable {
    let id: String
    let imageUrl: String
    let movieRank: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case imageUrl = "image"
        case movieRank = "imDbRating"
    }
}

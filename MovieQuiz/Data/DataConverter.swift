import Foundation

class DataConverter {
    func convertMovieDtoToModel(_ dto: MovieDto) -> MovieModel {
        return MovieModel(
            id: dto.id,
            imageUrl: URL(
                string: getLinkForResizeImage(baseLink: dto.imageUrl)
            ),
            movieRank: Float(dto.movieRank) ?? 0
        )
    }
    
    func convertMovieDtoToModel(_ arrayDto: [MovieDto]) -> [MovieModel] {
        var arrayQuestionModel = [MovieModel]()
        
        for element in arrayDto {
            arrayQuestionModel.append(
                convertMovieDtoToModel(element)
            )
        }
        return arrayQuestionModel
    }
    
    private func getLinkForResizeImage(baseLink: String) -> String {
        let newLink = baseLink.components(separatedBy: "._")[0] + "._V0_UX600_.jpg"
        guard URL(string: newLink) != nil else {
            return baseLink
        }
        return newLink
    }
}

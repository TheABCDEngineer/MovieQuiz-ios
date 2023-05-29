import Foundation

class DataConverter {
    func convertQuestionDtoToModel(_ dto: QuestionDto) -> QuestionModel {
        return QuestionModel(
            id: dto.id,
            image: createImageDataFromUrl(
                getLinkForResizeImage(baseLink: dto.imageUrl)
            ),
            movieRank: Float(dto.movieRank) ?? 0
        )
    }
    
    func convertQuestionDtoToModel(_ arrayDto: [QuestionDto]) -> [QuestionModel] {
        var arrayQuestionModel = [QuestionModel]()
        
        for element in arrayDto {
            arrayQuestionModel.append(
                convertQuestionDtoToModel(element)
            )
        }
        return arrayQuestionModel
    }
    
    private func createImageDataFromUrl(_ link: String) -> Data {
        guard let url = URL(
            string: link
        ) else {
            return Data()
        }
        
        var imageData = Data()
        do {
            imageData = try Data(contentsOf: url)
        } catch {}
        
        return imageData
    }
    
    private func getLinkForResizeImage(baseLink: String) -> String {
        let newLink = baseLink.components(separatedBy: "._")[0] + "._V0_UX600_.jpg"
        guard URL(string: newLink) != nil else {
            return baseLink
        }
        return newLink
    }
}

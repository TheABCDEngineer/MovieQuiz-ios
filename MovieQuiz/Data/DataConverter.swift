import Foundation
class DataConverter {
    static func convertQuestionDtoToModel(_ dto: QuestionDto) -> QuestionModel {
        return QuestionModel(
            imageUrl: dto.imageTitle,
            movieRank: dto.movieRank
        )
    }
    
    static func convertQuestionDtoToModel(_ arrayDto: [QuestionDto]) -> [QuestionModel] {
        var arrayQuestionModel = [QuestionModel]()
        
        for element in arrayDto {
            arrayQuestionModel.append(
                DataConverter.convertQuestionDtoToModel(element)
            )
        }
        return arrayQuestionModel
    }
}

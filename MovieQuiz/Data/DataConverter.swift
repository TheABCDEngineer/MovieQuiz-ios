import Foundation
class DataConverter {
    class func convertQuestionDtoToModel(_ dto: QuestionDto) -> QuestionModel {
        return QuestionModel(
            imageUrl: dto.imageTitle,
            movieRank: dto.movieRank
        )
    }
    
    class func convertQuestionDtoToModel(_ arrayDto: [QuestionDto]) -> [QuestionModel] {
        var arrayQuestionModel = [QuestionModel]()
        
        for element in arrayDto {
            arrayQuestionModel.append(
                DataConverter.convertQuestionDtoToModel(element)
            )
        }
        return arrayQuestionModel
    }
}

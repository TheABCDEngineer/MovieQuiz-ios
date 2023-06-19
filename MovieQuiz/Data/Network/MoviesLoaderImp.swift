import Foundation

class MoviesLoaderImp: MoviesLoaderProtocol {
    private let networkClient: NetworkClientProtocol
    
    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
    func getMoviesList(
        onSuccess: @escaping ([MovieModel]) -> Void,
        onFailure: @escaping (String) -> Void
    ){
        guard let url = URL(
            string: "https://imdb-api.com/en/API/Top250Movies/k_2ssogtwm"
        ) else {
            onFailure("Unable to construct URL")
            return
        }
        
        networkClient.fetch(
            url: url,
            onSuccess: { [weak self] response in
                guard let self = self else { return }
                do {
                    let dto = try JSONDecoder().decode(ResponseDto.self, from: response)
                    onSuccess(
                        self.convertMovieDtoToModel(dto.items)
                    )
                } catch {
                    onFailure("Ошибка данных с сервера")
                }
            },
            onFailure: {error in
                onFailure(error)
            }
        )
    }
}

private extension MoviesLoaderImp {
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
    
    func getLinkForResizeImage(baseLink: String) -> String {
        let newLink = baseLink.components(separatedBy: "._")[0] + "._V0_UX600_.jpg"
        guard URL(string: newLink) != nil else {
            return baseLink
        }
        return newLink
    }
}

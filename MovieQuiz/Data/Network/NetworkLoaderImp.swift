import Foundation

class NetworkLoaderImp: NetworkLoaderProtocol {
    private let networkClient: NetworkClientProtocol
    private let dataConverter = DataConverter()
    
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
                        self.dataConverter.convertMovieDtoToModel(dto.items)
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

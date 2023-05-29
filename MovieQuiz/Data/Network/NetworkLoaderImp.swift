import Foundation

class NetworkLoaderImp: NetworkLoaderProtocol {
    private let networkClient: NetworkClientProtocol
    private let dataConverter = DataConverter()
    
    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
    func getQuestionsList(
        onSuccess: @escaping ([QuestionModel]) -> Void,
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
            onSuccess: {response in
                DispatchQueue.global().async { [weak self] in
                    do {
                        let dto = try JSONDecoder().decode(ResponseDto.self, from: response)
                        onSuccess(
                            (self?.dataConverter.convertQuestionDtoToModel(dto.items))!
                        )
                    } catch {
                        onFailure("Ошибка данных с сервера")
                    }
                }
            },
            onFailure: {error in
                onFailure(error)
            }
        )
    }
}

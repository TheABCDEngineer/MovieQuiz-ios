import Foundation

class NetworkClient: NetworkClientProtocol {
    
    func fetch(
        url: URL,
        onSuccess: @escaping (Data) -> Void,
        onFailure: @escaping (String) -> Void
    ) {
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                onFailure(error.localizedDescription)
                return
            }
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                onFailure("Ошибка " + String(response.statusCode))
                return
            }
            guard let data = data else {
                onFailure("Ошибка сервера")
                return
            }
            onSuccess(data)
        }
        task.resume()
    }
}

import Foundation

public class GraphQLClient {
    private let session: URLSession
    private let config: GitHubKitConfiguration

    public init(config: GitHubKitConfiguration, session: URLSession = .shared) {
        self.config = config
        self.session = session
    }
    
    func performOperation<Output: Decodable>(_ operation: GraphQLOperation) async throws -> Output {
        
        var request: URLRequest = try operation.getURLRequest()
        request.addValue("Bearer \(config.token)", forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.getData(from: request)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let result = try decoder.decode(GraphQLResult<Output>.self, from: data)
        guard let object = result.object else {
            print(result.errorMessages.joined(separator: "\n"))
            throw NSError(domain: "Error", code: 1)
        }
        
        return object
    }
}

extension URLSession {
    func getData(from urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: urlRequest) { data, response, error in
                guard let data = data, let response = response else {
                    let error = error ?? URLError(.badServerResponse)
                    return continuation.resume(throwing: error)
                }
                
                continuation.resume(returning: (data, response))
            }
            
            task.resume()
        }
    }
}

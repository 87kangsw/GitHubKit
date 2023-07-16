import Foundation

public class RestClient {
    private let session: URLSession
    private let config: GitHubKitConfiguration

    public init(config: GitHubKitConfiguration, session: URLSession = .shared) {
        self.config = config
        self.session = session
    }

    public func send<T: Decodable>(_ api: GitHubAPI) async throws -> T {
        var request = try api.asURLRequest(baseURL: Constants.URLs.REST_URL)
        request.addValue("Bearer \(config.token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let decodedData = try decoder.decode(T.self, from: data)
        return decodedData
    }

}

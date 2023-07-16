import Foundation

public enum GitHubAPI {
    case userInfo
}

extension GitHubAPI {
    var method: HTTPMethod {
        switch self {
        case .userInfo:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .userInfo:
            return "/user"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .userInfo:
            return nil
        }
        
    }
    
    public func asURLRequest(baseURL: URL) throws -> URLRequest {
            var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: true)
            components?.queryItems = queryItems
            
            guard let url = components?.url else {
                throw URLError(.badURL)
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            return request
        }
}

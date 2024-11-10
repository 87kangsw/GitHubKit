import Foundation

public enum GitHubAPI {
    case userInfo
    case userEvents(username: String, page: Int?)
    case userReceivedEvents(username: String, page: Int?)
}

extension GitHubAPI {
    var method: HTTPMethod {
        switch self {
        case .userInfo, .userEvents, .userReceivedEvents:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .userInfo:
            return "/user"
        case .userEvents(let username, _):
            return "/users/\(username)/events"
        case .userReceivedEvents(let username, _):
            return "/users/\(username)/received_events"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .userInfo:
            return nil
        case .userEvents(_, let page), .userReceivedEvents(_, let page):
            var items: [URLQueryItem] = []
            if let page = page {
                items.append(URLQueryItem(name: "page", value: "\(page)"))
                items.append(URLQueryItem(name: "per_page", value: "30"))
            }
            return items.isEmpty ? nil : items
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

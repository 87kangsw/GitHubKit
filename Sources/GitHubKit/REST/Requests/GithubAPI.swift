import Foundation

public enum GitHubAPI {
    case userInfo
    case user(username: String)
    case userEvents(username: String, page: Int?)
    case userReceivedEvents(username: String, page: Int?)
    case userFollowers(username: String, page: Int?)
    case userFollowing(username: String, page: Int?)
    case searchUsers(query: String, page: Int?)
    case searchRepositories(query: String, page: Int?, language: String?)
    case contributors(owner: String, repo: String)
}

extension GitHubAPI {
    var method: HTTPMethod {
        switch self {
        case .userInfo, .user, .userEvents, .userReceivedEvents, .userFollowers, .userFollowing, .searchUsers, .searchRepositories, .contributors:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .userInfo:
            return "/user"
        case .user(let username):
            return "/users/\(username)"
        case .userEvents(let username, _):
            return "/users/\(username)/events"
        case .userReceivedEvents(let username, _):
            return "/users/\(username)/received_events"
        case .userFollowers(let username, _):
            return "/users/\(username)/followers"
        case .userFollowing(let username, _):
            return "/users/\(username)/following"
        case .searchUsers:
            return "/search/users"
        case .searchRepositories:
            return "/search/repositories"
        case .contributors(let owner, let repo):
            return "/repos/\(owner)/\(repo)/contributors"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .userInfo, .user, .contributors:
            return nil
        case .userEvents(_, let page), .userReceivedEvents(_, let page):
            var items: [URLQueryItem] = []
            if let page = page {
                items.append(URLQueryItem(name: "page", value: "\(page)"))
                items.append(URLQueryItem(name: "per_page", value: "30"))
            }
            return items.isEmpty ? nil : items
        case .userFollowers(_, let page), .userFollowing(_, let page):
            var items: [URLQueryItem] = []
            if let page = page {
                items.append(URLQueryItem(name: "page", value: "\(page)"))
                items.append(URLQueryItem(name: "per_page", value: "30"))
            }
            return items.isEmpty ? nil : items
        case .searchUsers(let query, let page):
            var items: [URLQueryItem] = [URLQueryItem(name: "q", value: query)]
            if let page = page {
                items.append(URLQueryItem(name: "page", value: "\(page)"))
                items.append(URLQueryItem(name: "per_page", value: "30"))
            }
            return items
        case .searchRepositories(let query, let page, let language):
            var searchQuery = query
            if let language = language {
                searchQuery += " language:\(language)"
            }
            var items: [URLQueryItem] = [URLQueryItem(name: "q", value: searchQuery)]
            if let page = page {
                items.append(URLQueryItem(name: "page", value: "\(page)"))
                items.append(URLQueryItem(name: "per_page", value: "30"))
            }
            return items
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

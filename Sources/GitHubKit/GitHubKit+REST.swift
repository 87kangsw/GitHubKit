import Foundation

// MARK: - For REST API

extension GitHubKit {
    
    public func userInfo() async throws -> RestResponse.User {
        try await restClient.send(GitHubAPI.userInfo)
    }
    
    public func userEvents(
        username: String,
        page: Int? = nil
    ) async throws -> [RestResponse.Event] {
        try await restClient.send(GitHubAPI.userEvents(username: username, page: page))
    }
    
    public func userReceivedEvents(
        username: String,
        page: Int? = nil
    ) async throws -> [RestResponse.Event] {
        try await restClient.send(GitHubAPI.userReceivedEvents(username: username, page: page))
    }
}


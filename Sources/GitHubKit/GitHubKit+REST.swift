import Foundation

// MARK: - For REST API

extension GitHubKit {
    
    public func userInfo() async throws -> RestResponse.User {
        try await restClient.send(GitHubAPI.userInfo)
    }
}


import Foundation

// MARK: - For REST API

extension GitHubKit {

    // MARK: - User APIs

    public func userInfo() async throws -> RestResponse.User {
        try await restClient.send(GitHubAPI.userInfo)
    }

    public func userInfo(username: String) async throws -> RestResponse.User {
        try await restClient.send(GitHubAPI.user(username: username))
    }

    // MARK: - Activity APIs

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

    // MARK: - Follow APIs

    public func userFollowers(
        username: String,
        page: Int? = nil
    ) async throws -> [RestResponse.User] {
        try await restClient.send(GitHubAPI.userFollowers(username: username, page: page))
    }

    public func userFollowing(
        username: String,
        page: Int? = nil
    ) async throws -> [RestResponse.User] {
        try await restClient.send(GitHubAPI.userFollowing(username: username, page: page))
    }

    // MARK: - Search APIs

    public func searchUsers(
        query: String,
        page: Int? = nil
    ) async throws -> RestResponse.SearchResult<RestResponse.SearchUser> {
        try await restClient.send(GitHubAPI.searchUsers(query: query, page: page))
    }

    public func searchRepositories(
        query: String,
        page: Int? = nil,
        language: String? = nil
    ) async throws -> RestResponse.SearchResult<RestResponse.SearchRepository> {
        try await restClient.send(GitHubAPI.searchRepositories(query: query, page: page, language: language))
    }

    // MARK: - Repository APIs

    public func contributors(
        owner: String,
        repo: String
    ) async throws -> [RestResponse.Contributor] {
        try await restClient.send(GitHubAPI.contributors(owner: owner, repo: repo))
    }
}


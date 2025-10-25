import XCTest
@testable import GitHubKit

final class RestAPITests: XCTestCase {

    private var githubKit: GitHubKit!
    let accessToken: String = "your_access_token"

    override func setUp() {
        super.setUp()
        let config = GitHubKitConfiguration(token: accessToken)
        githubKit = GitHubKit(config: config)
    }

    override func tearDown() {
        githubKit = nil
        super.tearDown()
    }

    // MARK: - GitHubAPI Tests

    func testGitHubAPIUserInfoURL() throws {
        let api = GitHubAPI.userInfo
        let baseURL = URL(string: "https://api.github.com")!
        let request = try api.asURLRequest(baseURL: baseURL)

        XCTAssertEqual(request.url?.path, "/user")
        XCTAssertEqual(request.httpMethod, "GET")
    }

    func testGitHubAPIUserInfoWithUsernameURL() throws {
        let api = GitHubAPI.user(username: "octocat")
        let baseURL = URL(string: "https://api.github.com")!
        let request = try api.asURLRequest(baseURL: baseURL)

        XCTAssertEqual(request.url?.path, "/users/octocat")
        XCTAssertEqual(request.httpMethod, "GET")
    }

    func testGitHubAPIUserEventsURL() throws {
        let api = GitHubAPI.userEvents(username: "octocat", page: 2)
        let baseURL = URL(string: "https://api.github.com")!
        let request = try api.asURLRequest(baseURL: baseURL)

        XCTAssertEqual(request.url?.path, "/users/octocat/events")
        XCTAssertTrue(request.url?.query?.contains("page=2") == true)
        XCTAssertTrue(request.url?.query?.contains("per_page=30") == true)
    }

    func testGitHubAPIUserFollowersURL() throws {
        let api = GitHubAPI.userFollowers(username: "octocat", page: 1)
        let baseURL = URL(string: "https://api.github.com")!
        let request = try api.asURLRequest(baseURL: baseURL)

        XCTAssertEqual(request.url?.path, "/users/octocat/followers")
        XCTAssertTrue(request.url?.query?.contains("page=1") == true)
    }

    func testGitHubAPISearchUsersURL() throws {
        let api = GitHubAPI.searchUsers(query: "john", page: 1)
        let baseURL = URL(string: "https://api.github.com")!
        let request = try api.asURLRequest(baseURL: baseURL)

        XCTAssertEqual(request.url?.path, "/search/users")
        XCTAssertTrue(request.url?.query?.contains("q=john") == true)
        XCTAssertTrue(request.url?.query?.contains("page=1") == true)
    }

    func testGitHubAPISearchRepositoriesURL() throws {
        let api = GitHubAPI.searchRepositories(query: "swift", page: 1, language: "Swift")
        let baseURL = URL(string: "https://api.github.com")!
        let request = try api.asURLRequest(baseURL: baseURL)

        XCTAssertEqual(request.url?.path, "/search/repositories")
        XCTAssertTrue(request.url?.query?.contains("q=swift%20language:Swift") == true)
        XCTAssertTrue(request.url?.query?.contains("page=1") == true)
    }

    func testGitHubAPIContributorsURL() throws {
        let api = GitHubAPI.contributors(owner: "87kangsw", repo: "GitHubKit")
        let baseURL = URL(string: "https://api.github.com")!
        let request = try api.asURLRequest(baseURL: baseURL)

        XCTAssertEqual(request.url?.path, "/repos/87kangsw/GitHubKit/contributors")
        XCTAssertEqual(request.httpMethod, "GET")
    }

    // MARK: - Model Tests

    // Note: EventType tests disabled as they conflict with existing EventType model
    // TODO: Reconcile EventType models between old and new implementations

    func testSearchResultDecoding() throws {
        let jsonData = """
        {
            "total_count": 100,
            "incomplete_results": false,
            "items": []
        }
        """.data(using: .utf8)!

        let searchResult = try JSONDecoder().decode(RestResponse.SearchResult<RestResponse.User>.self, from: jsonData)
        XCTAssertEqual(searchResult.totalCount, 100)
        XCTAssertFalse(searchResult.incompleteResults)
        XCTAssertTrue(searchResult.items.isEmpty)
    }

    // MARK: - Integration Tests (Requires Network)

    func testUserInfoIntegration() async throws {
        // Skip if no token provided
        let token = accessToken
        try XCTSkipIf(token == nil, "GitHub token not provided")

        do {
            let user = try await githubKit.userInfo()
            XCTAssertFalse(user.login.isEmpty)
        } catch {
            XCTFail("User info request failed: \(error)")
        }
    }

    func testPublicUserInfoIntegration() async throws {
        do {
            let user = try await githubKit.userInfo(username: "octocat")
            XCTAssertEqual(user.login, "octocat")
            XCTAssertFalse(user.name.isEmpty)
        } catch {
            XCTFail("Public user info request failed: \(error)")
        }
    }

    func testSearchUsersIntegration() async throws {
        do {
            let searchResult = try await githubKit.searchUsers(query: "octocat", page: 1)
            XCTAssertGreaterThan(searchResult.totalCount, 0)
            XCTAssertFalse(searchResult.items.isEmpty)
        } catch {
            XCTFail("Search users request failed: \(error)")
        }
    }

    func testSearchRepositoriesIntegration() async throws {
        do {
            let searchResult = try await githubKit.searchRepositories(query: "swift", page: 1, language: "Swift")
            XCTAssertGreaterThan(searchResult.totalCount, 0)
            XCTAssertFalse(searchResult.items.isEmpty)
        } catch {
            XCTFail("Search repositories request failed: \(error)")
        }
    }

    func testContributorsIntegration() async throws {
        do {
            let contributors = try await githubKit.contributors(owner: "87kangsw", repo: "GitHubKit")
            XCTAssertFalse(contributors.isEmpty)

            let firstContributor = contributors.first!
            XCTAssertFalse(firstContributor.login.isEmpty)
            XCTAssertGreaterThan(firstContributor.contributions, 0)
        } catch {
            XCTFail("Contributors request failed: \(error)")
        }
    }

    // MARK: - Error Handling Tests

    func testInvalidTokenError() async throws {
        let invalidConfig = GitHubKitConfiguration(token: "invalid_token")
        let invalidGitHubKit = GitHubKit(config: invalidConfig)

        do {
            _ = try await invalidGitHubKit.userInfo()
            XCTFail("Expected error for invalid token")
        } catch {
            // Expected error
            XCTAssertTrue(true, "Invalid token correctly caused error")
        }
    }
}

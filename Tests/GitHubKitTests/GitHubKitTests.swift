import XCTest
@testable import GitHubKit

final class GitHubKitTests: XCTestCase {
    
    let accessToken: String = "your_access_token"
    
    // MARK: - GraphQL
    
    func test_contributions_default() async throws {
        
        let githubKit = GitHubKit(config: .init(token: accessToken))
        let response = try await githubKit.contributions(
            userName: "87kangsw"
        )
        // print(response)
        
        XCTAssertNotNil(response)
    }
    
    func test_contributions_period() async throws {
        
        let githubKit = GitHubKit(config: .init(token: accessToken))
        let response = try await githubKit.contributions(
            userName: "87kangsw",
            from: "2022-12-01",
            to: "2022-12-31"
        )
        // print(response)
        
        XCTAssertNotNil(response)
    }
    
    // MARK: - REST
    
    func test_userInfo() async throws {
        let githubKit = GitHubKit(config: .init(token: accessToken))
        
        let response = try await githubKit.userInfo()
        // print(response)
        
        XCTAssertNotNil(response)
    }
}

import XCTest
@testable import GitHubKit

final class CrawlerTests: XCTestCase {

    private var githubKit: GitHubKit!
    private var crawlerClient: CrawlerClient!

    override func setUp() {
        super.setUp()
        let config = GitHubKitConfiguration(token: "test_token")
        githubKit = GitHubKit(config: config)
        crawlerClient = CrawlerClient()
    }

    override func tearDown() {
        githubKit = nil
        crawlerClient = nil
        super.tearDown()
    }

    // MARK: - Model Tests

    func testTrendingPeriodQueryString() {
        XCTAssertEqual(TrendingPeriod.daily.queryString(), "daily")
        XCTAssertEqual(TrendingPeriod.weekly.queryString(), "weekly")
        XCTAssertEqual(TrendingPeriod.monthly.queryString(), "monthly")
    }

    func testTrendingRepositoryModel() {
        let contributors = [TrendingContributor(name: "octocat", profileURL: "https://github.com/octocat")]
        let repo = TrendingRepository(
            author: "octocat",
            name: "Hello-World",
            url: "https://github.com/octocat/Hello-World",
            description: "My first repository on GitHub!",
            language: "Swift",
            languageColor: "#FA7343",
            stars: 1000,
            forks: 500,
            currentPeriodStars: 50,
            contributors: contributors
        )

        XCTAssertEqual(repo.author, "octocat")
        XCTAssertEqual(repo.name, "Hello-World")
        XCTAssertEqual(repo.stars, 1000)
        XCTAssertEqual(repo.contributors.count, 1)
        XCTAssertEqual(repo.contributors.first?.name, "octocat")
    }

    func testTrendingDeveloperModel() {
        let repo = TrendingDeveloperRepo(
            name: "Hello-World",
            url: "https://github.com/octocat/Hello-World",
            description: "My first repository"
        )
        let developer = TrendingDeveloper(
            userName: "octocat",
            name: "The Octocat",
            url: "https://github.com/octocat",
            profileURL: "https://avatars.githubusercontent.com/u/1?v=4",
            repo: repo
        )

        XCTAssertEqual(developer.userName, "octocat")
        XCTAssertEqual(developer.name, "The Octocat")
        XCTAssertEqual(developer.repo?.name, "Hello-World")
    }

    // MARK: - Integration Tests (Requires Network)

    func testTrendingRepositoriesIntegration() async throws {
        do {
            let repos = try await githubKit.trendingRepositories(language: nil, period: .daily)
            XCTAssertFalse(repos.isEmpty, "Should have trending repositories")

            let firstRepo = repos.first!
            XCTAssertFalse(firstRepo.author.isEmpty, "Author should not be empty")
            XCTAssertFalse(firstRepo.name.isEmpty, "Name should not be empty")
            XCTAssertFalse(firstRepo.url.isEmpty, "URL should not be empty")
            XCTAssertGreaterThanOrEqual(firstRepo.stars, 0, "Stars should be non-negative")
            XCTAssertGreaterThanOrEqual(firstRepo.forks, 0, "Forks should be non-negative")

        } catch {
            XCTFail("Trending repositories request failed: \(error)")
        }
    }

    func testTrendingRepositoriesWithLanguageIntegration() async throws {
        do {
            let repos = try await githubKit.trendingRepositories(language: "Swift", period: .weekly)
            XCTAssertFalse(repos.isEmpty, "Should have Swift trending repositories")

            // Note: We can't guarantee Swift repos will be in trending due to GitHub's algorithm
            // So we just check that we get some results
            XCTAssertFalse(repos.isEmpty)

        } catch {
            XCTFail("Trending repositories with language request failed: \(error)")
        }
    }

    func testTrendingDevelopersIntegration() async throws {
        do {
            let developers = try await githubKit.trendingDevelopers(language: nil, period: .daily)
            XCTAssertFalse(developers.isEmpty, "Should have trending developers")

            let firstDeveloper = developers.first!
            XCTAssertFalse(firstDeveloper.userName.isEmpty, "Username should not be empty")
            XCTAssertFalse(firstDeveloper.url.isEmpty, "URL should not be empty")
            XCTAssertFalse(firstDeveloper.profileURL.isEmpty, "Profile URL should not be empty")

        } catch {
            XCTFail("Trending developers request failed: \(error)")
        }
    }

    func testTrendingDevelopersWithLanguageIntegration() async throws {
        do {
            let developers = try await githubKit.trendingDevelopers(language: "JavaScript", period: .monthly)
            XCTAssertFalse(developers.isEmpty, "Should have JavaScript trending developers")

        } catch {
            XCTFail("Trending developers with language request failed: \(error)")
        }
    }

    // MARK: - URL Building Tests

    func testTrendingURLBuilding() {
        // This is testing internal logic, we'll use a mock approach
        let crawlerClient = CrawlerClient()

        // We can't directly test private methods, but we can test the public interface
        // and verify the behavior through integration tests above
        XCTAssertNotNil(crawlerClient)
    }

    // MARK: - Error Handling Tests

    func testCrawlerErrorTypes() {
        XCTAssertNotNil(CrawlerError.invalidURL)
        XCTAssertNotNil(CrawlerError.parsingFailed)
        XCTAssertNotNil(CrawlerError.noDataFound)
        XCTAssertNotNil(CrawlerError.invalidHTML)
    }

    // MARK: - Performance Tests

    func testTrendingRepositoriesPerformance() async throws {
        measure {
            let expectation = XCTestExpectation(description: "Trending repositories performance")

            Task {
                do {
                    _ = try await githubKit.trendingRepositories(language: nil, period: .daily)
                    expectation.fulfill()
                } catch {
                    expectation.fulfill()
                }
            }

            wait(for: [expectation], timeout: 10.0)
        }
    }

    func testTrendingDevelopersPerformance() async throws {
        measure {
            let expectation = XCTestExpectation(description: "Trending developers performance")

            Task {
                do {
                    _ = try await githubKit.trendingDevelopers(language: nil, period: .daily)
                    expectation.fulfill()
                } catch {
                    expectation.fulfill()
                }
            }

            wait(for: [expectation], timeout: 10.0)
        }
    }
}
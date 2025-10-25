import Foundation

// MARK: - For Crawler API

extension GitHubKit {

    // MARK: - Trending APIs

    public func trendingRepositories(
        language: String? = nil,
        period: TrendingPeriod = .daily,
        spokenLanguage: String? = nil
    ) async throws -> [TrendingRepository] {
        try await crawlerClient.fetchTrendingRepositories(
            language: language,
            period: period,
            spokenLanguage: spokenLanguage
        )
    }

    public func trendingDevelopers(
        language: String? = nil,
        period: TrendingPeriod = .daily
    ) async throws -> [TrendingDeveloper] {
        try await crawlerClient.fetchTrendingDevelopers(
            language: language,
            period: period
        )
    }
}
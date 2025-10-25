import Foundation

public struct TrendingRepository {
    public let author: String
    public let name: String
    public let url: String
    public let description: String?
    public let language: String?
    public let languageColor: String?
    public let stars: Int
    public let forks: Int
    public let currentPeriodStars: Int
    public let contributors: [TrendingContributor]

    public init(
        author: String,
        name: String,
        url: String,
        description: String?,
        language: String?,
        languageColor: String?,
        stars: Int,
        forks: Int,
        currentPeriodStars: Int,
        contributors: [TrendingContributor]
    ) {
        self.author = author
        self.name = name
        self.url = url
        self.description = description
        self.language = language
        self.languageColor = languageColor
        self.stars = stars
        self.forks = forks
        self.currentPeriodStars = currentPeriodStars
        self.contributors = contributors
    }
}

public struct TrendingDeveloper {
    public let userName: String
    public let name: String?
    public let url: String
    public let profileURL: String
    public let repo: TrendingDeveloperRepo?

    public init(
        userName: String,
        name: String?,
        url: String,
        profileURL: String,
        repo: TrendingDeveloperRepo?
    ) {
        self.userName = userName
        self.name = name
        self.url = url
        self.profileURL = profileURL
        self.repo = repo
    }
}

public struct TrendingDeveloperRepo {
    public let name: String?
    public let url: String
    public let description: String

    public init(name: String?, url: String, description: String) {
        self.name = name
        self.url = url
        self.description = description
    }
}

public struct TrendingContributor {
    public let name: String
    public let profileURL: String

    public init(name: String, profileURL: String) {
        self.name = name
        self.profileURL = profileURL
    }
}

public enum TrendingPeriod: String, CaseIterable {
    case daily = "daily"
    case weekly = "weekly"
    case monthly = "monthly"

    public func queryString() -> String {
        return self.rawValue
    }
}

public enum CrawlerError: Error {
    case invalidURL
    case networkError(Error)
    case parsingFailed
    case noDataFound
    case invalidHTML
}
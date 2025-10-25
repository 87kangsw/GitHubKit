import Foundation
import Kanna

public class CrawlerClient {
    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func fetchTrendingRepositories(
        language: String? = nil,
        period: TrendingPeriod = .daily,
        spokenLanguage: String? = nil
    ) async throws -> [TrendingRepository] {
        let url = buildTrendingURL(
            type: .repositories,
            language: language,
            period: period,
            spokenLanguage: spokenLanguage
        )

        let (data, _) = try await session.data(from: url)
        return try parseTrendingRepositories(data: data)
    }

    public func fetchTrendingDevelopers(
        language: String? = nil,
        period: TrendingPeriod = .daily
    ) async throws -> [TrendingDeveloper] {
        let url = buildTrendingURL(
            type: .developers,
            language: language,
            period: period
        )

        let (data, _) = try await session.data(from: url)
        return try parseTrendingDevelopers(data: data)
    }

    // MARK: - Private Methods

    private enum TrendingType {
        case repositories
        case developers
    }

    private func buildTrendingURL(
        type: TrendingType,
        language: String? = nil,
        period: TrendingPeriod = .daily,
        spokenLanguage: String? = nil
    ) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "github.com"

        switch type {
        case .repositories:
            components.path = "/trending"
        case .developers:
            components.path = "/trending/developers"
        }

        var queryItems: [URLQueryItem] = []

        if let language = language, !language.isEmpty {
            queryItems.append(URLQueryItem(name: "l", value: language))
        }

        if period != .daily {
            queryItems.append(URLQueryItem(name: "since", value: period.queryString()))
        }

        if let spokenLanguage = spokenLanguage, !spokenLanguage.isEmpty {
            queryItems.append(URLQueryItem(name: "spoken_language_code", value: spokenLanguage))
        }

        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }

        return components.url!
    }

    private func parseTrendingRepositories(data: Data) throws -> [TrendingRepository] {
        guard let html = String(data: data, encoding: .utf8),
              let doc = try? HTML(html: html, encoding: .utf8) else {
            throw CrawlerError.parsingFailed
        }

        var repositories: [TrendingRepository] = []

        for item in doc.xpath("//article[@class='Box-row']") {
            var trendRepo = TrendingRepository(
                author: "",
                name: "",
                url: "",
                description: nil,
                language: nil,
                languageColor: nil,
                stars: 0,
                forks: 0,
                currentPeriodStars: 0,
                contributors: []
            )

            // Repository Info
            let repositoryInfo = item.xpath(".//h2[@class='h3 lh-condensed']/a")
            let description = item.xpath(".//p[@class='col-9 color-fg-muted my-1 pr-4']")
            let languageColor = item.xpath(".//span[@class='d-inline-block ml-0 mr-3']/span[1]")
            let language = item.xpath(".//span[@class='d-inline-block ml-0 mr-3']/span[2]")
            let star = item.xpath(".//div[@class='f6 color-fg-muted mt-2']/a[1]")
            let fork = item.xpath(".//div[@class='f6 color-fg-muted mt-2']/a[2]")
            let todayStar = item.xpath(".//div[@class='f6 color-fg-muted mt-2']/span[@class='d-inline-block float-sm-right']")

            // Repository Info
            if let repositoryInfo = repositoryInfo.first {
                if let href = repositoryInfo["href"] {
                    let url = "https://github.com\(href)"
                    let userdata = href.split(separator: "/")
                    let author = String(userdata[0])
                    let name = String(userdata[1])

                    trendRepo = TrendingRepository(
                        author: author,
                        name: name,
                        url: url,
                        description: trendRepo.description,
                        language: trendRepo.language,
                        languageColor: trendRepo.languageColor,
                        stars: trendRepo.stars,
                        forks: trendRepo.forks,
                        currentPeriodStars: trendRepo.currentPeriodStars,
                        contributors: trendRepo.contributors
                    )
                }
            }

            if let description = description.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
                trendRepo = TrendingRepository(
                    author: trendRepo.author,
                    name: trendRepo.name,
                    url: trendRepo.url,
                    description: description,
                    language: trendRepo.language,
                    languageColor: trendRepo.languageColor,
                    stars: trendRepo.stars,
                    forks: trendRepo.forks,
                    currentPeriodStars: trendRepo.currentPeriodStars,
                    contributors: trendRepo.contributors
                )
            }

            if let color = languageColor.first, let style = color["style"] {
                let bgCode = String(style.split(separator: ":")[1]).trimmingCharacters(in: .whitespacesAndNewlines)
                trendRepo = TrendingRepository(
                    author: trendRepo.author,
                    name: trendRepo.name,
                    url: trendRepo.url,
                    description: trendRepo.description,
                    language: trendRepo.language,
                    languageColor: bgCode,
                    stars: trendRepo.stars,
                    forks: trendRepo.forks,
                    currentPeriodStars: trendRepo.currentPeriodStars,
                    contributors: trendRepo.contributors
                )
            }

            if let language = language.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
                trendRepo = TrendingRepository(
                    author: trendRepo.author,
                    name: trendRepo.name,
                    url: trendRepo.url,
                    description: trendRepo.description,
                    language: language,
                    languageColor: trendRepo.languageColor,
                    stars: trendRepo.stars,
                    forks: trendRepo.forks,
                    currentPeriodStars: trendRepo.currentPeriodStars,
                    contributors: trendRepo.contributors
                )
            }

            if var star = star.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
                star = star.replacingOccurrences(of: ",", with: "")
                let stars = Int(star) ?? 0
                trendRepo = TrendingRepository(
                    author: trendRepo.author,
                    name: trendRepo.name,
                    url: trendRepo.url,
                    description: trendRepo.description,
                    language: trendRepo.language,
                    languageColor: trendRepo.languageColor,
                    stars: stars,
                    forks: trendRepo.forks,
                    currentPeriodStars: trendRepo.currentPeriodStars,
                    contributors: trendRepo.contributors
                )
            }

            if var fork = fork.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
                fork = fork.replacingOccurrences(of: ",", with: "")
                let forks = Int(fork) ?? 0
                trendRepo = TrendingRepository(
                    author: trendRepo.author,
                    name: trendRepo.name,
                    url: trendRepo.url,
                    description: trendRepo.description,
                    language: trendRepo.language,
                    languageColor: trendRepo.languageColor,
                    stars: trendRepo.stars,
                    forks: forks,
                    currentPeriodStars: trendRepo.currentPeriodStars,
                    contributors: trendRepo.contributors
                )
            }

            if let today = todayStar.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
                let result = today.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789.").inverted)
                let currentPeriodStars = Int(result) ?? 0
                trendRepo = TrendingRepository(
                    author: trendRepo.author,
                    name: trendRepo.name,
                    url: trendRepo.url,
                    description: trendRepo.description,
                    language: trendRepo.language,
                    languageColor: trendRepo.languageColor,
                    stars: trendRepo.stars,
                    forks: trendRepo.forks,
                    currentPeriodStars: currentPeriodStars,
                    contributors: trendRepo.contributors
                )
            }

            // Contributors
            var contributors: [TrendingContributor] = []
            for i in 1...5 {
                if let profile = item.xpath(".//div[@class='f6 color-fg-muted mt-2']/span[@class='d-inline-block mr-3']/a[@class='d-inline-block'][\(i)]/img[@class='avatar mb-1 avatar-user']/@src").first?.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                   let name = item.xpath(".//div[@class='f6 color-fg-muted mt-2']/span[@class='d-inline-block mr-3']/a[@class='d-inline-block'][\(i)]/@href").first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
                    let contributorModel = TrendingContributor(name: String(name.dropFirst()), profileURL: profile)
                    contributors.append(contributorModel)
                }
            }

            trendRepo = TrendingRepository(
                author: trendRepo.author,
                name: trendRepo.name,
                url: trendRepo.url,
                description: trendRepo.description,
                language: trendRepo.language,
                languageColor: trendRepo.languageColor,
                stars: trendRepo.stars,
                forks: trendRepo.forks,
                currentPeriodStars: trendRepo.currentPeriodStars,
                contributors: contributors
            )

            repositories.append(trendRepo)
        }

        return repositories
    }

    private func parseTrendingDevelopers(data: Data) throws -> [TrendingDeveloper] {
        guard let html = String(data: data, encoding: .utf8),
              let doc = try? HTML(html: html, encoding: .utf8) else {
            throw CrawlerError.parsingFailed
        }

        var developers: [TrendingDeveloper] = []

        for item in doc.xpath("//article[@class='Box-row d-flex']") {
            var trendDeveloperRepo = TrendingDeveloperRepo(name: nil, url: "", description: "")
            var trendDeveloper = TrendingDeveloper(userName: "", name: nil, url: "", profileURL: "", repo: trendDeveloperRepo)

            let name = item.xpath(".//div[@class='d-sm-flex flex-auto']/div[@class='col-sm-8 d-md-flex']/div[@class='col-md-6'][1]/h1")
            let username = item.xpath(".//div[@class='d-sm-flex flex-auto']/div[@class='col-sm-8 d-md-flex']/div[@class='col-md-6'][1]/p")
            let url = "https://github.com"
            let avatar = item.xpath(".//div[@class='mx-3']/a/img[@class='rounded avatar-user']/@src")
            let repoName = item.xpath(".//h1[@class='h4 lh-condensed']")
            let repoURL = item.xpath(".//h1[@class='h4 lh-condensed']/a/@href")
            let repoDescription = item.xpath(".//div[@class='f6 color-text-secondary mt-1']")
            let relativeURL = item.xpath(".//div[@class='d-sm-flex flex-auto']/div[@class='col-sm-8 d-md-flex']/div[@class='col-md-6'][1]/h1/a/@href")

            let developerName = name.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let userURL = (relativeURL.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines)).map { "\(url)\($0)" } ?? ""
            let userName = username.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let profileURL = avatar.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

            let repoNameText = repoName.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let repoURLText = (repoURL.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines)).map { "\(url)\($0)" } ?? ""
            let repoDescriptionText = repoDescription.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

            trendDeveloperRepo = TrendingDeveloperRepo(name: repoNameText, url: repoURLText, description: repoDescriptionText)
            trendDeveloper = TrendingDeveloper(userName: userName, name: developerName, url: userURL, profileURL: profileURL, repo: trendDeveloperRepo)

            developers.append(trendDeveloper)
        }

        return developers
    }
}

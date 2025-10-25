import Foundation

extension RestResponse {
    public struct SearchResult<T: Codable>: Codable {
        public let totalCount: Int
        public let incompleteResults: Bool
        public let items: [T]

        enum CodingKeys: String, CodingKey {
            case items
            case totalCount = "total_count"
            case incompleteResults = "incomplete_results"
        }
    }

    public struct SearchRepository: Codable {
        public let id: Int
        public let nodeId: String
        public let name: String
        public let fullName: String
        public let isPrivate: Bool
        public let owner: Owner
        public let htmlUrl: String
        public let description: String?
        public let fork: Bool
        public let url: String
        public let language: String?
        public let stargazersCount: Int
        public let watchersCount: Int
        public let forksCount: Int
        public let openIssuesCount: Int
        public let defaultBranch: String
        public let score: Double?
        public let createdAt: Date
        public let updatedAt: Date
        public let pushedAt: Date?

        enum CodingKeys: String, CodingKey {
            case id, name, fork, url, language, score, description
            case nodeId = "node_id"
            case fullName = "full_name"
            case isPrivate = "private"
            case owner
            case htmlUrl = "html_url"
            case stargazersCount = "stargazers_count"
            case watchersCount = "watchers_count"
            case forksCount = "forks_count"
            case openIssuesCount = "open_issues_count"
            case defaultBranch = "default_branch"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case pushedAt = "pushed_at"
        }

        public struct Owner: Codable {
            public let login: String
            public let id: Int
            public let nodeId: String
            public let avatarUrl: String
            public let gravatarId: String?
            public let url: String
            public let htmlUrl: String
            public let type: String

            enum CodingKeys: String, CodingKey {
                case login, id, url, type
                case nodeId = "node_id"
                case avatarUrl = "avatar_url"
                case gravatarId = "gravatar_id"
                case htmlUrl = "html_url"
            }
        }
    }

    public struct SearchUser: Codable {
        public let login: String
        public let id: Int
        public let nodeId: String
        public let avatarUrl: String
        public let gravatarId: String?
        public let url: String
        public let htmlUrl: String
        public let followersUrl: String
        public let followingUrl: String
        public let gistsUrl: String
        public let starredUrl: String
        public let subscriptionsUrl: String
        public let organizationsUrl: String
        public let reposUrl: String
        public let eventsUrl: String
        public let receivedEventsUrl: String
        public let type: String
        public let userViewType: String?
        public let siteAdmin: Bool
        public let score: Double

        enum CodingKeys: String, CodingKey {
            case login, id, url, type, score
            case nodeId = "node_id"
            case avatarUrl = "avatar_url"
            case gravatarId = "gravatar_id"
            case htmlUrl = "html_url"
            case followersUrl = "followers_url"
            case followingUrl = "following_url"
            case gistsUrl = "gists_url"
            case starredUrl = "starred_url"
            case subscriptionsUrl = "subscriptions_url"
            case organizationsUrl = "organizations_url"
            case reposUrl = "repos_url"
            case eventsUrl = "events_url"
            case receivedEventsUrl = "received_events_url"
            case userViewType = "user_view_type"
            case siteAdmin = "site_admin"
        }
    }

    public struct Contributor: Codable {
        public let login: String
        public let id: Int
        public let nodeId: String
        public let avatarUrl: String
        public let gravatarId: String?
        public let url: String
        public let htmlUrl: String
        public let type: String
        public let contributions: Int

        enum CodingKeys: String, CodingKey {
            case login, id, url, type, contributions
            case nodeId = "node_id"
            case avatarUrl = "avatar_url"
            case gravatarId = "gravatar_id"
            case htmlUrl = "html_url"
        }
    }
}
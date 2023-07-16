import Foundation

extension RestResponse {
    // MARK: - User
    public struct User: Decodable {
        public let id: Int
        public let login: String
        public let avatarURL: String
        public let gravatarID: String?
        public let url: String
        public let receivedEventsURL: String
        public let type: String
        public let name: String
        public let company: String?
        public let blog: String?
        public let location: String?
        public let email: String
        public let bio: String
        public let twitterUsername: String
        public let publicRepos: Int
        public let publicGists: Int
        public let followers: Int
        public let following: Int
        public let createdAt: Date
        public let updatedAt: Date?
        public let privateGists: Int
        public let totalPrivateRepos: Int
        public let ownedPrivateRepos: Int
        public let collaborators: Int
        public let plan: Plan

        enum CodingKeys: String, CodingKey {
            case login = "login"
            case id = "id"
            case avatarURL = "avatar_url"
            case gravatarID = "gravatar_id"
            case url = "html_url"
            case receivedEventsURL = "received_events_url"
            case type = "type"
            case name = "name"
            case company = "company"
            case blog = "blog"
            case location = "location"
            case email = "email"
            case bio = "bio"
            case twitterUsername = "twitter_username"
            case publicRepos = "public_repos"
            case publicGists = "public_gists"
            case followers = "followers"
            case following = "following"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case privateGists = "private_gists"
            case totalPrivateRepos = "total_private_repos"
            case ownedPrivateRepos = "owned_private_repos"
            case collaborators = "collaborators"
            case plan = "plan"
        }
    }

    // MARK: - Plan
    public struct Plan: Decodable {
        public let name: String

        enum CodingKeys: String, CodingKey {
            case name = "name"
        }
    }
}

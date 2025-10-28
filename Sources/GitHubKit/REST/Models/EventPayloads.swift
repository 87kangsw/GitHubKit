public enum CreateEventRefType: String, Codable {
    case repository
    case branch
    case tag
    case unknown
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        self = CreateEventRefType(rawValue: value) ?? .unknown
    }
}

extension RestResponse {
    public protocol EventPayload: Decodable {
        var action: EventActionState? { get }
    }

    public struct EventUser: Decodable {
        public let id: Int
        public let login: String
        public let avatarURL: String
        public let htmlURL: String

        enum CodingKeys: String, CodingKey {
            case id, login
            case avatarURL = "avatar_url"
            case htmlURL = "html_url"
        }
    }
    
    public struct CreateEventPayload: EventPayload {
        public let refType: CreateEventRefType
        public let ref: String?
        public let description: String?
        public var action: EventActionState? { return .created }
        
        enum CodingKeys: String, CodingKey {
            case refType = "ref_type"
            case ref
            case description
        }
    }
    
    public struct PullRequestEventPayload: EventPayload {
        public let action: EventActionState?
        public let number: Int
        public let pullRequest: PullRequest
        
        enum CodingKeys: String, CodingKey {
            case action
            case number
            case pullRequest = "pull_request"
        }
        
        public struct PullRequest: Decodable {
            public let number: Int
            public let url: String
            
            enum CodingKeys: String, CodingKey {
                case number
                case url
            }
        }
    }
    
    public struct IssuesEventPayload: EventPayload {
        public let action: EventActionState?
        public let issue: Issue
        
        public struct Issue: Decodable {
            public let title: String
            public let number: Int
            public let state: String
            public let htmlURL: String
            
            enum CodingKeys: String, CodingKey {
                case title
                case number
                case state
                case htmlURL = "html_url"
            }
        }
    }
    
    public struct PushEventPayload: EventPayload {
        public let ref: String
        public var action: EventActionState? { return .created }
        
        public struct Commit: Decodable {
            public let sha: String
            public let message: String
            public let url: String
        }
    }
    
    public struct ForkEventPayload: EventPayload {
        public let forkee: Repository
        public var action: EventActionState? { return .created }
    }
    
    public struct WatchEventPayload: EventPayload {
        public let action: EventActionState?
    }
    
    public struct ReleaseEventPayload: EventPayload {
        public let action: EventActionState?
        public let release: Release

        public struct Release: Decodable {
            public let tagName: String
            public let name: String?
            public let body: String?
            public let htmlURL: String

            enum CodingKeys: String, CodingKey {
                case tagName = "tag_name"
                case name
                case body
                case htmlURL = "html_url"
            }
        }
    }

    public struct IssueCommentEventPayload: EventPayload {
        public let action: EventActionState?
        public let issue: IssuesEventPayload.Issue
        public let comment: Comment

        public struct Comment: Decodable {
            public let id: Int
            public let body: String
            public let htmlURL: String
            public let user: EventUser

            enum CodingKeys: String, CodingKey {
                case id, body, user
                case htmlURL = "html_url"
            }
        }
    }

    public struct PullRequestReviewCommentEventPayload: EventPayload {
        public let action: EventActionState?
        public let pullRequest: PullRequestEventPayload.PullRequest
        public let comment: Comment

        enum CodingKeys: String, CodingKey {
            case action, comment
            case pullRequest = "pull_request"
        }

        public struct Comment: Decodable {
            public let id: Int
            public let body: String
            public let htmlURL: String
            public let user: EventUser

            enum CodingKeys: String, CodingKey {
                case id, body, user
                case htmlURL = "html_url"
            }
        }
    }

    public struct PublicEventPayload: EventPayload {
        public var action: EventActionState? { return .created }
    }

    public struct CommitCommentEventPayload: EventPayload {
        public let action: EventActionState?
        public let comment: Comment

        public struct Comment: Decodable {
            public let id: Int
            public let body: String
            public let commitId: String
            public let htmlURL: String
            public let user: EventUser

            enum CodingKeys: String, CodingKey {
                case id, body, user
                case commitId = "commit_id"
                case htmlURL = "html_url"
            }
        }
    }

    public struct PullRequestReviewEventPayload: EventPayload {
        public let action: EventActionState?
        public let pullRequest: PullRequestEventPayload.PullRequest
        public let review: Review

        enum CodingKeys: String, CodingKey {
            case action, review
            case pullRequest = "pull_request"
        }

        public struct Review: Decodable {
            public let id: Int
            public let body: String?
            public let state: String
            public let htmlURL: String
            public let user: EventUser

            enum CodingKeys: String, CodingKey {
                case id, body, state, user
                case htmlURL = "html_url"
            }
        }
    }

    public struct DeleteEventPayload: EventPayload {
        public let ref: String
        public let refType: String
        public let pusherType: String
        public var action: EventActionState? { return .deleted }

        enum CodingKeys: String, CodingKey {
            case ref
            case refType = "ref_type"
            case pusherType = "pusher_type"
        }
    }
} 

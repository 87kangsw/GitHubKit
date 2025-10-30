import Foundation

extension RestResponse {
    public struct Event: Decodable {
        public let id: String
        public let type: EventType
        public let actor: Actor
        public let repo: Repository
        public let org: Organization?
        public let payload: EventPayload?
        public let createdAt: Date
        public let isPublic: Bool

        enum CodingKeys: String, CodingKey {
            case id, type, actor, repo, org, payload
            case createdAt = "created_at"
            case isPublic = "public"
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            id = try container.decode(String.self, forKey: .id)
            type = try container.decode(EventType.self, forKey: .type)
            actor = try container.decode(Actor.self, forKey: .actor)
            repo = try container.decode(Repository.self, forKey: .repo)
            org = try container.decodeIfPresent(Organization.self, forKey: .org)
            isPublic = try container.decode(Bool.self, forKey: .isPublic)
            
            let dateString = try container.decode(String.self, forKey: .createdAt)
            let formatter = ISO8601DateFormatter()
            createdAt = formatter.date(from: dateString) ?? Date()
            
            // Decode specific payload based on event type
            switch type {
            case .createEvent:
                payload = try container.decode(CreateEventPayload.self, forKey: .payload)
            case .watchEvent:
                payload = try container.decode(WatchEventPayload.self, forKey: .payload)
            case .pullRequestEvent:
                payload = try container.decode(PullRequestEventPayload.self, forKey: .payload)
            case .pushEvent:
                payload = try container.decode(PushEventPayload.self, forKey: .payload)
            case .forkEvent:
                payload = try container.decode(ForkEventPayload.self, forKey: .payload)
            case .issuesEvent:
                payload = try container.decode(IssuesEventPayload.self, forKey: .payload)
            case .releaseEvent:
                payload = try container.decode(ReleaseEventPayload.self, forKey: .payload)
            case .issueCommentEvent:
                payload = try container.decode(IssueCommentEventPayload.self, forKey: .payload)
            case .pullRequestReviewCommentEvent:
                payload = try container.decode(PullRequestReviewCommentEventPayload.self, forKey: .payload)
            case .publicEvent:
                payload = try container.decode(PublicEventPayload.self, forKey: .payload)
            case .commitCommentEvent:
                payload = try container.decode(CommitCommentEventPayload.self, forKey: .payload)
            case .pullRequestReviewEvent:
                payload = try container.decode(PullRequestReviewEventPayload.self, forKey: .payload)
            case .deleteEvent:
                payload = try container.decode(DeleteEventPayload.self, forKey: .payload)
            default:
                payload = nil
            }
        }
        
        public var eventDescription: String {
            switch type {
            case .createEvent:
                guard let payload = payload as? CreateEventPayload else { return "" }
                switch payload.refType {
                case .repository:
                    return "created a repository"
                case .branch:
                    let ref = payload.ref ?? ""
                    return "created a branch '\(ref)'"
                case .tag:
                    let ref = payload.ref ?? ""
                    return "created a tag '\(ref)'"
                case .unknown:
                    return "created"
                }
            case .watchEvent:
                return "starred"
            case .pullRequestEvent:
                guard let payload = payload as? PullRequestEventPayload else { return "" }
                let action = payload.action
                switch action {
                case .opened:
                    return "opened PR #\(payload.number)"
                case .closed:
                    return "closed PR #\(payload.number)"
                case .reopened:
                    return "reopened PR #\(payload.number)"
                case .edited:
                    return "edited PR #\(payload.number)"
                default:
                    let actionText = action?.rawValue ?? "updated"
                    return "\(actionText) PR #\(payload.number)"
                }
            case .pushEvent:
                return "pushed"
            case .forkEvent:
                return "forked from \(repo.name)"
            case .issuesEvent:
                guard let payload = payload as? IssuesEventPayload else { return "" }
                let action = payload.action
                switch action {
                case .opened:
                    return "opened issue #\(payload.issue.number)"
                case .closed:
                    return "closed issue #\(payload.issue.number)"
                case .reopened:
                    return "reopened issue #\(payload.issue.number)"
                case .edited:
                    return "edited issue #\(payload.issue.number)"
                default:
                    let actionText = action?.rawValue ?? "updated"
                    return "\(actionText) issue #\(payload.issue.number)"
                }
            case .issueCommentEvent:
                guard let payload = payload as? IssueCommentEventPayload else { return "" }
                return "commented on issue #\(payload.issue.number)"
            case .pullRequestReviewCommentEvent:
                guard let payload = payload as? PullRequestReviewCommentEventPayload else { return "" }
                return "commented on PR #\(payload.pullRequest.number)"
            case .publicEvent:
                return "made public"
            case .commitCommentEvent:
                guard let payload = payload as? CommitCommentEventPayload else { return "" }
                let shortSha = String(payload.comment.commitId.prefix(7))
                return "commented on \(shortSha)"
            case .pullRequestReviewEvent:
                guard let payload = payload as? PullRequestReviewEventPayload else { return "" }
                return "reviewed PR #\(payload.pullRequest.number)"
            case .deleteEvent:
                guard let payload = payload as? DeleteEventPayload else { return "" }
                return "deleted \(payload.refType) '\(payload.ref)'"
            case .releaseEvent:
                guard let payload = payload as? ReleaseEventPayload else { return "" }
                let action = payload.action
                switch action {
                case .published:
                    return "published a release"
                case .created:
                    return "created a release"
                case .edited:
                    return "edited a release"
                case .deleted:
                    return "deleted a release"
                default:
                    let actionText = action?.rawValue ?? "updated"
                    return "\(actionText) a release"
                }
            default:
                return type.rawValue
            }
        }
    }
    
    public struct Actor: Decodable {
        public let id: Int
        public let login: String
        public let displayLogin: String?
        public let avatarURL: String
        public let gravatarID: String?
        public let url: String

        enum CodingKeys: String, CodingKey {
            case id, login, url
            case displayLogin = "display_login"
            case avatarURL = "avatar_url"
            case gravatarID = "gravatar_id"
        }
    }
    
    public struct Repository: Decodable {
        public let id: Int
        public let name: String
        public let url: String
    }

    public struct Organization: Decodable {
        public let id: Int
        public let login: String
        public let avatarURL: String
        public let gravatarID: String?
        public let url: String

        enum CodingKeys: String, CodingKey {
            case id, login, url
            case avatarURL = "avatar_url"
            case gravatarID = "gravatar_id"
        }
    }
} 

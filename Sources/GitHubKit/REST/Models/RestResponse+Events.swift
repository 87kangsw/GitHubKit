import Foundation

extension RestResponse {
    public struct Event: Decodable {
        public let id: String
        public let type: EventType
        public let actor: Actor
        public let repo: Repository
        public let payload: EventPayload?
        public let createdAt: Date
        public let isPublic: Bool
        
        enum CodingKeys: String, CodingKey {
            case id, type, actor, repo, payload
            case createdAt = "created_at"
            case isPublic = "public"
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            id = try container.decode(String.self, forKey: .id)
            type = try container.decode(EventType.self, forKey: .type)
            actor = try container.decode(Actor.self, forKey: .actor)
            repo = try container.decode(Repository.self, forKey: .repo)
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
                    return "Created repository"
                case .branch:
                    return "Created branch: \(payload.ref ?? "")"
                case .tag:
                    return "Created tag: \(payload.ref ?? "")"
                case .unknown:
                    return "Created unknown"
                }
            case .watchEvent:
                return "Starred repository"
            case .pullRequestEvent:
                guard let payload = payload as? PullRequestEventPayload else { return "" }
                return "Pull request #\(payload.number) \(payload.action?.rawValue ?? "")"
            case .pushEvent:
                guard let payload = payload as? PushEventPayload else { return "" }
                let branch = payload.ref.split(separator: "/").last ?? ""
                return "Pushed to \(branch)"
            case .forkEvent:
                return "Forked repository"
            case .issuesEvent:
                guard let payload = payload as? IssuesEventPayload else { return "" }
                return "Issue #\(payload.issue.number) \(payload.action?.rawValue ?? "")"
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
        
        enum CodingKeys: String, CodingKey {
            case id, login
            case displayLogin = "display_login"
            case avatarURL = "avatar_url"
        }
    }
    
    public struct Repository: Decodable {
        public let id: Int
        public let name: String
        public let url: String
    }
} 

public enum EventType: String, Codable {
    case createEvent = "CreateEvent"
    case watchEvent = "WatchEvent"
    case pullRequestEvent = "PullRequestEvent"
    case pushEvent = "PushEvent"
    case forkEvent = "ForkEvent"
    case issuesEvent = "IssuesEvent"
    case issueCommentEvent = "IssueCommentEvent"
    case releaseEvent = "ReleaseEvent"
    case pullRequestReviewCommentEvent = "PullRequestReviewCommentEvent"
    case publicEvent = "PublicEvent"
    case commitCommentEvent = "CommitCommentEvent"
    case pullRequestReviewEvent = "PullRequestReviewEvent"
    case deleteEvent = "DeleteEvent"
    case unknown
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        self = EventType(rawValue: value) ?? .unknown
    }
}

public enum EventActionState: String, Codable {
    case opened
    case closed
    case created
    case edited
    case deleted
    case unknown
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        self = EventActionState(rawValue: value) ?? .unknown
    }
} 
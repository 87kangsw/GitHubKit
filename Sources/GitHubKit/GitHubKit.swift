import Foundation

public class GitHubKit {
    public let restClient: RestClient
    public let graphqlClient: GraphQLClient
    public let crawlerClient: CrawlerClient

    public init(config: GitHubKitConfiguration, session: URLSession = .shared) {
        self.restClient = RestClient(config: config, session: session)
        self.graphqlClient = GraphQLClient(config: config, session: session)
        self.crawlerClient = CrawlerClient(session: session)
    }
}



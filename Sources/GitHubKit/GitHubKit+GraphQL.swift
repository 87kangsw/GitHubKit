import Foundation

// MARK: - For GraphQL API

extension GitHubKit {
    
    public func contributions(
        userName: String,
        from: String? = nil,
        to: String? = nil
    ) async throws -> GraphQLResponse.UserContribution {
        let operation = GraphQLOperation.userContributions(
            username: userName,
            from: from,
            to: to
        )
        
        let result: GraphQLResponse.UserContributions = try await graphqlClient.performOperation(operation)
        return GraphQLResponse.UserContribution(from: result)
    }
}

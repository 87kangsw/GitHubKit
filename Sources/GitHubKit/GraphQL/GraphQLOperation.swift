import Foundation

struct GraphQLOperation: Encodable {
    var operationString: String
    var variables: [String: AnyEncodable]

    enum CodingKeys: String, CodingKey {
        case variables
        case query
    }

    init(_ operationString: String, variables: [String: Any?] = [:]) {
        self.operationString = operationString
        self.variables = variables.mapValues { AnyEncodable(value: $0) }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(operationString, forKey: .query)
        try container.encodeIfPresent(variables, forKey: .variables)
    }

    func getURLRequest() throws -> URLRequest {
        var request = URLRequest(url: Constants.URLs.GraphQL_URL)

        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(self)

        return request
    }
}

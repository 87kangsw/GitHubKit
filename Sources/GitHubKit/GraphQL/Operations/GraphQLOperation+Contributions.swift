import Foundation

extension GraphQLOperation {
    
    static func userContributions(
        username: String,
        from: String? = nil,
        to: String? = nil
    ) -> Self {
        
        let fromDate: String? = from.flatMap(DateUtils.convertToISO8601(from:))
        let toDate: String? = to.flatMap(DateUtils.convertToISO8601(from:))

        let variables: [String: Any?] = [
            "username": username,
            "from": fromDate,
            "to": toDate
        ]

        return GraphQLOperation(
            """
            query UserContributions($username: String!, $from: DateTime, $to: DateTime) {
              user(login: $username) {
                contributionsCollection(from: $from, to: $to) {
                  contributionCalendar {
                    totalContributions
                    weeks {
                      contributionDays {
                        contributionCount
                        date
                        weekday
                        color
                      }
                    }
                  }
                }
              }
            }
            """,
            variables: variables.mapValues { $0 != nil ? String(describing: $0!) : nil }
        )
    }
}

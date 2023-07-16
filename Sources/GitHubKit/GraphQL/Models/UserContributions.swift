import Foundation

// MARK: - Internal

extension GraphQLResponse {
    // MARK: - UserContributions
    struct UserContributions: Decodable {
        public let user: User
    }

    // MARK: - User
    struct User: Decodable {
        let contributionsCollection: ContributionsCollection
    }

    // MARK: - ContributionsCollection
    struct ContributionsCollection: Decodable {
        let contributionCalendar: ContributionCalendar
    }

    // MARK: - ContributionCalendar
    struct ContributionCalendar: Decodable {
        let totalContributions: Int
        let weeks: [Week]
    }

    // MARK: - Week
    struct Week: Decodable {
        let contributionDays: [ContributionDay]
    }

    // MARK: - ContributionDay
    struct ContributionDay: Decodable {
        let contributionCount: Int
        let date: String
        let weekday: Int
        let color: String
    }
}

// MARK: - Public

extension GraphQLResponse {
    public struct UserContribution {
        public let totalContributions: Int
        public let contributions: [Contribution]
        
        init(from userContributions: UserContributions) {
            self.totalContributions = userContributions.user.contributionsCollection.contributionCalendar.totalContributions
            
            var contributions: [Contribution] = []
            for week in userContributions.user.contributionsCollection.contributionCalendar.weeks {
                for contributionDay in week.contributionDays {
                    let contribution = Contribution(contributionCount: contributionDay.contributionCount,
                                                    date: contributionDay.date,
                                                    weekday: contributionDay.weekday,
                                                    color: contributionDay.color
                    )
                    contributions.append(contribution)
                }
            }
            self.contributions = contributions
        }
    }
    
    public struct Contribution {
        public let contributionCount: Int
        public let date: String
        public let weekday: Int
        public let color: String
    }
}

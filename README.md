# GitHubKit
A Comprehensive Swift API Client for GitHub REST, GraphQL & Web Scraping

[![Swift](https://img.shields.io/badge/Swift-5.8+-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS%2014%2B%20%7C%20macOS%2012%2B-lightgrey.svg)](https://github.com/87kangsw/GitHubKit)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

GitHubKit is a powerful, all-in-one Swift library that provides seamless access to GitHub's REST API, GraphQL API, and web scraping capabilities for trending data.

## 🚀 Features

### ✅ REST API
- [x] **User Management**: Get user info, followers, following
- [x] **Activities**: User events, received events
- [x] **Search**: Users, repositories with advanced filtering
- [x] **Repositories**: Contributors, repository details
- [x] **Pagination**: Built-in support for paginated results

### ✅ GraphQL API
- [x] **Contributions**: User contribution graphs and statistics
- [x] **Type-safe**: Strongly typed GraphQL responses
- [x] **Flexible Queries**: Custom date ranges and filtering

### ✅ Web Scraping (Trending)
- [x] **Trending Repositories**: Daily, weekly, monthly trends
- [x] **Trending Developers**: Popular developers by language/period
- [x] **Language Filtering**: Filter by programming language
- [x] **Rich Data**: Stars, forks, contributors, descriptions

## 📦 Installation

### Swift Package Manager

Add GitHubKit to your project using Xcode or by adding it to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/87kangsw/GitHubKit", from: "2.0.0")
]
```

## 🛠 Usage

### Initialization

```swift
import GitHubKit

// Initialize GitHubKit with your GitHub token
let githubKit = GitHubKit(config: GitHubKitConfiguration(token: "your_github_token"))
```

### REST API Examples

#### User Information
```swift
// Get current authenticated user
let currentUser = try await githubKit.userInfo()

// Get specific user
let user = try await githubKit.userInfo(username: "octocat")
print("User: \(user.name) (@\(user.login))")
```

#### User Activities
```swift
// Get user's public events
let events = try await githubKit.userEvents(username: "octocat", page: 1)

// Get events received by user
let receivedEvents = try await githubKit.userReceivedEvents(username: "octocat", page: 1)
```

#### Follow Relationships
```swift
// Get user's followers
let followers = try await githubKit.userFollowers(username: "octocat", page: 1)

// Get users that the user is following
let following = try await githubKit.userFollowing(username: "octocat", page: 1)
```

#### Search
```swift
// Search users
let userSearchResult = try await githubKit.searchUsers(query: "john", page: 1)
print("Found \(userSearchResult.totalCount) users")

// Search repositories with language filter
let repoSearchResult = try await githubKit.searchRepositories(
    query: "machine learning",
    page: 1,
    language: "Python"
)
```

#### Repository Information
```swift
// Get repository contributors
let contributors = try await githubKit.contributors(owner: "87kangsw", repo: "GitHubKit")
for contributor in contributors {
    print("\(contributor.login): \(contributor.contributions) contributions")
}
```

### GraphQL API Examples

#### User Contributions
```swift
// Get user contributions for the current year
let contributions = try await githubKit.contributions(userName: "octocat")
print("Total contributions: \(contributions.totalContributions)")

// Get contributions for a specific date range
let contributions = try await githubKit.contributions(
    userName: "octocat",
    from: "2024-01-01T00:00:00Z",
    to: "2024-12-31T23:59:59Z"
)
```

### Web Scraping (Trending) Examples

#### Trending Repositories
```swift
// Get daily trending repositories
let trendingRepos = try await githubKit.trendingRepositories()

// Get weekly trending Swift repositories
let swiftRepos = try await githubKit.trendingRepositories(
    language: "Swift",
    period: .weekly
)

for repo in swiftRepos {
    print("\(repo.author)/\(repo.name): \(repo.stars) ⭐ (+\(repo.currentPeriodStars) this week)")
}
```

#### Trending Developers
```swift
// Get daily trending developers
let trendingDevs = try await githubKit.trendingDevelopers()

// Get monthly trending JavaScript developers
let jsDevs = try await githubKit.trendingDevelopers(
    language: "JavaScript",
    period: .monthly
)

for dev in jsDevs {
    print("\(dev.name ?? dev.userName) - \(dev.repo?.name ?? "No featured repo")")
}
```

## 🔧 Advanced Configuration

### Custom URLSession
```swift
let customSession = URLSession(configuration: .default)
let githubKit = GitHubKit(config: GitHubKitConfiguration(token: "token"), session: customSession)
```

### Error Handling
```swift
do {
    let user = try await githubKit.userInfo(username: "nonexistent-user")
} catch {
    switch error {
    case let urlError as URLError:
        print("Network error: \(urlError.localizedDescription)")
    default:
        print("Unknown error: \(error)")
    }
}
```

## 📊 API Coverage

| Category | REST API | GraphQL | Web Scraping |
|----------|----------|---------|--------------|
| Users | ✅ | ✅ | ❌ |
| Repositories | ✅ | ❌ | ✅ |
| Activities/Events | ✅ | ❌ | ❌ |
| Search | ✅ | ❌ | ❌ |
| Trending | ❌ | ❌ | ✅ |
| Contributions | ❌ | ✅ | ❌ |

## 🧪 Testing

Run the test suite:

```bash
swift test
```

For integration tests with real API calls, set the `GITHUB_TOKEN` environment variable:

```bash
export GITHUB_TOKEN=your_github_token
swift test
```

## 📋 Requirements

- iOS 14.0+ / macOS 12.0+
- Swift 5.8+
- Xcode 14.0+

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- GitHub for providing comprehensive APIs
- [Kanna](https://github.com/tid-kijyun/Kanna) for HTML parsing capabilities
- The Swift community for inspiration and support
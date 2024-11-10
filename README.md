> 🚧 Please be aware that this library is currently in progress and may undergo significant changes. Exercise caution while using it.

# GitHubKit
A Swift API Client for GitHub REST &amp; GraphQL

## Features

### REST
- [x] User
- [x] Activities

### GraphQL
- [x] Contributions

## Usage

This library provides simple access to various GitHub APIs. Here's an example of how you can use it to fetch user contributions:

```swift
import GithubKit

// Initialize GithubKit with your GitHub token.
let githubKit = GitHubKit(config: GitHubKitConfiguration(token: "{your_github_token}"))

do {
    // Fetch contributions for a specific user.
    let response = try await githubKit.contributions(userName: "username")

    // Use response here.
    print(response)

} catch {
    print("Failed to fetch contributions: \(error)")
}
```
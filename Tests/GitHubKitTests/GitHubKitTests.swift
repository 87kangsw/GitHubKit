import XCTest
@testable import GitHubKit

final class GitHubKitTests: XCTestCase {
    
    let accessToken: String = "your_access_token"
    
    // MARK: - GraphQL
    
    func test_contributions_default() async throws {
        
        let githubKit = GitHubKit(config: .init(token: accessToken))
        let response = try await githubKit.contributions(
            userName: "87kangsw"
        )
        // print(response)
        
        XCTAssertNotNil(response)
    }
    
    func test_contributions_period() async throws {
        
        let githubKit = GitHubKit(config: .init(token: accessToken))
        let response = try await githubKit.contributions(
            userName: "87kangsw",
            from: "2022-12-01",
            to: "2022-12-31"
        )
        // print(response)
        
        XCTAssertNotNil(response)
    }
    
    // MARK: - REST
    
    func test_userInfo() async throws {
        let githubKit = GitHubKit(config: .init(token: accessToken))
        
        let response = try await githubKit.userInfo()
        // print(response)
        
        XCTAssertNotNil(response)
    }
    
    // MARK: - Events Tests
    
    func test_userEvents() async throws {
        let githubKit = GitHubKit(config: .init(token: accessToken))
        
        let events = try await githubKit.userEvents(username: "87kangsw")
        print("::: events: \(events)")
        
        // 디버깅을 위한 출력
        print("First event type:", events.first?.type ?? "none")
        if let firstEvent = events.first {
            print("Payload type:", String(describing: type(of: firstEvent.payload)))
        }
        
        XCTAssertFalse(events.isEmpty, "Events should not be empty")
        
        // Test first event structure
        let firstEvent = events.first
        XCTAssertNotNil(firstEvent)
        XCTAssertFalse(firstEvent?.id.isEmpty ?? true)
        XCTAssertNotNil(firstEvent?.type)
        XCTAssertNotNil(firstEvent?.actor)
        XCTAssertNotNil(firstEvent?.repo)
        
        // Print event descriptions for manual verification
        // print("First 5 events:")
        // events.prefix(5).forEach { event in
        //     print("- \(event.eventDescription)")
        // }
    }
    
    func test_specificEventTypes() async throws {
        let githubKit = GitHubKit(config: .init(token: accessToken))
        
        let events = try await githubKit.userEvents(username: "87kangsw")
        
        // Test different event types and their payloads
        for event in events {
            switch event.type {
            case .pushEvent:
                if let payload = event.payload as? RestResponse.PushEventPayload {
                    XCTAssertFalse(payload.ref.isEmpty)
                }
                
            case .pullRequestEvent:
                if let payload = event.payload as? RestResponse.PullRequestEventPayload {
                    XCTAssertNotNil(payload.action)
                    XCTAssertNotNil(payload.pullRequest)
                    XCTAssertGreaterThan(payload.number, 0)
                }
                
            case .createEvent:
                if let payload = event.payload as? RestResponse.CreateEventPayload {
                    XCTAssertNotNil(payload.refType)
                }
                
            default:
                break
            }
            
            // Test event description
            XCTAssertFalse(event.eventDescription.isEmpty)
        }
    }
    
    func test_eventDateParsing() async throws {
        let githubKit = GitHubKit(config: .init(token: accessToken))
        
        let events = try await githubKit.userEvents(username: "87kangsw")
        guard let firstEvent = events.first else {
            XCTFail("No events found")
            return
        }
        
        // Test that the date is parsed correctly and is in the past
        XCTAssertLessThan(firstEvent.createdAt, Date())
    }
    /*
    func test_userEventsPaging() async throws {
        let githubKit = GitHubKit(config: .init(token: accessToken))
        
        // 첫 페이지
        let firstPageEvents = try await githubKit.userEvents(username: "87kangsw", page: 1)
        XCTAssertFalse(firstPageEvents.isEmpty, "First page should not be empty")
        
        // 두 번째 페이지
        let secondPageEvents = try await githubKit.userEvents(username: "87kangsw", page: 2)
        XCTAssertFalse(secondPageEvents.isEmpty, "Second page should not be empty")
        
        // 페이지가 다른지 확인
        if !firstPageEvents.isEmpty && !secondPageEvents.isEmpty {
            XCTAssertNotEqual(
                firstPageEvents.first?.id,
                secondPageEvents.first?.id,
                "Events from different pages should be different"
            )
        }
    }
    */
    func test_userReceivedEvents() async throws {
        let githubKit = GitHubKit(config: .init(token: accessToken))
        
        let events = try await githubKit.userReceivedEvents(username: "87kangsw")
        XCTAssertFalse(events.isEmpty, "Received events should not be empty")
        
        // Test first event structure
        let firstEvent = events.first
        XCTAssertNotNil(firstEvent)
        XCTAssertFalse(firstEvent?.id.isEmpty ?? true)
        XCTAssertNotNil(firstEvent?.type)
        XCTAssertNotNil(firstEvent?.actor)
        XCTAssertNotNil(firstEvent?.repo)
    }
    
    func test_userReceivedEventsPaging() async throws {
        let githubKit = GitHubKit(config: .init(token: accessToken))
        
        // 첫 페이지
        let firstPageEvents = try await githubKit.userReceivedEvents(username: "87kangsw", page: 1)
        XCTAssertFalse(firstPageEvents.isEmpty, "First page should not be empty")
        
        // 두 번째 페이지
        let secondPageEvents = try await githubKit.userReceivedEvents(username: "87kangsw", page: 2)
        XCTAssertFalse(secondPageEvents.isEmpty, "Second page should not be empty")
        
        // 페이지가 다른지 확인
        if !firstPageEvents.isEmpty && !secondPageEvents.isEmpty {
            XCTAssertNotEqual(
                firstPageEvents.first?.id,
                secondPageEvents.first?.id,
                "Events from different pages should be different"
            )
        }
    }
}

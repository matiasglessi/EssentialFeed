//
//  EssentialFeedAPIEndToEndTests.swift
//  EssentialFeedAPIEndToEndTests
//
//  Created by Matias Glessi on 05/02/2023.
//

import XCTest
import EssentialFeed

class EssentialFeedAPIEndToEndTests: XCTestCase {
    
    func test_endToEndTestServerGETFeedResult_matchesFixedTestAccountData() {
        let testServerURL = URL(string: "https://essentialdeveloper.com/feed-case-study/test-api/feed")!
        let client = URLSessionHTTPClient()
        let loader = RemoteFeedLoader(url: testServerURL, client: client)
        
        let expectation = expectation(description: "Wait for completion")
        var recievedResult: LoadFeedResult?
        loader.load { result in
            recievedResult = result
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        
        switch recievedResult {
        case let .success(recievedItems):
            XCTAssertEqual(recievedItems.count, 8, "Expected 8 items in the test account feed.")
            XCTAssertEqual(recievedItems[0], expectedItem(at: 0))
            XCTAssertEqual(recievedItems[1], expectedItem(at: 1))
            XCTAssertEqual(recievedItems[2], expectedItem(at: 2))
            XCTAssertEqual(recievedItems[3], expectedItem(at: 3))
            XCTAssertEqual(recievedItems[4], expectedItem(at: 4))
            XCTAssertEqual(recievedItems[5], expectedItem(at: 5))
            XCTAssertEqual(recievedItems[6], expectedItem(at: 6))
            XCTAssertEqual(recievedItems[7], expectedItem(at: 7))
            
        case let .failure(error):
            XCTFail("Expectedm successful feed result, got \(error) instead.")
            
        default:
            XCTFail("Expectedm successful feed result, got no result instead.")
        }
    }
    
    // MARK: - Helpers
    
    private func expectedItem(at index: Int) -> FeedItem {
        FeedItem(id: id(at: index),
                 description: description(at: index),
                 location: location(at: index),
                 imageURL: imageURL(at: index))
    }
    
    private func id(at index: Int) -> UUID {
        return UUID(uuidString: [
            "73A7F70C-75DA-4C2E-B5A3-EED40DC53AA6",
            "BA298A85-6275-48D3-8315-9C8F7C1CD109",
            "5A0D45B3-8E26-4385-8C5D-213E160A5E3C",
            "FF0ECFE2-2879-403F-8DBE-A83B4010B340",
            "DC97EF5E-2CC9-4905-A8AD-3C351C311001",
            "557D87F1-25D3-4D77-82E9-364B2ED9CB30",
            "A83284EF-C2DF-415D-AB73-2A9B8B04950B",
            "F79BD7F8-063F-46E2-8147-A67635C3BB01"
        ][index])!
    }
    
    private func description(at index: Int) -> String? {
        return [
            "Description 1",
            nil,
            "Description 3",
            nil,
            "Description 5",
            "Description 6",
            "Description 7",
            "Description 8"
        ][index]
    }
    
    private func location(at index: Int) -> String? {
        return [
            "Location 1",
            "Location 2",
            nil,
            nil,
            "Location 5",
            "Location 6",
            "Location 7",
            "Location 8"
        ][index]
    }
    
    private func imageURL(at index: Int) -> URL {
        return URL(string: "https://url-\(index+1).com")!
    }
}
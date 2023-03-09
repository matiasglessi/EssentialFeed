//
//  LoadFeedFromCacheUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Matias Glessi on 09/03/2023.
//

import XCTest
import EssentialFeed

final class LoadFeedFromCacheUseCaseTests: XCTestCase {

    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()

        XCTAssertEqual(store.receivedMessages, [])
    }

    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, store)
    }
    
    private class FeedStoreSpy: FeedStore {
        enum ReceivedMessages: Equatable {
            case deleteCacheFeed
            case insert([LocalFeedImage], Date)
        }
        
        private(set) var receivedMessages = [ReceivedMessages]()
        
        private var deletionCompletion = [DeletionCompletion]()
        private var insertionCompletion = [InsertionCompletion]()

        func deleteCachedFeed(completion: @escaping DeletionCompletion) {
            deletionCompletion.append(completion)
            receivedMessages.append(.deleteCacheFeed)
        }
        
        func completeDeletion(with error: Error, at index: Int = 0) {
            deletionCompletion[index](error)
        }
        
        func completeDeletionSuccesfully(at index: Int = 0) {
            deletionCompletion[index](nil)
        }
        
        func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
            insertionCompletion.append(completion)
            receivedMessages.append(.insert(feed, timestamp))
        }
        
        func completeInsertion(with error: Error, at index: Int = 0) {
            insertionCompletion[index](error)
        }
        
        func completeInsertionSuccesfully(at index: Int = 0) {
            insertionCompletion[index](nil)
        }
    }
}

//
//  XCTestCase+FailableDeleteFeedStoreSpecs.swift
//  EssentialFeedTests
//
//  Created by Matias Glessi on 17/05/2023.
//

import XCTest
import EssentialFeed

extension FailableDeleteSpecs where Self: XCTestCase {
    func assertThatDeletieDeliversErrorOnInsertionError(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        let deletionError = delete(from: sut)

        XCTAssertNotNil(deletionError, "Expected cache deletion to fail with an error", file: file, line: line)
    }
    
    func assertThatDeleteHasNoSideEffectsOnDeletionError(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        delete(from: sut)
        
        expect(sut, toRetrieve: .empty, file: file, line: line)
    }
}

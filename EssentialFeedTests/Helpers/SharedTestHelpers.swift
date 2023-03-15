//
//  SharedTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Matias Glessi on 15/03/2023.
//

import Foundation

func anyNSError() -> NSError {
    NSError(domain: "any error", code: 1)
}

func anyURL() -> URL {
    URL(string: "http://a-url.com")!
}

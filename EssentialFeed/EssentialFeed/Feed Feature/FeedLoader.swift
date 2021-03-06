//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Matias Glessi on 20/10/2020.
//

import Foundation

public enum LoadFeedResult {
    case success([FeedItem])
    case failure(Error)
}

public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}

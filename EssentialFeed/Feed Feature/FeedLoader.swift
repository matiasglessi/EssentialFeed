//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Matias Glessi on 05/01/2023.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case failure(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}

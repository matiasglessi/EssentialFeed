//
//  LoadFeedResult.swift
//  EssentialFeed
//
//  Created by Matias Glessi on 20/10/2020.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case error(Error)
}

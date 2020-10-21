//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Matias Glessi on 20/10/2020.
//

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}

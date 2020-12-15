//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Matias Glessi on 20/10/2020.
//

import Foundation

public struct FeedItem: Equatable {
    let id: UUID
    let description: String?
    let location: String?
    let imageURL: URL
}

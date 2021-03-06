//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Matias Glessi on 20/10/2020.
//

import Foundation

public struct FeedItem: Equatable {
    public let id: UUID
    public let description: String?
    public let location: String?
    public let imageURL: URL
    
    public init(id: UUID,
                description: String?,
                location: String?,
                imageURL: URL){
        self.id = id
        self.description = description
        self.location = location
        self.imageURL = imageURL
    }
}

//
//  Model.swift
//  NewsTest
//
//  Created by Gary Hanson on 3/4/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import Foundation



enum HeadlineCategory: String {
    case top = "Top Headlines"
    case tech = "Tech"
    case entertainment = "Entertainment"
    case sports = "Sports"
    case science = "Science"
    case health = "Health"
    case business = "Business"
}

struct StorySource: Decodable {
    let id: String?
    let name: String?
}

struct NewsStory: Decodable {
    let author: String?
    let title: String?
    let url: String?
    let description: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
    let source: StorySource
}

struct NewsStories : Decodable {
    let stories: [NewsStory]?

    enum CodingKeys: String, CodingKey {
        case articles
    }
}

extension NewsStories  {

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        stories = try? values.decode([NewsStory].self, forKey: .articles)
    }
}

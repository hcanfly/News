//
//  Model.swift
//  NewsTest
//
//  Created by Gary Hanson on 3/4/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import Foundation

let newsapiAPIKey = "<your newapi API key goes here>"     // "<your newapi API key goes here>"

let topHeadlinesRequestURLString = "http://newsapi.org/v2/top-headlines?country=us&apiKey=\(newsapiAPIKey)"
let techHeadlinesRequestURLString = "http://newsapi.org/v2/top-headlines?category=technology&country=us&apiKey=\(newsapiAPIKey)"
let entertainmentHeadlinesRequestURLString = "http://newsapi.org/v2/top-headlines?category=entertainment&country=us&apiKey=\(newsapiAPIKey)"
let sportsHeadlinesRequestURLString = "http://newsapi.org/v2/top-headlines?category=sports&country=us&apiKey=\(newsapiAPIKey)"
let scienceHeadlinesRequestURLString = "http://newsapi.org/v2/top-headlines?category=science&country=us&apiKey=\(newsapiAPIKey)"
let healthHeadlinesRequestURLString = "http://newsapi.org/v2/top-headlines?category=health&country=us&apiKey=\(newsapiAPIKey)"
let businessHeadlinesRequestURLString = "http://newsapi.org/v2/top-headlines?category=business&country=us&apiKey=\(newsapiAPIKey)"

// sources: associated-press, bbc-news, Bloomberg, politico, reuters, the-hill, the-wall-street-journal, wired
// tech sources: ars-technica, engadget, new-scientist, recode, techcrunch
// sports sources: bleacher-report, espn

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

func headlineURLString(forCategory category: HeadlineCategory) -> String {
    var urlString = ""

    switch category {
    case .top:
        urlString = topHeadlinesRequestURLString
    case .tech:
        urlString = techHeadlinesRequestURLString
    case .entertainment:
        urlString = entertainmentHeadlinesRequestURLString
    case .sports:
        urlString = sportsHeadlinesRequestURLString
    case .science:
        urlString = scienceHeadlinesRequestURLString
    case .health:
        urlString = healthHeadlinesRequestURLString
    case .business:
        urlString = businessHeadlinesRequestURLString
   }

    return urlString
}

func fetchNetworkData<T: Decodable>(category: HeadlineCategory, myType: T.Type, completion: @escaping (T) -> Void ) {
    guard let url = URL(string: headlineURLString(forCategory: category)) else {
        print("Invalid URL string. Did you enter your newsapi api key in Model.swift?")
        return
      }

    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        if let data = data {
            let jsonDecoder = JSONDecoder()
            if let theData = try? jsonDecoder.decode(T.self, from: data) {
                DispatchQueue.main.async() {
                    completion(theData)
                }
            }
        }
    }

    task.resume()
}

//
//  Network.swift
//  NewsTest
//
//  Created by Gary on 4/5/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import Foundation

let newsapiAPIKey = "65bbe17046734447a60a328d439aa0ac"     // "<your newsapi API key goes here>"

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



func headlineURL(forCategory category: HeadlineCategory) -> URL? {
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

    return URL(string: urlString)
}

func fetchNetworkData<T: Decodable>(category: HeadlineCategory, myType: T.Type, completion: @escaping (T) -> Void ) {
    guard let url = headlineURL(forCategory: category) else {
        print("Invalid URL. Did you enter your newsapi api key in Model.swift?")
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

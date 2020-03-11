//
//  ImageLoader.swift
//  NewsTest
//
//  Created by Gary on 3/6/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import UIKit

// imageView class that uses simple caching. caching is great for something like a tableview
// where images should be small and can be re-used a lot
// real world version would need better caching
final class AsyncCachedImageView: UIImageView {
    //static let placeHolderImage = UIImage(named: "Loading")   // not using placeholder image
    static var cachedImages = [String: UIImage]()

    init(frame: CGRect, urlString: String?) {
        super.init(frame: frame)

        self.frame = frame
        self.bounds = frame
        self.contentMode = .scaleAspectFit

        // self.image = AsyncImageView.placeHolderImage
        if let urlString = urlString {
            downloadImage(urlString: urlString)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func downloadImage(urlString: String) {

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        if let image = AsyncCachedImageView.cachedImages[urlString] {
            //print("using cached image")
            DispatchQueue.main.async {
                self.image = image
            }
            return
        }

        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { [weak self] data, _, _ in
            if let data = data, let self = self {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.image = image
                        AsyncCachedImageView.cachedImages[urlString] = image
                    }
                }
                return
            }
        }.resume()

    }

}


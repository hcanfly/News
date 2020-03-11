//
//  StoryTableViewCell.swift
//  NewsTest
//
//  Created by Gary on 3/6/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import UIKit


final class StoryTableViewCell: UITableViewCell {
    static let reuseIdentifier = "HeadlineStoryCell"

    var headlineText: String? {
           didSet {
                self.headlineLabel.text = headlineText
                self.setNeedsLayout()
           }
       }

    var headlineLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont(name:"HelveticaNeue", size: 14.0)
        return label
    }()

    var cellImageView: AsyncCachedImageView = {
        var imageView = AsyncCachedImageView(frame: CGRect.zero, urlString: nil)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init( style: style, reuseIdentifier: reuseIdentifier)

        self.clipsToBounds = true
        self.backgroundColor = .systemGray
        self.addSubview(self.cellImageView)
        self.addSubview(self.headlineLabel)

        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
        cellImageView.leftAnchor.constraint(equalTo: self.leftAnchor),
        cellImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
        cellImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 4),
        cellImageView.widthAnchor.constraint(equalToConstant: 160),

        headlineLabel.leftAnchor.constraint(equalTo: self.cellImageView.rightAnchor, constant: 6),
        headlineLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 2),
        headlineLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 4),
        headlineLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 4),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


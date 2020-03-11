//
//  ViewController.swift
//  NewsTest
//
//  Created by Gary Hanson on 3/4/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import UIKit



final class ViewController: UIViewController {
    private var tableView = UITableView()
    private var headlines = [NewsStory]()
    private var currentCategory = HeadlineCategory.top
    let newsCategories = ["Top Headlines", "Tech", "Science", "Sports", "Entertainment", "Health"]

    var titleButton: UIButton?
    var titleLabel: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .black

        self.tableView.register(StoryTableViewCell.self, forCellReuseIdentifier: StoryTableViewCell.reuseIdentifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)

        setupConstraints()

        self.setHeadlineCategory()
    }

    private func setupConstraints() {
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.tableView.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}

extension ViewController {

    // set title for category and download headlines for the category
    fileprivate func setHeadlineCategory() {
        buildTitle(self.currentCategory.rawValue, enabled: true)    // set title and build drop-down menu

        fetchNetworkData(category: self.currentCategory, myType: NewsStories.self) { [weak self] topStories in
            if let self = self {
                if topStories.stories != nil {
                    self.headlines = topStories.stories!
                    self.tableView.reloadData()
                    self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                }
            }
        }
    }

    // called from drop-down after selecting a headline category
    func setCategory(to category: String) {
        guard let headlineCategory = HeadlineCategory(rawValue: category) else {
            return
        }

        if self.currentCategory != headlineCategory {
            self.currentCategory = headlineCategory
            self.title = self.currentCategory.rawValue
            self.setHeadlineCategory()
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.headlines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StoryTableViewCell.reuseIdentifier, for: indexPath) as? StoryTableViewCell else {
            fatalError("Failed to dequeue a StoryTableViewCell.")
        }

        cell.headlineText = headlines[indexPath.row].title

        if let urlString = headlines[indexPath.row].urlToImage, let url = URL(string: urlString) {
            //cell.cellImageView.loadImage(at: url)
            cell.cellImageView.downloadImage(urlString: urlString)
            cell.clipsToBounds = true
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        88
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let urlString = headlines[indexPath.row].url {
            let webVC = WebViewController.instantiate()
            webVC.urlString = urlString

            self.navigationController?.delegate = self
            self.navigationController?.pushViewController(webVC, animated: false)
        }
    }
}

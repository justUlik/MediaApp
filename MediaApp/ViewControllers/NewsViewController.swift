//
//  NewsViewController.swift
//  MediaApp
//
//  Created by Ulyana Eskova on 23.12.2024.
//

import UIKit

final class NewsViewController: UIViewController {
    // MARK: - Variables
    private let tableView = UITableView()
    private var articles: [ArticleModel] = []
    private let articleManager = ArticleManager()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureArticles()
    }

    // MARK: - Confgures
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.pin(to: view)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    private func configureArticles() {
        articleManager.delegate = self
        articleManager.fetchArticles()
    }
}

// MARK: - Extensions
extension NewsViewController: ArticleManagerDelegate {
    func didUpdateArticles(_ articles: [ArticleModel]) {
        self.articles = articles
        tableView.reloadData()
    }
    func didFetchArticles(_ articles: [ArticleModel]) {
        self.articles = articles
        tableView.reloadData()
    }
    
    func didFailWithError(_ error: Error) {
        print("Failed to fetch articles: \(error)")
    }
}

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let article = articles[indexPath.row]
        cell.textLabel?.text = article.title 
        return cell
    }
}

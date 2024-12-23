//
//  ArticleManager.swift
//  MediaApp
//
//  Created by Ulyana Eskova on 23.12.2024.
//

protocol ArticleManagerDelegate: AnyObject {
    func didUpdateArticles(_ articles: [ArticleModel])
}

class ArticleManager {
    // MARK: - Variables
    weak var delegate: ArticleManagerDelegate?
    private var articles: [ArticleModel] = []

    // MARK: - Methods
    func addArticle(_ article: ArticleModel) {
        articles.append(article)
        delegate?.didUpdateArticles(articles)
    }

    func getArticles() -> [ArticleModel] {
        return articles
    }
}

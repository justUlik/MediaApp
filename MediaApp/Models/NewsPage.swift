//
//  NewsPage.swift
//  MediaApp
//
//  Created by Ulyana Eskova on 23.12.2024.
//
import Foundation

struct NewsPage: Decodable {
    let requestId: String?
    let news: [ArticleModel]?
}

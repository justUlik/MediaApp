//
//  ArticleModel.swift
//  MediaApp
//
//  Created by Ulyana Eskova on 23.12.2024.
//

import Foundation

struct ArticleModel: Decodable {
    let title: String?
    let announce: String?
    let img: ArticleImage?
    let newsId: Int?
    let url: String?
    
    struct ArticleImage: Decodable {
        let url: String?
    }
}

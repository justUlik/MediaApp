import Foundation

protocol ArticleManagerDelegate: AnyObject {
    func didFetchArticles(_ articles: [ArticleModel], requestId: String?)
    func didUpdateArticles(_ articles: [ArticleModel])
    func didFailWithError(_ error: Error)
}

class ArticleManager {
    // MARK: - Variables
    weak var delegate: ArticleManagerDelegate?
    
    private var _articles: [ArticleModel] = []
    var requestId: String? 
    
    var articles: [ArticleModel] {
        get {
            _articles
        }
        set {
            _articles = newValue
            delegate?.didUpdateArticles(_articles)
        }
    }
    
    private let baseURL = "https://news.myseldon.com/api/Section"
    
    // MARK: - Methods
    func fetchArticles(rubricId: Int = 4, pageSize: Int = 10, pageIndex: Int = 0) {
        let urlString = "\(baseURL)?rubricId=\(rubricId)&pageSize=\(pageSize)&pageIndex=\(pageIndex)"
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                self?.delegate?.didFailWithError(error)
                return
            }
            
            guard let data = data else { return }
            do {
                let newsPage = try JSONDecoder().decode(NewsPage.self, from: data)
                self?.requestId = newsPage.requestId // Сохраняем requestId
                if let fetchedArticles = newsPage.news {
                    DispatchQueue.main.async {
                        self?.articles.append(contentsOf: fetchedArticles)
                        self?.delegate?.didFetchArticles(fetchedArticles, requestId: self?.requestId)
                    }
                }
            } catch {
                self?.delegate?.didFailWithError(error)
            }
        }
        
        task.resume()
    }
    
    func addArticle(_ article: ArticleModel) {
        articles.append(article)
    }
}

// MARK: - Extension
extension ArticleModel {
    func generateLink(requestId: String?) -> String? {
        guard let newsId = newsId, let requestId = requestId else { return nil }
        return "https://news.myseldon.com/ru/news/index/\(newsId)?requestId=\(requestId)"
    }
}

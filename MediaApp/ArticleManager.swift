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
    private var currentPageIndex: Int = 0
    private var pageSize: Int = 10
    private let baseURL = "https://news.myseldon.com/api/Section"
    
    var requestId: String?
    var articles: [ArticleModel] {
        get { _articles }
        set {
            _articles = newValue
            delegate?.didUpdateArticles(_articles)
        }
    }
    
    // MARK: - Methods
    func fetchArticles(rubricId: Int = 4) {
        fetchArticles(rubricId: rubricId, pageIndex: 0)
    }
    
    func fetchNextPage(rubricId: Int = 4) {
        currentPageIndex += 1
        fetchArticles(rubricId: rubricId, pageIndex: currentPageIndex)
    }
    
    private func fetchArticles(rubricId: Int, pageIndex: Int) {
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
                self?.requestId = newsPage.requestId
                if let fetchedArticles = newsPage.news {
                    DispatchQueue.main.async {
                        self?.articles.append(contentsOf: fetchedArticles)
                        self?.delegate?.didFetchArticles(self?.articles ?? [], requestId: self?.requestId)
                    }
                }
            } catch {
                self?.delegate?.didFailWithError(error)
            }
        }
        task.resume()
    }
}

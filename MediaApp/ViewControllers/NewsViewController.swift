import UIKit

final class NewsViewController: UIViewController {
    // MARK: - Constants
    private enum Constants {
        static let estimatedRowHeight: CGFloat = 120
        static let cellSpacing: CGFloat = 40
        static let contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        static let separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        static let footerHeight: CGFloat = 50
        static let loadMoreButtonHeight: CGFloat = 50
        static let loadMoreButtonTitle = "Еще новостей! Хочу меньше нервных клеток"
        static let loadMoreButtonColor = UIColor.systemBlue
        static let footerBackgroundColor = UIColor.systemGray6
    }
    
    // MARK: - Variables
    private let tableView = UITableView()
    private var articles: [ArticleModel] = []
    private var requestId: String?
    private let articleManager = ArticleManager()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureArticles()
    }
    
    // MARK: - Configurations
    // MARK: - Configurations
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.pin(to: view)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ArticleCell.self, forCellReuseIdentifier: "ArticleCell")
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = Constants.estimatedRowHeight
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = Constants.separatorInset
        tableView.contentInset = Constants.contentInset
        
        let footerView = createLoadMoreButton()
        tableView.tableFooterView = footerView
        print("Footer set: \(footerView.frame)")
    }
    
    private func configureArticles() {
        articleManager.delegate = self
        articleManager.fetchArticles()
    }
    
    private func createLoadMoreButton() -> UIView {
        let loadMoreButton = UIButton(type: .system)
        loadMoreButton.setTitle(Constants.loadMoreButtonTitle, for: .normal)
        loadMoreButton.setTitleColor(Constants.loadMoreButtonColor, for: .normal)
        loadMoreButton.addTarget(self, action: #selector(loadMoreTapped), for: .touchUpInside)
        
        let containerView = UIView(frame: CGRect(x: .zero, y: .zero, width: view.frame.width, height: Constants.footerHeight))
        containerView.backgroundColor = Constants.footerBackgroundColor 
        loadMoreButton.frame = containerView.bounds
        containerView.addSubview(loadMoreButton)
        return containerView
    }
    
    @objc private func loadMoreTapped() {
        articleManager.fetchNextPage()
    }
}

// MARK: - Extensions
extension NewsViewController: ArticleManagerDelegate {
    func didUpdateArticles(_ articles: [ArticleModel]) {
        self.articles = articles
        tableView.reloadData()
    }
    
    func didFetchArticles(_ articles: [ArticleModel], requestId: String?) {
        self.articles = articles
        self.requestId = requestId
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
        let article = articles[indexPath.row]
        cell.configure(with: article)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.estimatedRowHeight + Constants.cellSpacing
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = articles[indexPath.row]
        
        guard let requestId = self.requestId else {
            print("requestId is missing.")
            return
        }
        
        let urlString = article.generateLink(requestId: requestId)
        guard let url = URL(string: urlString ?? "") else {
            print("Invalid URL")
            return
        }
        
        print("Selected article URL: \(url)")
        
        let webViewController = WebViewController()
        webViewController.url = url
        
        navigationController?.pushViewController(webViewController, animated: true)
    }
}

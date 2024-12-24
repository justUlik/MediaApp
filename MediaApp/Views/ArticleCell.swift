import UIKit

class ArticleCell: UITableViewCell {
    // MARK: - UI Elements
    private let containerView = UIView()
    let articleImageView = UIImageView()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    
    // MARK: - Constants
    private enum Constants {
        static let containerCornerRadius: CGFloat = 10
        static let containerBackgroundColor: UIColor = .white
        
        static let containerPadding: CGFloat = 10
        static let containerVerticalPadding: CGFloat = 5
        
        static let imageSize: CGFloat = 80
        static let imagePadding: CGFloat = 15
        
        static let titleLabelFontSize: CGFloat = 16
        static let titleLabelPadding: CGFloat = 10
        static let titleNumberOfLines: Int = 0
        
        static let descriptionLabelFontSize: CGFloat = 14
        static let descriptionLabelPaddingTop: CGFloat = 5
        static let descriptionLabelPaddingBottom: CGFloat = 10
        static let descriptionNumberOfLines: Int = 3
    }
    
    // MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        contentView.addSubview(containerView)
        containerView.layer.cornerRadius = Constants.containerCornerRadius
        containerView.backgroundColor = Constants.containerBackgroundColor
        containerView.pinHorizontal(to: contentView, Constants.containerPadding)
        containerView.pinVertical(to: contentView, Constants.containerVerticalPadding)
        
        containerView.addSubview(articleImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        
        configureImageView()
        configureTitleLabel()
        configureDescriptionLabel()
    }
    
    private func configureImageView() {
        articleImageView.contentMode = .scaleAspectFill
        articleImageView.clipsToBounds = true
        
        articleImageView.pinTop(to: containerView, Constants.imagePadding)
        articleImageView.pinLeft(to: containerView, Constants.imagePadding)
        articleImageView.setWidth(mode: .equal, Constants.imageSize)
        articleImageView.setHeight(mode: .equal, Constants.imageSize)
    }
    
    private func configureTitleLabel() {
        titleLabel.font = .boldSystemFont(ofSize: Constants.titleLabelFontSize)
        titleLabel.numberOfLines = Constants.titleNumberOfLines
        titleLabel.lineBreakMode = .byWordWrapping
        
        titleLabel.pinTop(to: containerView, Constants.imagePadding)
        titleLabel.pinLeft(to: articleImageView.trailingAnchor, Constants.titleLabelPadding)
        titleLabel.pinRight(to: containerView, Constants.imagePadding)
    }
    
    private func configureDescriptionLabel() {
        descriptionLabel.font = .systemFont(ofSize: Constants.descriptionLabelFontSize)
        descriptionLabel.numberOfLines = Constants.descriptionNumberOfLines
        descriptionLabel.textColor = .gray
        descriptionLabel.lineBreakMode = .byTruncatingTail
        
        descriptionLabel.pinTop(to: titleLabel.bottomAnchor, Constants.descriptionLabelPaddingTop)
        descriptionLabel.pinLeft(to: articleImageView.trailingAnchor, Constants.titleLabelPadding)
        descriptionLabel.pinRight(to: containerView, Constants.imagePadding)
        descriptionLabel.pinBottom(to: containerView, Constants.descriptionLabelPaddingBottom, .lsOE)
    }
    
    // MARK: - Configure Cell
    func configure(with article: ArticleModel) {
        titleLabel.text = article.title
        descriptionLabel.text = article.announce
        
        if let imageUrl = article.img?.url {
            loadImage(from: imageUrl)
        }
    }
    
    // MARK: - Image Loading
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.articleImageView.image = image
                }
            }
        }
    }
}

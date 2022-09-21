//
//  EpisodeDetailsView.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 21/09/22.
//

import UIKit

final class EpisodeDetailsView: UIView, CodableView {
    
    struct Constants {
        static let edgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    var viewModel: EpisodeDetailsViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            
            self.imageView.downloaded(from: viewModel.imageUrl, contentMode: .scaleAspectFill)
            self.titleLabel.text = "\(viewModel.number). \(viewModel.title)"
            self.seasonLabel.text = "Season \(viewModel.season)"
            self.summaryLabel.text = viewModel.summary.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)

        }
    }
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 24
        stackView.layoutMargins = Constants.edgeInsets
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .boldSystemFont(ofSize: 32)
        return label
    }()
    
    lazy var seasonLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
    lazy var summaryTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Summary"
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()
    lazy var summaryLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
        self.backgroundColor = UIColor(white: 0.98, alpha: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildViews() {
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(seasonLabel)
        stackView.addArrangedSubview(summaryTitleLabel)
        stackView.addArrangedSubview(summaryLabel)
        
        scrollView.addSubview(stackView)
        self.addSubview(scrollView)
    }
    
    func configConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(200*16/9)
        }
                
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
    }
}

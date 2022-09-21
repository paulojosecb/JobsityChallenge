//
//  SeriesDetailsView.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 20/09/22.
//

import UIKit

final class SeriesDetailsView: UIView, CodableView {
    
    struct ViewModel {
        let imageUrl: String
        let title: String
        let summary: String
    }
    
    var viewModel: ViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            
            self.imageView.downloaded(from: viewModel.imageUrl)
            self.titleLabel.text = viewModel.title
            self.summaryLabel.text = viewModel.summary
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
        return stackView
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    lazy var summaryLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    func buildViews() {
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(summaryLabel)
        
        scrollView.addSubview(stackView)
        self.addSubview(scrollView)
    }
    
    func configConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
    }
    
     
}

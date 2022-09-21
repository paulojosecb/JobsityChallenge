//
//  SeriesDetailsView.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 20/09/22.
//

import UIKit
import AutoTableView

final class SeriesDetailsView: UIView, CodableView {
    
    struct Constants {
        static let edgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    var viewModel: SeriesDetailsViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            
            self.imageView.downloaded(from: viewModel.imageUrl, contentMode: .scaleAspectFill)
            self.titleLabel.text = viewModel.title
            self.summaryLabel.text = viewModel.summary.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)

            self.populate(stackView: genresStackView, with: viewModel.genres)
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
    
    private lazy var genresStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        return stackView
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
    
    lazy var episodesLabel: UILabel = {
        let label = UILabel()
        label.text = "Episodes"
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()
    
    lazy var seasonPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()
    
    lazy var tableView: AutoTableView<SeriesDetailsEpisodeTableViewCell, SeriesDetailsViewModel> = {
        let tableView = AutoTableView<SeriesDetailsEpisodeTableViewCell, SeriesDetailsViewModel>(data: .init(sections: []), gestureHandler: nil)
        return tableView
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
        stackView.addArrangedSubview(genresStackView)
        stackView.addArrangedSubview(summaryTitleLabel)
        stackView.addArrangedSubview(summaryLabel)
        stackView.addArrangedSubview(episodesLabel)
        stackView.addArrangedSubview(seasonPickerView)
        stackView.addArrangedSubview(tableView)
        
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
        
        genresStackView.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        
        seasonPickerView.snp.makeConstraints { make in
            make.height.equalTo(100)
        }
        
        tableView.snp.makeConstraints { make in
            make.height.equalTo(300)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
    }
    
    private func populate(stackView: UIStackView, with genres: [String]) {
        for view in stackView.arrangedSubviews {
            view.removeFromSuperview()
        }
        
        for genre in genres.prefix(4) {
            stackView.addArrangedSubview(makePaddingLabel(with: genre))
        }
        
        if (genres.count > 4) {
            genresStackView.addArrangedSubview(makePaddingLabel(with: "..."))
        }

    }
    
    private func makePaddingLabel(with text: String) -> PaddingLabel {
        let label = PaddingLabel()
        label.text = text
        label.textAlignment = .center
        label.textColor = .systemBlue
        label.layer.borderColor = UIColor.systemBlue.cgColor
        label.layer.borderWidth = 1
        label.clipsToBounds = true
        label.layer.cornerRadius = 8
        
        return label
    }
    
     
}

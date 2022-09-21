//
//  SerieTableViewCell.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 20/09/22.
//

import UIKit
import AutoTableView

final class SeriesTableViewCell: UITableViewCell,  AutoTableViewCell, CodableView {
    
    struct Constants {
        static let edgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    static var identifier: String = String(describing: SeriesTableViewCell.self)

    var viewModel: AutoTableViewRowModel? {
        didSet {
            guard let viewModel = viewModel as? SeriesRowModel else {
                return
            }
            
            self.iconImageView.downloaded(from: viewModel.imageURL)
            self.titleLabel.text = viewModel.name
            self.summaryLabel.text = viewModel.summary.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)

            self.ratingLabel.text = viewModel.rating
            self.populate(stackView: genresStackView, with: viewModel.genres)
        }
    }
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.layoutMargins = Constants.edgeInsets
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.layer.cornerRadius = 8
        stackView.clipsToBounds = true
        stackView.alignment = .leading
        return stackView
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var innerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 24, weight: .light)
        return label
    }()
    
    private lazy var summaryLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 3
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 14, weight: .regular)
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
    
    var gestureHandler: AutoTableViewCellGestureHandler?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapCell)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        for view in genresStackView.arrangedSubviews {
            view.removeFromSuperview()
        }
        
        titleLabel.text = ""
        summaryLabel.text = ""
        ratingLabel.text = ""
        iconImageView.image = nil
    }
    
    @objc func didTapCell() {
        guard let viewModel = viewModel else {
            return
        }
        
        self.gestureHandler?.didPressed(viewModel)
    }
    
    func buildViews() {
        innerStackView.addArrangedSubview(titleLabel)
        innerStackView.addArrangedSubview(summaryLabel)
        innerStackView.addArrangedSubview(ratingLabel)
        innerStackView.addArrangedSubview(genresStackView)
        
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(innerStackView)
        
        self.contentView.addSubview(stackView)
    }
    
    func configConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Constants.edgeInsets)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.width.equalTo(stackView.snp.width).multipliedBy(0.3)
            make.height.equalTo(iconImageView.snp.width).multipliedBy(1.4)
        }
        
        genresStackView.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
    }
    
    func configViews() {
        self.contentView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        self.stackView.backgroundColor = .white
    
    }
    
    
    private func populate(stackView: UIStackView, with genres: [String]) {
        for genre in genres.prefix(2) {
            stackView.addArrangedSubview(makePaddingLabel(with: genre))
        }
        
        if (genres.count > 2) {
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

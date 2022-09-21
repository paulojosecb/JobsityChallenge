//
//  SeriesDetailsEpisodeTableViewCell.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 20/09/22.
//

import UIKit
import AutoTableView

final class SeriesDetailsEpisodeTableViewCell: UITableViewCell, AutoTableViewCell, CodableView {
    
    static var identifier: String = String(describing: SeriesDetailsEpisodeTableViewCell.self)
    
    struct Constants {
        static let edgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    var viewModel: AutoTableViewRowModel? {
        didSet {
            guard let viewModel = viewModel as? EpisodesRowModel else {
                return
            }
            
            orderLabel.text = "\(viewModel.order)"
            titleLabel.text = viewModel.name
        }
    }
    
    var gestureHandler: AutoTableViewCellGestureHandler?
    
    private lazy var orderLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
        
        //self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapCell)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildViews() {
        self.contentView.addSubview(orderLabel)
        self.contentView.addSubview(titleLabel)
    }
    
    func configConstraints() {
        orderLabel.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(Constants.edgeInsets)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview().inset(Constants.edgeInsets)
            make.leading.equalTo(orderLabel.snp.trailing).offset(16)
        }
    }
    
    
    
}


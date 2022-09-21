//
//  HomeView.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 20/09/22.
//

import UIKit
import AutoTableView

final class SeriesView: UIView, CodableView {
    
    struct Constants {
        static let edgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    lazy var tableView: AutoTableView<SeriesTableViewCell, SeriesViewModel> = {
        let tableView = AutoTableView<SeriesTableViewCell, SeriesViewModel> (data: .init(sections: []), gestureHandler: nil)
        tableView.separatorStyle = .none
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
        self.addSubview(tableView)
    }
    
    func configConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}

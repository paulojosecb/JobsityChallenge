//
//  LockView.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 20/09/22.
//

import UIKit
import SnapKit

protocol LockViewDelegate: NSObject {
    func didPressShowPinButton()
}

final class LockView: UIView, CodableView {
    
    struct Constants {
        static let showPinInputButtonHeight: CGFloat = 48
        static let edgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "Jobsity Challenge"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "by Paulo José"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        return stackView
    }()
    
    private lazy var showPinInputButton: AnimatedButton = {
        let button = AnimatedButton()
        button.setTitle("Enter pin number", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(didPressShowPinInputButton), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: LockViewDelegate?
    
    @objc func didPressShowPinInputButton() {
        self.delegate?.didPressShowPinButton()
    }
    
    func configViews() {
        self.backgroundColor = .white
    }
    
    func buildViews() {
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(descriptionLabel)
        self.addSubview(textStackView)
        self.addSubview(showPinInputButton)
    }
    
    func configConstraints() {
        textStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        showPinInputButton.snp.makeConstraints { make in
            make.height.equalTo(Constants.showPinInputButtonHeight)
            make.leading.trailing.bottom.equalToSuperview().inset(Constants.edgeInsets)
        }
    }
    
    
}

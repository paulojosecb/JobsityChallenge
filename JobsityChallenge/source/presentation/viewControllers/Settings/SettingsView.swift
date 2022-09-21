//
//  SettingsView.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 21/09/22.
//

import UIKit

protocol SettingsViewDelegate: NSObject {
    func didIsTouchIDEnabledChange(newValue: Bool)
    func didIsPinEnabledChange(newValue: Bool)
}

final class SettingsView: UIView, CodableView {
    
    struct Constants {
        static let edgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    weak var delegate: SettingsViewDelegate?
    
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
    
    lazy var enablePinLabel: UILabel = {
        let label = UILabel()
        label.text = "Enable Pin for unlocking"
        return label
    }()
    
    lazy var isPinEnabledSwitch: UISwitch = {
        let isPinEnabledSwitch = UISwitch()
        isPinEnabledSwitch.addTarget(self, action: #selector(switchStateDidChange(_:)), for: .valueChanged)
        return isPinEnabledSwitch
    }()
    
    lazy var pinStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 16
        stackView.layoutMargins = Constants.edgeInsets
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    lazy var enableTouchIDLabel: UILabel = {
        let label = UILabel()
        label.text = "Enable TouchID for unlocking"
        return label
    }()
    
    lazy var isTouchIDEnabledSwitch: UISwitch = {
        let isTouchIDEnabledSwitch = UISwitch()
        isTouchIDEnabledSwitch.addTarget(self, action: #selector(switchStateDidChange(_:)), for: .valueChanged)
        return isTouchIDEnabledSwitch
    }()
    
    lazy var touchIDStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 16
        stackView.layoutMargins = Constants.edgeInsets
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildViews() {
        pinStackView.addArrangedSubview(enablePinLabel)
        pinStackView.addArrangedSubview(isPinEnabledSwitch)
        
        touchIDStackView.addArrangedSubview(enableTouchIDLabel)
        touchIDStackView.addArrangedSubview(isTouchIDEnabledSwitch)
        
        stackView.addArrangedSubview(pinStackView)
        stackView.addArrangedSubview(touchIDStackView)
        
        self.addSubview(scrollView)
        scrollView.addSubview(stackView)
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
    
    @objc func switchStateDidChange(_ sender: UISwitch!) {
        guard let sender = sender else {
            return
        }
        
        if sender == isPinEnabledSwitch {
            isTouchIDEnabledSwitch.isEnabled = isPinEnabledSwitch.isOn
            self.delegate?.didIsPinEnabledChange(newValue: isPinEnabledSwitch.isOn)
        } else if sender == isTouchIDEnabledSwitch {
            self.delegate?.didIsTouchIDEnabledChange(newValue: isTouchIDEnabledSwitch.isOn)
        }
    }
    
    
    
}

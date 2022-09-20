//
//  AnimatedButton.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 20/09/22.
//
import UIKit

class AnimatedButton: UIButton {
    init() {
        super.init(frame: .zero)
        self.addTarget(self, action: #selector(touchUp), for: .touchUpInside)
        self.addTarget(self, action: #selector(touchDown), for: .touchDown)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func touchUp() {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut) {
            self.transform = CGAffineTransform.identity
        }
    }
    
    @objc func touchDown() {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
}

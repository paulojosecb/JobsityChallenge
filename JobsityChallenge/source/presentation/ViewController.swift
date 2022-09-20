//
//  ViewController.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 17/09/22.
//

import UIKit
    
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        
        let useCase = FetchSeriesUseCase()
        useCase.exec(request: .init(type: .paged(1))) { result in
            switch result {
            case .success(let response):
                print(response.series)
            case .failure(_):
                break
            }
        }
        // Do any additional setup after loading the view.
    }


}


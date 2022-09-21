//
//  SeriesDetailsViewController.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 20/09/22.
//

import UIKit

final class SeriesDetailsViewController: UIViewController {
    
    let seriesDetailsView: SeriesDetailsView
    let presenter: SeriesDetailsPresenter
    
    init(seriesDetailsView: SeriesDetailsView = SeriesDetailsView(), presenter: SeriesDetailsPresenter = DefaultSeriesDetailsPresenter()) {
        self.presenter = presenter
        self.seriesDetailsView = seriesDetailsView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = seriesDetailsView
    }
}

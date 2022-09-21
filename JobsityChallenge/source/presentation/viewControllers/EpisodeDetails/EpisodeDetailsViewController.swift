//
//  EpisodeDetailsViewController.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 21/09/22.
//

import UIKit

final class EpisodeDetailsViewController: UIViewController {
    
    let presenter: EpisodeDetailsPresenter
    let episodeDetailsView: EpisodeDetailsView
    
    let id: Int
    
    init(id: Int, episodeDetailsView: EpisodeDetailsView = EpisodeDetailsView(),
         presenter: EpisodeDetailsPresenter = DefaultEpisodeDetailsPresenter()) {
        self.id = id
        self.presenter = presenter
        self.episodeDetailsView = episodeDetailsView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = episodeDetailsView
        
        self.presenter.fetchEpisodeDetails(id: self.id) { result in
            switch result {
            case .success(let viewModel):
                self.episodeDetailsView.viewModel = viewModel
            case .failure(let error):                let errorAlertController = UIAlertController.createErrorAlertController(error, message: "An Error occurred while fetching episode details. Please try again")
                self.present(errorAlertController, animated: true, completion: nil)
            }
        }
    }
}

//
//  SeriesDetailsViewController.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 20/09/22.
//

import UIKit
import AutoTableView

final class SeriesDetailsViewController: AutoListenableViewController<SeriesDetailsViewModel> {
    
    let seriesDetailsView: SeriesDetailsView
    let presenter: SeriesDetailsPresenter
    
    let id: Int
    
    var viewModel: SeriesDetailsViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            self.updateAutoTableViews(with: viewModel)
            self.seriesDetailsView.viewModel = viewModel
            self.seriesDetailsView.seasonPickerView.reloadAllComponents()
        }
    }
    
    init(id: Int, seriesDetailsView: SeriesDetailsView = SeriesDetailsView(), presenter: SeriesDetailsPresenter = DefaultSeriesDetailsPresenter()) {
        self.id = id
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
        
        seriesDetailsView.seasonPickerView.delegate = self
        seriesDetailsView.seasonPickerView.dataSource =  self
        
        self.add(listener: seriesDetailsView.tableView)
        self.seriesDetailsView.tableView.gestureHandler = self
        
        self.presenter.fetchSeriesDetails(id: self.id) { result in
            switch result {
            case .success(let viewModel):
                
                self.viewModel = viewModel
                
                guard let _ = viewModel.seasons.first else {
                    return
                }
                
                self.fetchEpisodes(from: 0)
                
            case .failure(let error):
                let errorAlertController = UIAlertController.createErrorAlertController(error, message: "An Error occurred while fetching series. Please try again")
                self.present(errorAlertController, animated: true, completion: nil)
            }
        }
    }
    
    private func fetchEpisodes(from seasonIndex: Int) {
        guard let id = self.viewModel?.seasons[seasonIndex].id else { return }
        self.presenter.fetchEpisodesFrom(season: id) { result in
            switch result {
            case .success(let viewModel):
                self.viewModel = viewModel
            case .failure(let error):
                let errorAlertController = UIAlertController.createErrorAlertController(error, message: "An Error occurred while fetching series. Please try again")
                self.present(errorAlertController, animated: true, completion: nil)
            }
        }
    }
}

extension SeriesDetailsViewController: AutoTableViewCellGestureHandler {
    func didPressed(_ row: AutoTableViewRowModel) {
        guard let row = row as? EpisodesRowModel else {
            return
        }
        
        self.present(EpisodeDetailsViewController(id: row.id), animated: true, completion: nil)
    }
}

extension SeriesDetailsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel?.seasons.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "Season \(row + 1)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.fetchEpisodes(from: row)
    }
}

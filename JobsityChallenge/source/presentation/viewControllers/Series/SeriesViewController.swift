//
//  ViewController.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 17/09/22.
//

import UIKit
import AutoTableView
    
class SeriesViewController: AutoListenableViewController<SeriesViewModel> {
    
    let presenter: SeriesPresenter
    let seriesView: SeriesView
    
    lazy var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 20))

    lazy var rightBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(title: "Settings", image: nil, primaryAction: UIAction { _ in
            self.present(SettingsViewController(), animated: true, completion: nil)
        }, menu: nil)
        return barButton
    }()
    
    init(presenter: SeriesPresenter = DefaultSeriesPresenter()) {
        self.presenter = presenter
        self.seriesView = SeriesView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var viewModel: SeriesViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            self.updateAutoTableViews(with: viewModel)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = seriesView
    
        self.add(listener: seriesView.tableView)
        self.seriesView.tableView.gestureHandler = self
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.rightBarButtonItem = rightBarButton
        self.title = "Jobsity TV Shows"
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search shows"
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
        
        self.presenter.fetchNextPage { result in
            switch result {
            case .success(let viewModel):
                self.viewModel = viewModel
            case .failure(let error):
                let errorAlertController = UIAlertController.createErrorAlertController(error, message: "An Error occurred while fetching series. Please try again")
                self.present(errorAlertController, animated: true, completion: nil)
                
            }
        }
        // Do any additional setup after loading the view.
    }
    
    private func filterSeriesBy(query: String) {
        self.presenter.fetchSeriesBy(query: query) { result in
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

extension SeriesViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !(searchBar.text?.isEmpty ?? false) {
            self.filterSeriesBy(query: searchBar.text ?? "")
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.viewModel = self.presenter.generalResult
    }
}

extension SeriesViewController: AutoTableViewCellGestureHandler {
    func didPressed(_ row: AutoTableViewRowModel) {
        guard let row = row as? SeriesRowModel else {
            return
        }
        
        let viewController = SeriesDetailsViewController(id: row.id)
        self.present(viewController, animated: true)
    }
    
    
}


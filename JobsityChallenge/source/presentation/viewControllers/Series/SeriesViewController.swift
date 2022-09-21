//
//  ViewController.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 17/09/22.
//

import UIKit
import AutoTableView
    
class SeriesViewController: AutoListenableViewController<SeriesViewModel> {
    
    let isFavoriteSeriesView: Bool
    
    let presenter: SeriesPresenter
    let seriesView: SeriesView
    
    lazy var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 20))

    lazy var rightBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(title: "Profile", image: nil, primaryAction: UIAction { _ in
            self.navigationController?.pushViewController(SettingsViewController(), animated: true)
        }, menu: nil)
        return barButton
    }()
    
    init(isFavoriteSeriesView: Bool = false, presenter: SeriesPresenter = DefaultSeriesPresenter()) {
        self.isFavoriteSeriesView = isFavoriteSeriesView
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
            
            if (viewModel.sections.first?.rows.isEmpty ?? false) && isFavoriteSeriesView {
                self.seriesView.emptyStateLabel.isHidden = false
            } else {
                self.seriesView.emptyStateLabel.isHidden = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = seriesView
    
        self.add(listener: seriesView.tableView)
        self.seriesView.tableView.gestureHandler = self
        
        if !isFavoriteSeriesView {
            self.setupSearchBar()
        }
        
        self.setupNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.fetchTvShows()
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search shows"
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
    }
    
    private func setupNavBar() {
        
        if !isFavoriteSeriesView {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationItem.rightBarButtonItem = rightBarButton
        }
        
        self.title = isFavoriteSeriesView ? "Favorite TV Shows" : "Jobsity TV Shows"
    }
    
    private func fetchTvShows() {
        if isFavoriteSeriesView {
            self.presenter.fetchFavorites { result in
                self.handle(result)
            }
        } else {
            self.presenter.fetchNextPage { result in
                self.handle(result)
            }
        }

    }
    
    private func handle(_ result: (Result<SeriesViewModel, Error>)) {
        switch result {
        case .success(let viewModel):
            self.seriesView.tableView.hideSkeleton()
            self.viewModel = viewModel
        case .failure(let error):
            let errorAlertController = UIAlertController.createErrorAlertController(error, message: "An Error occurred while fetching series. Please try again")
            self.present(errorAlertController, animated: true, completion: nil)
            
        }
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
    func didReachBottom() {
        if !isFavoriteSeriesView {
            self.presenter.fetchNextPage { result in
                switch result {
                case .success(let viewModel):
                    self.viewModel?.sections.append(contentsOf: viewModel.sections)
                case .failure(_):
                    break
                }
            }
        }
    }
    
    func didPressed(_ row: AutoTableViewRowModel) {
        guard let row = row as? SeriesRowModel else {
            return
        }
        
        let viewController = SeriesDetailsViewController(id: row.id)
        viewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
}


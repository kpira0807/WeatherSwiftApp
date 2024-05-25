import Foundation
import UIKit
import SnapKit
import Combine
import CoreLocation

final class ListCitiesControllerView: UIViewController {
    
    var filteredCities: [ListCitiesCellViewModel] = []
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    var coordination: CLLocation?
    
    let locationManager = CLLocationManager()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ListCitiesCell.self, forCellReuseIdentifier: ListCitiesCell.identifier)
        
        return tableView
    }()
    
    private let activityIndicator = UIActivityIndicatorView()
    
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchBar.placeholder = L10n.ListCities.Search.name
        searchController.searchBar.searchBarStyle = .minimal
        searchController.definesPresentationContext = true
        
        return searchController
    }()
    
    private let viewModel: ListCitiesViewModel
    
    private var subscriptions = Set<AnyCancellable>()
    
    init?(viewModel: ListCitiesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = Asset.textColor.color
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Asset.textColor.color]
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: Asset.textColor.color, .font: UIFont.boldSystemFont(ofSize: 24.0)]
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        navigationItem.title = L10n.ListCities.Title.name
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "My location", style: .plain, target: self, action: #selector(rightBarButtonTapped))
        
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        
        view.backgroundColor = Asset.backgroundColor.color
        
        setupBindings()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setuplocation()
    }
    
    func setuplocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    @objc func rightBarButtonTapped() {
        viewModel.currentWeather(
            lon: coordination?.coordinate.longitude ?? 0.0,
            lat: coordination?.coordinate.latitude ?? 0.0
        )
    }

    private func setupBindings() {
        activityIndicator.startAnimating()
        viewModel.reloadCitiesData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.setupViews()
                self?.tableView.reloadData()
                self?.activityIndicator.isHidden = true
                self?.activityIndicator.stopAnimating()
            }.store(in: &subscriptions)
    }
    
}

extension ListCitiesControllerView {
    
    private func setupViews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = Asset.backgroundColor.color
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableView.automaticDimension
        
        view.addSubview(tableView)
        tableView.accessibilityIdentifier = "tableView"
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(activityIndicator)
        activityIndicator.accessibilityIdentifier = "activityIndicator"
        activityIndicator.snp.makeConstraints{make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
    }
    
    private func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        let info = viewModel.cellViewModels
        filteredCities = info.filter({(cityInfo: ListCitiesCellViewModel) -> Bool in
            return cityInfo.city.contains(searchText) || cityInfo.country.contains(searchText)
        })
        tableView.reloadData()
    }
    
}

extension ListCitiesControllerView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredCities.count
        }
        return viewModel.cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var viewModels: ListCitiesCellViewModel
        if isFiltering {
            viewModels = filteredCities[indexPath.row]
        } else {
            viewModels = viewModel.cellViewModels[indexPath.row]
        }
        
        let cell: ListCitiesCell = tableView.dequeueReusableCell(withIdentifier: ListCitiesCell.identifier, for: indexPath) as! ListCitiesCell
        cell.setup(viewModels)
        cell.selectionStyle = .none
        
        return cell
    }
    
}

extension ListCitiesControllerView: UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        print("performDropWith")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var viewModels: ListCitiesCellViewModel
        if isFiltering {
            viewModels = filteredCities[indexPath.row]
        } else {
            viewModels = viewModel.cellViewModels[indexPath.row]
        }
        viewModels.onSelect()
    }
}

extension ListCitiesControllerView: UITableViewDragDelegate {
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        [UIDragItem(itemProvider: NSItemProvider())]
    }
    
}

extension ListCitiesControllerView: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
}

extension ListCitiesControllerView: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, coordination == nil {
            coordination = locations.first
            locationManager.stopUpdatingLocation()
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
        manager.stopUpdatingLocation()
    }
    
}

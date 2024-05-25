import Foundation
import UIKit
import SnapKit
import Combine
import MapKit

final class CityWeatherViewController: UIViewController {
    
    private let cityNameView = CityNameView()
    private let cityCurrentWeather = CityCurrentWeatherView()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CityWeatherCell.self, forCellReuseIdentifier: CityWeatherCell.identifier)
        
        return tableView
    }()
    
    private let activityIndicator = UIActivityIndicatorView()
    
    private let viewModel: CityWeatherViewModel
    private var subscriptions = Set<AnyCancellable>()
    
    init?(viewModel: CityWeatherViewModel) {
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
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        
        view.backgroundColor = Asset.backgroundColor.color
        setupBindings()
        setupViews()
    }
    
    private func setupBindings() {
        activityIndicator.startAnimating()
        viewModel.reloadCitiesData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.setupViews()
                self?.tableView.reloadData()
                self?.cityNameView.setupInfo(self?.viewModel.cityNameViewModel ?? CityNameViewModel(
                    city: "Kyiv",
                    country: "Ukraine"
                ))
                self?.cityCurrentWeather.setupInfo(self?.viewModel.cityCurrentWeatherViewModel ?? CityCurrentWeatherViewModel(
                    currentWeatherImage: "10d",
                    currentTemp: 12,
                    currentWeatherName: "Cloud"
                ))
                self?.activityIndicator.isHidden = true
                self?.activityIndicator.stopAnimating()
            }.store(in: &subscriptions)
    }
    
}

extension CityWeatherViewController {
    
    private func setupViews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = Asset.backgroundColor.color
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableView.automaticDimension
        
        view.addSubview(cityNameView)
        cityNameView.accessibilityIdentifier = "cityNameView"
        cityNameView.backgroundColor = Asset.backgroundColor.color
        cityNameView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8.0)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        view.addSubview(cityCurrentWeather)
        cityCurrentWeather.accessibilityIdentifier = "cityCurrentWeather"
        cityCurrentWeather.backgroundColor = Asset.backgroundColor.color
        cityCurrentWeather.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(cityNameView.snp.bottom).offset(16.0)
        }
        
        view.addSubview(tableView)
        tableView.accessibilityIdentifier = "tableView"
        tableView.snp.makeConstraints { make in
            make.top.equalTo(cityCurrentWeather.snp.bottom).offset(16.0)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        view.addSubview(activityIndicator)
        activityIndicator.accessibilityIdentifier = "activityIndicator"
        activityIndicator.snp.makeConstraints{make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
}

extension CityWeatherViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModels = viewModel.cellViewModels[indexPath.row]
        
        let cell: CityWeatherCell = tableView.dequeueReusableCell(withIdentifier: CityWeatherCell.identifier, for: indexPath) as! CityWeatherCell
        cell.setup(viewModels)
        cell.selectionStyle = .none
        
        return cell
    }
    
}

import Foundation
import UIKit
import SnapKit

final class CityCurrentWeatherView: UIView {
    
    private let currentWeatherImage = UIImageView()
    private let currentTempLabel = UILabel()
    private let currentNameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupInfo(_ viewModel: CityCurrentWeatherViewModel) {
        currentWeatherImage.downloaded(from: viewModel.currentWeatherImage)
        currentTempLabel.text = viewModel.currentTemp
        currentNameLabel.text = viewModel.currentWeatherName
    }
    
}

extension CityCurrentWeatherView {
    
    private func setupView() {
        addSubview(currentWeatherImage)
        currentWeatherImage.accessibilityIdentifier = "currentWeatherImage"
        currentWeatherImage.snp.makeConstraints{make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalTo(100.0)
            make.width.equalTo(100.0)
        }
        
        
        addSubview(currentTempLabel)
        currentTempLabel.accessibilityIdentifier = "currentTempLabel"
        currentTempLabel.numberOfLines = 1
        currentTempLabel.textAlignment = .center
        currentTempLabel.textColor = Asset.textTitleColor.color
        currentTempLabel.font = UIFont.boldSystemFont(ofSize: 30.0)
        currentTempLabel.snp.makeConstraints{make in
            make.top.equalToSuperview().offset(16.0)
            make.leading.equalTo(currentWeatherImage.snp.trailing).offset(16.0)
            make.trailing.equalToSuperview()
        }
        
        addSubview(currentNameLabel)
        currentNameLabel.accessibilityIdentifier = "currentNameLabel"
        currentNameLabel.numberOfLines = 0
        currentNameLabel.textAlignment = .center
        currentNameLabel.textColor = Asset.textColor.color
        currentNameLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        currentNameLabel.snp.makeConstraints{make in
            make.top.equalTo(currentTempLabel.snp.bottom).inset(16.0)
            make.leading.equalTo(currentWeatherImage.snp.trailing).offset(16.0)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(16.0)
        }
    }
    
}

import Foundation
import UIKit
import SnapKit

final class CityNameView: UIView {
    
    private let cityNameLabel = UILabel()
    private let countryNameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupInfo(_ viewModel: CityNameViewModel) {
        cityNameLabel.text = viewModel.city
        countryNameLabel.text = viewModel.country
    }
    
}

extension CityNameView {
    
    private func setupView() {
        snp.makeConstraints{make in
            make.height.equalTo(60.0)
        }
        
        addSubview(cityNameLabel)
        cityNameLabel.accessibilityIdentifier = "cityNameLabel"
        cityNameLabel.numberOfLines = 0
        cityNameLabel.textAlignment = .center
        cityNameLabel.textColor = Asset.textTitleColor.color
        cityNameLabel.font = UIFont.boldSystemFont(ofSize: 22.0)
        cityNameLabel.snp.makeConstraints{make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(8.0)
            make.trailing.equalToSuperview().inset(8.0)
        }
        
        addSubview(countryNameLabel)
        countryNameLabel.accessibilityIdentifier = "countryNameLabel"
        countryNameLabel.numberOfLines = 0
        countryNameLabel.textAlignment = .center
        countryNameLabel.textColor = Asset.textColor.color
        countryNameLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        countryNameLabel.snp.makeConstraints{make in
            make.centerX.equalToSuperview()
            make.top.equalTo(cityNameLabel.snp.bottom).inset(16.0)
            make.leading.equalToSuperview().offset(8.0)
            make.trailing.equalToSuperview().inset(8.0)
            make.bottom.equalToSuperview()
        }
    }
    
}

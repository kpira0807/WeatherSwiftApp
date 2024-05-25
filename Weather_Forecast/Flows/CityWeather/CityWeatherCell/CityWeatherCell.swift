import Foundation
import UIKit
import SnapKit

final class CityWeatherCell: UITableViewCell {
    
    static let identifier = "CityWeatherCell"
    
    private let backView = UIView()
    private let dayNameLabel = UILabel()
    private let dataLabel = UILabel()
    private let weatherImage = UIImageView()
    private let tempView = TempView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(_ viewModel: CityWeatherCellViewModel) {
        dayNameLabel.text = dataFormatter(viewModel.date, format: "EEEE").capitalized
        dataLabel.text = dataFormatter(viewModel.date, format: "dd-MM HH:mm")
        weatherImage.downloaded(from: viewModel.weatherImage)
        tempView.setupInfo(TempViewModel(temp: viewModel.temp))
    }
    
    func dataFormatter(_ date: String, format: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = format
        
        let date = dateFormatterGet.date(from: date)
        return dateFormatterPrint.string(from: date!)
    }
    
}

extension CityWeatherCell {
    
    private func setupView() {
        backgroundColor = Asset.backgroundColor.color
        
        addSubview(backView)
        backView.accessibilityIdentifier = "backView"
        backView.layer.cornerRadius = 8.0
        backView.layer.borderWidth = 1.5
        backView.layer.borderColor = Asset.borderColor.color.cgColor
        backView.backgroundColor = Asset.backgroundColor.color
        backView.snp.makeConstraints{make in
            make.top.equalToSuperview().offset(8.0)
            make.bottom.equalToSuperview().inset(8.0)
            make.leading.equalToSuperview().offset(8.0)
            make.trailing.equalToSuperview().inset(8.0)
            make.height.equalTo(70.0)
        }
        
        backView.addSubview(dayNameLabel)
        dayNameLabel.accessibilityIdentifier = "dayNameLabel"
        dayNameLabel.numberOfLines = 1
        dayNameLabel.textAlignment = .left
        dayNameLabel.textColor = Asset.textTitleColor.color
        dayNameLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        dayNameLabel.snp.makeConstraints{make in
            make.top.equalToSuperview().offset(8.0)
            make.leading.equalToSuperview().offset(8.0)
        }
        
        backView.addSubview(dataLabel)
        dataLabel.accessibilityIdentifier = "dataLabel"
        dataLabel.numberOfLines = 1
        dataLabel.textAlignment = .left
        dataLabel.textColor = Asset.textColor.color
        dataLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        dataLabel.snp.makeConstraints{make in
            make.top.equalTo(dayNameLabel.snp.bottom).offset(8.0)
            make.bottom.equalToSuperview().inset(8.0)
            make.leading.equalToSuperview().offset(8.0)
        }
        
        backView.addSubview(weatherImage)
        weatherImage.accessibilityIdentifier = "weatherImage"
        weatherImage.snp.makeConstraints { make in
            make.height.equalTo(50.0)
            make.width.equalTo(50.0)
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        backView.addSubview(tempView)
        tempView.accessibilityIdentifier = "tempView"
        tempView.snp.makeConstraints{make in
            make.trailing.equalToSuperview().inset(8.0)
            make.centerY.equalToSuperview()
            make.height.equalTo(40.0)
            make.width.equalTo(65.0)
        }
    }
    
}

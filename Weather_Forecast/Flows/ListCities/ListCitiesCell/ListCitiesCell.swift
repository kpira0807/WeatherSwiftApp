import Foundation
import UIKit
import SnapKit

final class ListCitiesCell: UITableViewCell {
    
    static let identifier = "ListCitiesCell"
    
    private let backView = UIView()
    private let nameCityLabel = UILabel()
    private let nameCountryLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(_ viewModel: ListCitiesCellViewModel) {
        nameCityLabel.text = viewModel.city
        nameCountryLabel.text = viewModel.country
    }
    
}

extension ListCitiesCell {
    
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
            make.height.equalTo(80.0)
        }
        
        backView.addSubview(nameCityLabel)
        nameCityLabel.accessibilityIdentifier = "nameCityLabel"
        nameCityLabel.numberOfLines = 0
        nameCityLabel.textAlignment = .left
        nameCityLabel.textColor = Asset.textTitleColor.color
        nameCityLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        nameCityLabel.snp.makeConstraints{make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(8.0)
            make.trailing.equalToSuperview().inset(8.0)
        }
        
        backView.addSubview(nameCountryLabel)
        nameCountryLabel.accessibilityIdentifier = "nameCountryLabel"
        nameCountryLabel.numberOfLines = 0
        nameCountryLabel.textAlignment = .right
        nameCountryLabel.textColor = Asset.textColor.color
        nameCountryLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        nameCountryLabel.snp.makeConstraints{make in
            make.top.equalTo(nameCityLabel.snp.bottom).offset(8.0)
            make.bottom.equalToSuperview().inset(8.0)
            make.leading.equalToSuperview().offset(8.0)
            make.trailing.equalToSuperview().inset(8.0)
        }
    }
    
}

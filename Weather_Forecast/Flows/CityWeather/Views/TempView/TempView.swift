import Foundation
import UIKit
import SnapKit

final class TempView: UIView {
    
    private let tempLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupInfo(_ viewModel: TempViewModel) {
        tempLabel.text = viewModel.temp
    }
    
}

extension TempView {
    
    private func setupView() {
        addSubview(tempLabel)
        layer.cornerRadius = 8.0
        layer.borderWidth = 1.5
        layer.borderColor = Asset.borderColor.color.cgColor
        backgroundColor = Asset.backgroundColor.color

        tempLabel.accessibilityIdentifier = "tempLabel"
        tempLabel.numberOfLines = 1
        tempLabel.textAlignment = .center
        tempLabel.textColor = Asset.textTitleColor.color
        tempLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        tempLabel.snp.makeConstraints{make in
            make.size.equalToSuperview()
        }
    }
    
}

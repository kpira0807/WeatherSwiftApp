import Foundation
import UIKit

final class ListCitiesCellViewModel {
    
    let city: String
    let country: String
    let onSelect: () -> Void
    
    init(
        city: String,
        country: String,
        onSelect: @escaping () -> Void
        
    ) {
        self.city = city
        self.country = country
        self.onSelect = onSelect
    }
    
}


//
//  Extensions.swift
//  InStat-test
//
//  Created by Денис Рубцов on 21.05.2022.
//

import Foundation
import UIKit

extension DateFormatter {
    func inStatFormatDate(date: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mmZ"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd MMM yyyy"
        
        if let date = dateFormatterGet.date(from: date) {
            return dateFormatterPrint.string(from: date)
        } else {
            return ""
        }
    }
}

extension UINavigationItem {
    func setTitle(with name: String) {
        let titleLabel = UILabel()
        titleLabel.text = name
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .heavy)
        titleLabel.textColor = .white
        titleView = titleLabel
    }
}

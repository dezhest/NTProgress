//
//  Date.swift
//  NTProgressTest
//
//  Created by Denis Zhesterev on 18.03.2023.
//

import Foundation

extension Date {
    func formattedString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss dd.MM.yy"
        return dateFormatter.string(from: self)
    }
}

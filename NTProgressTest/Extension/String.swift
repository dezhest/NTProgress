//
//  String.swift
//  NTProgressTest
//
//  Created by Denis Zhesterev on 09.03.2023.
//

import Foundation

extension String {
    var removeChars: String {
        var str = self
        str = str.components(separatedBy: ("_"))[0]
        str = str.filter { $0 != "/" }
        return str
    }
}

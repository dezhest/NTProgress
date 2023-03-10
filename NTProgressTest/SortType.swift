//
//  SortType.swift
//  NTProgressTest
//
//  Created by Denis Zhesterev on 07.03.2023.
//

import Foundation

enum SortType: String, CaseIterable {
    case date = "Дата изменения сделки"
    case name = "Имя инструмента"
    case price = "Цена сделки"
    case amount = "Объем сделки"
    case side = "Сторона сделки"
}

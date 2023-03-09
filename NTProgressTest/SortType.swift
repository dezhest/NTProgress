//
//  SortType.swift
//  NTProgressTest
//
//  Created by Denis Zhesterev on 07.03.2023.
//

import Foundation

enum SortType: String, CaseIterable {
    case date = "Сортировка по дате изменения сделки"
    case name = "Сортировка по имени инструмента"
    case price = "Сортировка по цене сделки"
    case amount = "Сортировка по объему сделки"
    case side = "Сортировка по стороне сделки"
}

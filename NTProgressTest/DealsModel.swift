//
//  DealsModel.swift
//  NTProgressTest
//
//  Created by Denis Zhesterev on 09.03.2023.
//

import Foundation

class DealsModel {
    var newDealsToSort: [Deal] = []
    var timer: Timer?
    var selectedSortingOption = SortType.date
    var destinationArrow = true
    var isPaused = false
    var shouldStartTimerAfterPause = false
    
    var dataSortUp: (Deal, Deal) -> Bool = { (deal: Deal, deal2: Deal) -> Bool in
        deal.dateModifier.timeIntervalSince1970 > deal2.dateModifier.timeIntervalSince1970
    }
    var dataSortDown: (Deal, Deal) -> Bool = { (deal: Deal, deal2: Deal) -> Bool in
        deal.dateModifier.timeIntervalSince1970 < deal2.dateModifier.timeIntervalSince1970
    }
    var nameSortUp: (Deal, Deal) -> Bool = { (deal: Deal, deal2: Deal) -> Bool in
        deal.instrumentName < deal2.instrumentName
    }
    var nameSortDown: (Deal, Deal) -> Bool = { (deal: Deal, deal2: Deal) -> Bool in
        deal.instrumentName > deal2.instrumentName
    }
    var priceSortUp: (Deal, Deal) -> Bool = { (deal: Deal, deal2: Deal) -> Bool in
        deal.price > deal2.price
    }
    var priceSortDown: (Deal, Deal) -> Bool = { (deal: Deal, deal2: Deal) -> Bool in
        deal.price < deal2.price
    }
    var amountSortUp: (Deal, Deal) -> Bool = { (deal: Deal, deal2: Deal) -> Bool in
        deal.amount > deal2.amount
    }
    var amountSortDown: (Deal, Deal) -> Bool = { (deal: Deal, deal2: Deal) -> Bool in
        deal.amount < deal2.amount
    }
    var sideSortUp: (Deal, Deal) -> Bool = { (deal: Deal, deal2: Deal) -> Bool in
        deal.side.hashValue < deal2.side.hashValue
    }
    var sideSortDown: (Deal, Deal) -> Bool = { (deal: Deal, deal2: Deal) -> Bool in
        deal.side.hashValue > deal2.side.hashValue
    }
}

//
//  DealsViewModel.swift
//  NTProgressTest
//
//  Created by Denis Zhesterev on 09.03.2023.
//

import SwiftUI

class DealsViewModel: ObservableObject {
    private let server = Server()
    @Published var model = DealsModel()
    @Published var deals: [Deal] = []
    private var newDealsToSort: [Deal] = []
    private var timer = Timer()
    
    lazy var sortingMethod = dataSortUp
//    {
//        willSet {
//            DispatchQueue.main.async { [self] in
//                deals = deals.sorted(by: newValue)
//            }
//        }
//    }
    
    var dataSortUp: (Deal, Deal) -> Bool = { (deal: Deal, deal2: Deal) -> Bool in
        deal.dateModifier.timeIntervalSince1970 < deal2.dateModifier.timeIntervalSince1970
    }
    var dataSortDown: (Deal, Deal) -> Bool = { (deal: Deal, deal2: Deal) -> Bool in
        deal.dateModifier.timeIntervalSince1970 > deal2.dateModifier.timeIntervalSince1970
    }
    var nameSortUp: (Deal, Deal) -> Bool = { (deal: Deal, deal2: Deal) -> Bool in
        deal.instrumentName > deal2.instrumentName
    }
    var nameSortDown: (Deal, Deal) -> Bool = { (deal: Deal, deal2: Deal) -> Bool in
        deal.instrumentName < deal2.instrumentName
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
        "\(deal.side)" > "\(deal2.side)"
    }
    var sideSortDown: (Deal, Deal) -> Bool = { (deal: Deal, deal2: Deal) -> Bool in
        "\(deal.side)" < "\(deal2.side)"
    }
    
    
    func updateDeals() {
        print("UPDATE \(newDealsToSort.count) \(deals.count)")
        
            deals = getMergedDataArray(sortedData: deals, newData: newDealsToSort)
            newDealsToSort = []
        
    }
    
    func startDealsPipe() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.updateDeals()
        }
        self.server.subscribeToDeals { [self] newDeals in
            DispatchQueue.main.async { [self] in
                if deals.isEmpty {
                    deals = getMergedDataArray(sortedData: [], newData: newDeals)
                } else {
                    newDealsToSort += newDeals
                }
            }
        }
    }
    
    private func getMergedDataArray(sortedData: [Deal], newData: [Deal]) -> [Deal] {
      let sortedNewData = newData.sorted(by: sortingMethod)
      var mergedData = [Deal]()
      mergedData.reserveCapacity(sortedData.count + newData.count)
      var i = 0
      var j = 0
      while i < sortedData.count && j < sortedNewData.count {
        if sortingMethod(sortedData[i], sortedNewData[j]) {
//          if sortedData[i].price < sortedNewData[j].price {
          mergedData.append(sortedData[i])
          i += 1
        } else {
          mergedData.append(sortedNewData[j])
          j += 1
        }
      }
      while i < sortedData.count {
        mergedData.append(sortedData[i])
        i += 1
      }
      while j < sortedNewData.count {
        mergedData.append(sortedNewData[j])
        j += 1
      }
      return mergedData
    }
}

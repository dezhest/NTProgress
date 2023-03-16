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
    var dealsDateUp: [Deal] = []
    var dealsPriceUp: [Deal] = []
    var dealsAmountUp: [Deal] = []
    var dealsSideUp: [Deal] = []
    var dealsSideDown: [Deal] = []
    var dealsName: [Deal] = []
    private var newDealsToSort: [Deal] = []
    private var timer = Timer()
    
    lazy var sortingMethod = dataSortUp
    
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
        switch (model.selectedSortingOption, model.destinationArrow) {
        case(.date, true): deals = dealsDateUp
        case(.price, true): deals = dealsPriceUp
        case(.amount, true): deals = dealsAmountUp
        case(.side, true): deals = dealsSideUp
        case(.date, false): deals = dealsDateUp.reversed()
        case(.price, false): deals = dealsPriceUp.reversed()
        case(.amount, false): deals = dealsAmountUp.reversed()
        case(.side, false): deals = dealsSideDown
        default: print("default")
        }
        DispatchQueue.main.async { [self] in
            dealsDateUp = getMergedDataArrayDate(sortedData: dealsDateUp, newData: newDealsToSort)
            
            dealsPriceUp = getMergedDataArrayPrice(sortedData: dealsPriceUp, newData: newDealsToSort)
            
            dealsAmountUp = getMergedDataArrayAmount(sortedData: dealsAmountUp, newData: newDealsToSort)
//            
//                    dealsSideUp = getMergedDataArraySideUp(sortedData: deals, newData: newDealsToSort)
//            dealsSideDown = getMergedDataArraySideDown(sortedData: deals, newData: newDealsToSort)
            //        dealsName = getMergedDataArrayName(sortedData: deals, newData: newDealsToSort)
            
            newDealsToSort = []
        }
      
    }
    
    func startDealsPipe() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.updateDeals()
        }
        self.server.subscribeToDeals { [self] newDeals in
            DispatchQueue.main.async { [self] in
                if deals.isEmpty {
                    dealsDateUp = getMergedDataArrayDate(sortedData:  [], newData: newDeals)
                } else {
                    newDealsToSort += newDeals
                }
            }
        }
    }
    private func getMergedDataArrayDate(sortedData: [Deal], newData: [Deal]) -> [Deal] {
        let sortedNewData = newData.sorted(by: {$0.dateModifier > $1.dateModifier})
      var mergedData = [Deal]()
      mergedData.reserveCapacity(sortedData.count + newData.count)
      var i = 0
      var j = 0
      while i < sortedData.count && j < sortedNewData.count {
          if sortedData[i].dateModifier > sortedNewData[j].dateModifier {
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
    private func getMergedDataArrayAmount(sortedData: [Deal], newData: [Deal]) -> [Deal] {
        let sortedNewData = newData.sorted(by: {$0.amount > $1.amount})
      var mergedData = [Deal]()
      mergedData.reserveCapacity(sortedData.count + newData.count)
      var i = 0
      var j = 0
      while i < sortedData.count && j < sortedNewData.count {
          if sortedData[i].amount > sortedNewData[j].amount {
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
    private func getMergedDataArrayPrice(sortedData: [Deal], newData: [Deal]) -> [Deal] {
        let sortedNewData = newData.sorted(by: {$0.price > $1.price})
      var mergedData = [Deal]()
      mergedData.reserveCapacity(sortedData.count + newData.count)
      var i = 0
      var j = 0
      while i < sortedData.count && j < sortedNewData.count {
          if sortedData[i].price > sortedNewData[j].price {
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

    func getMergedDataArraySideUp(sortedData: [Deal], newData: [Deal]) -> [Deal] {
        let sortedFirstArray: [Deal] = sortedData
        let sortedSecondArray = newData.sorted(by: sideSortUp)
        var mergedArray = [Deal]()
        var firstIndex = 0
        var secondIndex = 0
        while firstIndex < sortedFirstArray.count && secondIndex < sortedSecondArray.count {
            if sortedFirstArray[firstIndex].side == .buy {
                mergedArray.append(sortedFirstArray[firstIndex])
            }
            firstIndex += 1
            if sortedSecondArray[secondIndex].side == .buy {
                mergedArray.append(sortedSecondArray[secondIndex])
            }
            secondIndex += 1
        }
        if firstIndex < sortedFirstArray.count {
            mergedArray.append(contentsOf: sortedFirstArray[firstIndex...])
        }
        if secondIndex < sortedSecondArray.count {
            mergedArray.append(contentsOf: sortedSecondArray[secondIndex...])
        }
        return mergedArray
    }
    func getMergedDataArraySideDown(sortedData: [Deal], newData: [Deal]) -> [Deal] {
        let sortedFirstArray: [Deal] = sortedData
        let sortedSecondArray = newData.sorted(by: sideSortDown)
        var mergedArray = [Deal]()
        var firstIndex = 0
        var secondIndex = 0
        while firstIndex < sortedFirstArray.count && secondIndex < sortedSecondArray.count {
            if sortedFirstArray[firstIndex].side == .sell {
                mergedArray.append(sortedFirstArray[firstIndex])
            }
            firstIndex += 1
            if sortedSecondArray[secondIndex].side == .sell {
                mergedArray.append(sortedSecondArray[secondIndex])
            }
            secondIndex += 1
        }
        if firstIndex < sortedFirstArray.count {
            mergedArray.append(contentsOf: sortedFirstArray[firstIndex...])
        }
        if secondIndex < sortedSecondArray.count {
            mergedArray.append(contentsOf: sortedSecondArray[secondIndex...])
        }
        return mergedArray
    }

}

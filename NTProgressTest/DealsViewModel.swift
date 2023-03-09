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
    @Published var deals: [Deal] = [] {
        didSet {
            if oldValue.count % 1000 == 0 {
                print("count \(oldValue.count)")
            }
        }
    }
    private var newDealsToSort: [Deal] = []
    private var timer = Timer()
    let queue = DispatchQueue(label: "DealsMakeQueue")
    
    private func getSortingMethod() -> (Deal, Deal) -> Bool {
        switch model.selectedSortingOption {
          case(SortType.date):
            return { deal, deal2 in
                deal.dateModifier.timeIntervalSince1970 < deal2.dateModifier.timeIntervalSince1970
            }
          case(SortType.name):
            return { deal, deal2 in
                deal.instrumentName < deal2.instrumentName
            }
          case(SortType.price):
            return { deal, deal2 in
                deal.price < deal2.price
            }
          case(SortType.amount):
            return { deal, deal2 in
                deal.amount < deal2.amount
            }
        case(SortType.side):
          return { deal, deal2 in
              "\(deal.side)" < "\(deal2.side)"
          }

        }
    }
    
    func updateDeals() {
        print("UPDATE \(newDealsToSort.count) \(deals.count)")
        DispatchQueue.main.async {
            self.deals = self.getMergedDataArray(sortedData: self.deals, newData: self.newDealsToSort)
            self.newDealsToSort = []
        }
    }
    
    func startDealsPipe() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.updateDeals()
        }
//        RunLoop.main.add(self.timer, forMode: .common)
        self.server.subscribeToDeals { newDeals in
            if self.deals.isEmpty {
                self.deals = self.getMergedDataArray(sortedData: [], newData: newDeals)
            } else {
                self.newDealsToSort += newDeals
            }
        }
    }
    
    private func getMergedDataArray(sortedData: [Deal], newData: [Deal]) -> [Deal] {
        var mergedData = [Deal]()
        let sortedNewData = newData.sorted(by: self.getSortingMethod())
        //    let sortedNewData = newData
        
        mergedData.reserveCapacity(sortedData.count + newData.count)
        var i = 0
        var j = 0
        while i < sortedData.count && j < sortedNewData.count {
            if self.getSortingMethod()(sortedData[i], sortedNewData[j]) {
                mergedData.append(sortedData[i])
                i += 1
            } else {
                mergedData.append(sortedNewData[j])
                j += 1
            }
        }
        
        // добить остатки
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

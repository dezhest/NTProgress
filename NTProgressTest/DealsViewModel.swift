//
//  DealsViewModel.swift
//  NTProgressTest
//
//  Created by Denis Zhesterev on 09.03.2023.
//

import SwiftUI

class DealsViewModel: ObservableObject {
    let queue = DispatchQueue(label: "DealsMakeQueue")
    private var newDealsToSort: [Deal] = []
    private var timer = Timer()
    private let server = Server()
    @Published var model = DealsModel()
    @Published var deals: [Deal] = [] {
        didSet {
            if oldValue.count % 1000 == 0 {
                print("count \(oldValue.count)")
            }
        }
    }

    
    private func getSortingMethod() -> (Deal, Deal) -> Bool {
        switch (model.selectedSortingOption, model.destinationArrow) {
        case(SortType.date, true):
            return { deal, deal2 in
                deal.dateModifier.timeIntervalSince1970 > deal2.dateModifier.timeIntervalSince1970
            }
        case(SortType.date, false):
            return { deal, deal2 in
                deal.dateModifier.timeIntervalSince1970 < deal2.dateModifier.timeIntervalSince1970
            }
        case(SortType.name, true):
            return { deal, deal2 in
                deal.instrumentName > deal2.instrumentName
            }
        case(SortType.name, false):
            return { deal, deal2 in
                deal.instrumentName < deal2.instrumentName
            }
        case(SortType.price, true):
            return { deal, deal2 in
                deal.price > deal2.price
            }
        case(SortType.price,false):
            return { deal, deal2 in
                deal.price < deal2.price
            }
        case(SortType.amount, true):
            return { deal, deal2 in
                deal.amount > deal2.amount
            }
        case(SortType.amount, false):
            return { deal, deal2 in
                deal.amount < deal2.amount
            }
        case(SortType.side, true):
            return { deal, deal2 in
                "\(deal.side)" > "\(deal2.side)"
            }
        case(SortType.side, false):
            return { deal, deal2 in
                "\(deal.side)" < "\(deal2.side)"
            }
        }
    }
    
    func updateDeals() {
        print("UPDATE \(newDealsToSort.count) \(deals.count)")
        self.deals = self.getMergedDataArray(sortedData: self.deals, newData: self.newDealsToSort)
        self.newDealsToSort = []
    }
    
    func startDealsPipe() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.updateDeals()
        }
        //        RunLoop.main.add(self.timer, forMode: .common)
        self.server.subscribeToDeals { newDeals in
            self.queue.async {
                if self.deals.isEmpty {
                    self.deals = self.getMergedDataArray(sortedData: [], newData: newDeals)
                } else {
                    DispatchQueue.main.async {
                        self.newDealsToSort += newDeals
                    }
                }
            }
        }
    }
    
    private func getMergedDataArray(sortedData: [Deal], newData: [Deal]) -> [Deal] {
        var mergedData = [Deal]()
        let sortedNewData = newData.sorted(by: self.getSortingMethod())
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

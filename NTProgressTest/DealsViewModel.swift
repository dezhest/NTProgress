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
        DispatchQueue.main.async { [self] in
            deals = getMergedDataArray(sortedData: deals, newData: newDealsToSort)
            newDealsToSort = []
        }
    }
    
    func startDealsPipe() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.updateDeals()
        }
        self.server.subscribeToDeals { [self] newDeals in
            if deals.isEmpty {
                deals = getMergedDataArray(sortedData: [], newData: newDeals)
            } else {
                newDealsToSort += newDeals
            }
        }
    }
    
    private func getMergedDataArray(sortedData: [Deal], newData: [Deal]) -> [Deal] {
        let sortedNewData = newData.sorted(by: getSortingMethod())
        var mergedData = [Deal]()
        mergedData.reserveCapacity(sortedData.count + newData.count)
        var i = 0
        var j = 0
        if !sortedData.isEmpty {
            if getSortingMethod()(sortedData[i], sortedNewData[j]) {
                while i < sortedData.count {
                    mergedData.append(sortedData[i])
                    i += 1
                }
            } else {
                while j < sortedNewData.count {
                    mergedData.append(sortedNewData[j])
                    j += 1
                }
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

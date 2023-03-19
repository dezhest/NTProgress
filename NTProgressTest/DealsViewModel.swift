//
//  DealsViewModel.swift
//  NTProgressTest
//
//  Created by Denis Zhesterev on 09.03.2023.
//

import SwiftUI

class DealsViewModel: ObservableObject {
    private let server = Server()
    //    @Published var model = DealsModel()
    @Published var deals: [Deal] = []
    private var newDealsToSort: [Deal] = []
    private var timer: Timer?
    
    var selectedSortingOption = SortType.date
    var destinationArrow = true
    var isPaused = false
    var shouldStartTimerAfterPause = false
    lazy var sortingMethod = dataSortUp {
        didSet {
            if isPaused {
                print("уже остановлен")
                shouldStartTimerAfterPause = true
            } else {
                pauseTimer()
                timer?.invalidate()
            }
        }
    }
    func pauseTimer() {
        isPaused = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.resumeTimer()
            self?.startDealsPipe()
            print("возобновлен")
        }
        DispatchQueue.main.async { [self] in
                deals = deals.sorted(by: sortingMethod)
        }
        print("остановлен")
    }
    func resumeTimer() {
        isPaused = false
        if shouldStartTimerAfterPause {
            shouldStartTimerAfterPause = false
        }
    }
    
    var dataSortUp: (Deal, Deal) -> Bool = { (deal: Deal, deal2: Deal) -> Bool in
        deal.dateModifier.timeIntervalSince1970 > deal2.dateModifier.timeIntervalSince1970
    }
    var dataSortDown: (Deal, Deal) -> Bool = { (deal: Deal, deal2: Deal) -> Bool in
        deal.dateModifier.timeIntervalSince1970 < deal2.dateModifier.timeIntervalSince1970
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
        deal.side.hashValue < deal2.side.hashValue
    }
    var sideSortDown: (Deal, Deal) -> Bool = { (deal: Deal, deal2: Deal) -> Bool in
        deal.side.hashValue > deal2.side.hashValue
    }
    
    
    func updateDeals() {
        print("UPDATE \(newDealsToSort.count) \(deals.count)")
        DispatchQueue.main.async { [self] in
//            if selectedSortingOption == .side {
//                deals = sideSorting(sortedData: deals, newData: newDealsToSort)
//            } else {
                deals = getMergedDataArrayDate(sortedData: deals, newData: newDealsToSort, sortingMethod: sortingMethod)
                newDealsToSort = []
//            }
            
        }
    }
    
    func startDealsPipe() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.updateDeals()
        }
        self.server.subscribeToDeals { [self] newDeals in
            DispatchQueue.main.async { [self] in
                if deals.isEmpty {
                    deals = getMergedDataArrayDate(sortedData:  [], newData: newDeals, sortingMethod: dataSortUp)
                } else {
                    newDealsToSort += newDeals
                }
            }
        }
    }
    private func getMergedDataArrayDate(sortedData: [Deal], newData: [Deal], sortingMethod: (Deal, Deal) -> Bool) -> [Deal] {
        if newData.count == 0 {
            return sortedData
        } else {
            let sortedNewData = newData.sorted(by: sortingMethod)
            var mergedData = [Deal]()
            mergedData.reserveCapacity(sortedData.count + newData.count)
            var i = 0
            var j = 0
            while i < sortedData.count && j < sortedNewData.count {
                if sortingMethod(sortedData[i], sortedNewData[j]) {
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
    private func sideSorting(sortedData: [Deal], newData: [Deal]) -> [Deal] {
        var mergedData = [Deal]()
        let sortedDataBySide = sortedData + newData
        for i in sortedDataBySide {
            if i.side == .sell {
                mergedData.append(i)
            } else {
                mergedData.insert(i, at: 0)
            }
        }
        return mergedData
    }
}

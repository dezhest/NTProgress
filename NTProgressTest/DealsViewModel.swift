//
//  DealsViewModel.swift
//  NTProgressTest
//
//  Created by Denis Zhesterev on 09.03.2023.
//

import SwiftUI

final class DealsViewModel: ObservableObject {
    private let server = Server()
    @Published var deals: [Deal] = []
    var newDealsToSort: [Deal] = []
    var timer: Timer?
    var selectedSortingOption = SortType.date
    var destinationArrow = true
    var isPaused = false
    var shouldStartTimerAfterPause = false
    
    lazy var sortingMethod = ComparedSortType.dateSortUp {
        willSet {
            if isPaused {
                shouldStartTimerAfterPause = true
            } else {
                isPaused = true
                pauseTimer()
            }
        }
    }
    func pauseTimer() {
        timer?.invalidate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            resumeTimer()
            startDealsPipe()
        }
        DispatchQueue.main.async { [self] in
            deals = deals.sorted(by: sortingMethod)
        }
    }
    func resumeTimer() {
        isPaused = false
        if shouldStartTimerAfterPause {
            shouldStartTimerAfterPause = false
        }
    }
    
    func updateDeals() {
        print("UPDATE \(newDealsToSort.count) \(deals.count)")
        DispatchQueue.main.async { [self] in
            deals = getMergedDataArrayDate(sortedData: deals, newData: newDealsToSort, sortingMethod: sortingMethod)
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
                    deals = getMergedDataArrayDate(sortedData:  [], newData: newDeals, sortingMethod: ComparedSortType.dateSortUp)
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
    func changeTypeByTap(_ typeUp : @escaping (Deal, Deal) -> Bool, _ typeDown: @escaping (Deal, Deal) -> Bool) {
        if destinationArrow {
            sortingMethod = typeDown
        }
        else {
            sortingMethod = typeUp
        }
    }
}

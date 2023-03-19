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

    lazy var sortingMethod = model.dataSortUp {
        willSet {
            if model.isPaused {
                print("уже остановлен")
                model.shouldStartTimerAfterPause = true
            } else {
                pauseTimer()
                model.timer?.invalidate()
            }
        }
    }
    func pauseTimer() {
        model.isPaused = true
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
        model.isPaused = false
        if model.shouldStartTimerAfterPause {
            model.shouldStartTimerAfterPause = false
        }
    }

    func updateDeals() {
        print("UPDATE \(model.newDealsToSort.count) \(deals.count)")
        DispatchQueue.main.async { [self] in
            deals = getMergedDataArrayDate(sortedData: deals, newData: model.newDealsToSort, sortingMethod: sortingMethod)
            model.newDealsToSort = []
        }
    }
    
    func startDealsPipe() {
        model.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.updateDeals()
        }
        self.server.subscribeToDeals { [self] newDeals in
            DispatchQueue.main.async { [self] in
                if deals.isEmpty {
                    deals = getMergedDataArrayDate(sortedData:  [], newData: newDeals, sortingMethod: model.dataSortUp)
                } else {
                    model.newDealsToSort += newDeals
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
    func changeTypeByTap(_ typeUp : @escaping (Deal, Deal) -> Bool, _ typeDown: @escaping (Deal, Deal) -> Bool) {
        if model.destinationArrow {
            sortingMethod = typeDown
        }
        else {
            sortingMethod = typeUp
        }
    }
}

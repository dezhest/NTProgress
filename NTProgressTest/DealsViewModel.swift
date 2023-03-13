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

    private func getSortingMethod() -> (Deal, Deal) -> Bool {
        return { deal, deal2 in
          deal.dateModifier.timeIntervalSince1970 < deal2.dateModifier.timeIntervalSince1970
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

  self.server.subscribeToDeals { newDeals in
    
      if self.deals.isEmpty {
        self.deals = self.getMergedDataArray(sortedData: [], newData: newDeals)
      } else {
        self.newDealsToSort += newDeals
      }
  }
}

private func getMergedDataArray(sortedData: [Deal], newData: [Deal]) -> [Deal] {
  let sortedNewData = newData.sorted(by: getSortingMethod())

  var mergedData = [Deal]()
  mergedData.reserveCapacity(sortedData.count + newData.count)

  var i = 0
  var j = 0
  while i < sortedData.count && j < sortedNewData.count {
    if getSortingMethod()(sortedData[i], sortedNewData[j]) {
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


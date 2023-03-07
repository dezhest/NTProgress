//
//  ContentView.swift
//  NTProgressTest
//
//  Created by Denis Zhesterev on 07.03.2023.
//

import SwiftUI

struct ContentView: View {
    private let server = Server()
    @State private var model: [Deal] = []
    @State private var pickerSelection = SortType.date
    var sortedDeals: [Deal] {
        switch pickerSelection {
        case(SortType.date): return model.sorted(by: {$0.dateModifier > $1.dateModifier})
        case(SortType.name): return model.sorted(by: {$0.instrumentName < $1.instrumentName})
        case(SortType.price): return model.sorted(by: {$0.price > $1.price})
        case(SortType.amount): return model.sorted(by: {$0.amount > $1.amount})
            //        case(SortType.side): return model.sorted(by: {$0.side > $1.type})
        }
    }
    let date: Date
    let dateFormatter: DateFormatter
    init() {
        date = Date()
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:SS dd.MM.yy"
    }
    let queue = DispatchQueue(label: "DealsSorting")
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(sortedDeals, id: \.id) { model in
                        VStack{
                            HStack {
                                Text(model.instrumentName)
                                Text("\(Int(model.amount))")
                                Text(String(format: "%.2f", model.price))
                            }
                            Text("\(model.dateModifier, formatter: dateFormatter)")
                        }
                    }
                }
            }
            .navigationBarItems(leading: Picker("Select number", selection: $pickerSelection) {
                Text("Сортировка по дате изменения сделки").tag(SortType.date)
                Text("Сортировка по имени инструмента").tag(SortType.name)
                Text("Сортировка по цене сделки").tag(SortType.price)
                Text("Сортировка по обему сделки").tag(SortType.amount)
                //            Text("Сортировка по стороне сделки").tag(SortType.side)
            } .pickerStyle(.menu))
        }
        .onAppear {
            server.subscribeToDeals{ deals in
                self.model.append(contentsOf: deals)
//                    for i in deals {
//                        if let index = model.firstIndex(where: { $0.dateModifier > i.dateModifier }) {
//                            self.model.insert(contentsOf: deals, at: index)
//                        } else {
//                            self.model.append(contentsOf: deals)
//                        }
//                    }
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

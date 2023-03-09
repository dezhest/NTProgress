//
//  ContentView.swift
//  NTProgressTest
//
//  Created by Denis Zhesterev on 07.03.2023.
//

import SwiftUI
import Foundation

struct DealsView: View {
    @StateObject var viewModel = DealsViewModel()
    @Environment(\.colorScheme) var colorScheme
    let date: Date
    let dateFormatter: DateFormatter
    init() {
        date = Date()
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:SS dd.MM.yy"
    }
    var body: some View {
        VStack {
            getSortPicker()
            HStack {
                Text("Instrument")
                    .font(.system(size: 12, design: .default))
                    .frame(minWidth: 0, maxWidth: .infinity)
                Text("Price")
                    .font(.system(size: 12, design: .default))
                    .frame(minWidth: 0, maxWidth: .infinity)
                Text("Amount")
                    .font(.system(size: 12, design: .default))
                    .frame(minWidth: 0, maxWidth: .infinity)
                Text("Side")
                    .font(.system(size: 12, design: .default))
                    .frame(minWidth: 0, maxWidth: .infinity)
            }
            .padding(.horizontal, 10)
            .padding(7)
            .background(colorScheme == .dark ? .black : .white)
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.deals, id: \.id) { deal in
                                VStack {
                                    Text("\(deal.dateModifier, formatter: dateFormatter)")
                                        .font(.system(size: 12, design: .default))
                                        .foregroundColor(.gray)
                                        .frame(maxWidth: .infinity, maxHeight: 30 ,alignment: .leading)
                                        .padding(.horizontal, 20)
                                    Spacer()
                                    HStack {
                                        Text(deal.instrumentName.removeChars)
                                            .font(.system(size: 12, design: .default))
                                            .frame(maxWidth: .infinity)
                                        Text(String(format: "%.2f", deal.price))
                                            .font(.system(size: 12, design: .default))
                                            .frame(maxWidth: .infinity)
                                        Text("\(Int(deal.amount).formattedWithSeparator)")
                                            .font(.system(size: 12, design: .default))
                                            .frame(maxWidth: .infinity)
                                        Text(deal.side == .buy ? "Buy" : "Sell")
                                            .font(.system(size: 12, design: .default))
                                            .frame(maxWidth: .infinity)
                                            .foregroundColor(deal.side == .buy ? .green : .red)
                                    }
                                    .frame(maxHeight: 30 ,alignment: .leading)
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                                }
                                .background(RoundedRectangle(cornerRadius: 20))
                                .foregroundColor(Color("Background"))
                                .shadow(color: Color("LightShadow"), radius: 8, x: -8, y: -8)
                                .shadow(color: Color("DarkShadow"), radius: 8, x: 8, y: 8)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 10)
                                    .frame(height: 100)
                    }
                }
             
            }
            .onAppear {
                viewModel.startDealsPipe()
            }
            
        }
        .background(Color("Background"))
    }
}

struct DealsView_Previews: PreviewProvider {
    static var previews: some View {
        DealsView()
    }
}

extension DealsView {
    func getSortPicker() -> some View {
        HStack {
            Picker("Select number", selection: $viewModel.model.pickerSelection) {
                Text("Сортировка по дате изменения сделки").tag(SortType.date)
                Text("Сортировка по имени инструмента").tag(SortType.name)
                Text("Сортировка по цене сделки").tag(SortType.price)
                Text("Сортировка по объему сделки").tag(SortType.amount)
                Text("Сортировка по стороне сделки").tag(SortType.side)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .pickerStyle(MenuPickerStyle())
        .labelsHidden()
    }
}
extension String {
    var removeChars: String {
        var str = self
        str = str.components(separatedBy: ("_"))[0]
        str = str.filter { $0 != "/" }
            return str
        }
    }
extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        return formatter
    }()
}
extension Numeric {
    var formattedWithSeparator: String { Formatter.withSeparator.string(for: self) ?? "" }
}

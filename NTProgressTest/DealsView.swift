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
        dateFormatter.dateFormat = "HH:mm:ss dd.MM.yy"
    }
    var body: some View {
        NavigationView {
            ZStack {
                Color("Background").edgesIgnoringSafeArea(.all)
                VStack {
                    PanelUpperLine()
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
                    .offset(y: -8)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Menu {
                            ForEach(SortType.allCases, id: \.self) { option in
                                Button(option.rawValue) {
                                    viewModel.selectedSortingOption = option
                                }
                            }
                        } label: {
                            Image(systemName: "arrow.up.arrow.down")
                        }
                    }
                }
            }
            .navigationBarTitle("Deals")
        }
        .background(Color("Background"))
        .onAppear {
            viewModel.startDealsPipe()
        }
        .environmentObject(viewModel)
    }
}

struct DealsView_Previews: PreviewProvider {
    static var previews: some View {
        DealsView()
    }
}


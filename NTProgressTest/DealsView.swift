//
//  ContentView.swift
//  NTProgressTest
//
//  Created by Denis Zhesterev on 07.03.2023.
//

import SwiftUI
import Foundation

struct DealsView: View, Equatable {
    static func == (lhs: DealsView, rhs: DealsView) -> Bool {
        return true
    }
    @State private var isLoading = true
    let columns = [GridItem(.flexible())]
    @StateObject var viewModel = DealsViewModel()
    var body: some View {
        NavigationView {
            ZStack {
                Color("Background").edgesIgnoringSafeArea(.all)
                VStack {
                    PanelUpperLine()
                    ScrollView {
                        LazyVGrid(columns: columns) {
                            ForEach(viewModel.deals, id: \.id) { deal in
                                CardView(deal: deal)
                                    .equatable()
                                    
                            }
                        }
                        .id(UUID())
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


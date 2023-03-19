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
    let columns = [GridItem(.flexible())]
    var body: some View {
        ZStack{
            NavigationView {
                ZStack {
                    Color("Background").edgesIgnoringSafeArea(.all)
                    VStack {
                        PanelUpperLine()
                        ScrollView {
                            LazyVGrid(columns: columns) {
                                ForEach(viewModel.deals, id: \.id) { deal in
                                    CardView(deal: deal)
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
            if viewModel.isPaused == true {
                ZStack{
                    LoadingCircle()
                    Text(" ")
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        .background(Color.black)
                        .edgesIgnoringSafeArea(.all)
                        .opacity(0.2)
                }
            }
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


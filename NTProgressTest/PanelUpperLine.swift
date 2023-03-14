//
//  TextUpperLine.swift
//  NTProgressTest
//
//  Created by Denis Zhesterev on 10.03.2023.
//

import SwiftUI

struct PanelUpperLine: View {
    @EnvironmentObject var viewModel: DealsViewModel
    var body: some View {
        HStack {
            HStack {
                Text("Instrument")
                    .font(.system(size: 9.5, design: .default))
                    .foregroundColor(.blue)
                if viewModel.model.destinationArrow {
                    Image(systemName: "arrow.up")
                        .resizable()
                        .frame(width: 6, height: 8)
                        .foregroundColor(.green)
                        .opacity(viewModel.model.selectedSortingOption == .name ? 100 : 0)
                } else {
                    Image(systemName: "arrow.down")
                        .resizable()
                        .frame(width: 6, height: 8)
                        .foregroundColor(.red)
                        .opacity(viewModel.model.selectedSortingOption == .name ? 100 : 0)
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .onTapGesture {
                if viewModel.model.destinationArrow {
                    viewModel.sortingMethod = viewModel.nameSortDown
                }
                else {
                    viewModel.sortingMethod = viewModel.nameSortUp
                }
                viewModel.model.selectedSortingOption = .name
                viewModel.model.destinationArrow.toggle()
            }
            HStack {
                Text("Price")
                    .font(.system(size: 9.5, design: .default))
                    .foregroundColor(.blue)
                if viewModel.model.destinationArrow {
                    Image(systemName: "arrow.up")
                        .resizable()
                        .frame(width: 6, height: 8)
                        .foregroundColor(.green)
                        .opacity(viewModel.model.selectedSortingOption == .price ? 100 : 0)
                } else {
                    Image(systemName: "arrow.down")
                        .resizable()
                        .frame(width: 6, height: 8)
                        .foregroundColor(.red)
                        .opacity(viewModel.model.selectedSortingOption == .price ? 100 : 0)
                }
            }
            .padding(0)
            .frame(minWidth: 0, maxWidth: .infinity)
            .onTapGesture {
                if viewModel.model.destinationArrow {
                    viewModel.sortingMethod = viewModel.priceSortDown
                }
                else {
                    viewModel.sortingMethod = viewModel.priceSortUp
                }
                viewModel.model.selectedSortingOption = .price
                viewModel.model.destinationArrow.toggle()
            }
            HStack {
                Text("Amount")
                    .font(.system(size: 9.5, design: .default))
                    .foregroundColor(.blue)
                if viewModel.model.destinationArrow {
                    Image(systemName: "arrow.up")
                        .resizable()
                        .frame(width: 6, height: 8)
                        .foregroundColor(.green)
                        .opacity(viewModel.model.selectedSortingOption == .amount ? 100 : 0)
                } else {
                    Image(systemName: "arrow.down")
                        .resizable()
                        .frame(width: 6, height: 8)
                        .foregroundColor(.red)
                        .opacity(viewModel.model.selectedSortingOption == .amount ? 100 : 0)
                }
            }
            .padding(0)
            .frame(minWidth: 0, maxWidth: .infinity)
            .onTapGesture {
                if viewModel.model.destinationArrow {
                    viewModel.sortingMethod = viewModel.amountSortDown
                }
                else {
                    viewModel.sortingMethod = viewModel.amountSortUp
                }
                viewModel.model.selectedSortingOption = .amount
                viewModel.model.destinationArrow.toggle()
            }
            HStack {
                Text("Side")
                    .font(.system(size: 9.5, design: .default))
                    .foregroundColor(.blue)
                if viewModel.model.destinationArrow {
                    Image(systemName: "arrow.up")
                        .resizable()
                        .frame(width: 6, height: 8)
                        .foregroundColor(.green)
                        .opacity(viewModel.model.selectedSortingOption == .side ? 100 : 0)
                } else {
                    Image(systemName: "arrow.down")
                        .resizable()
                        .frame(width: 6, height: 8)
                        .foregroundColor(.red)
                        .opacity(viewModel.model.selectedSortingOption == .side ? 100 : 0)
                }
            }
            .padding(0)
            .frame(minWidth: 0, maxWidth: .infinity)
            .onTapGesture {
                if viewModel.model.destinationArrow {
                    viewModel.sortingMethod = viewModel.sideSortUp
                }
                else {
                    viewModel.sortingMethod = viewModel.sideSortDown
                }
                viewModel.model.selectedSortingOption = .side
                viewModel.model.destinationArrow.toggle()
            }
        }
        .padding(.horizontal, 10)
        .padding(7)
        .background(Color("Panel"))
    }
}

struct PanelUpperLine_Previews: PreviewProvider {
    static var previews: some View {
        PanelUpperLine()
    }
}

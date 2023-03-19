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
            ZStack {
                Spacer()
                HStack {
                    Text("Date")
                        .font(.system(size: 9.5, design: .default))
                        .foregroundColor(.blue)
                    if viewModel.destinationArrow {
                        Image(systemName: "arrow.up")
                            .resizable()
                            .frame(width: 6, height: 8)
                            .foregroundColor(.green)
                            .opacity(viewModel.selectedSortingOption == .date ? 100 : 0)
                    } else {
                        Image(systemName: "arrow.down")
                            .resizable()
                            .frame(width: 6, height: 8)
                            .foregroundColor(.red)
                            .opacity(viewModel.selectedSortingOption == .date ? 100 : 0)
                    }
                }
            }
            .onTapGesture {
                DispatchQueue.main.async { [self] in
                    if viewModel.destinationArrow {
                        viewModel.sortingMethod = viewModel.dataSortDown
                    }
                    else {
                        viewModel.sortingMethod = viewModel.dataSortUp
                    }
                    viewModel.selectedSortingOption = .date
                    viewModel.destinationArrow.toggle()
                }
            }
            Spacer()
            ZStack {
                HStack {
                    Text("Instrument")
                        .font(.system(size: 9.5, design: .default))
                        .foregroundColor(.blue)
                    if viewModel.destinationArrow {
                        Image(systemName: "arrow.up")
                            .resizable()
                            .frame(width: 6, height: 8)
                            .foregroundColor(.green)
                            .opacity(viewModel.selectedSortingOption == .name ? 100 : 0)
                    } else {
                        Image(systemName: "arrow.down")
                            .resizable()
                            .frame(width: 6, height: 8)
                            .foregroundColor(.red)
                            .opacity(viewModel.selectedSortingOption == .name ? 100 : 0)
                    }
                }
            }
            .onTapGesture {
                DispatchQueue.main.async { [self] in
                    if viewModel.destinationArrow {
                        viewModel.sortingMethod = viewModel.nameSortDown
                    }
                    else {
                        viewModel.sortingMethod = viewModel.nameSortUp
                    }
                    viewModel.selectedSortingOption = .name
                    viewModel.destinationArrow.toggle()
                }
            }
            Spacer()
            
            ZStack {
                HStack {
                    Text("Price")
                        .font(.system(size: 9.5, design: .default))
                        .foregroundColor(.blue)
                    if viewModel.destinationArrow {
                        Image(systemName: "arrow.up")
                            .resizable()
                            .frame(width: 6, height: 8)
                            .foregroundColor(.green)
                            .opacity(viewModel.selectedSortingOption == .price ? 100 : 0)
                    } else {
                        Image(systemName: "arrow.down")
                            .resizable()
                            .frame(width: 6, height: 8)
                            .foregroundColor(.red)
                            .opacity(viewModel.selectedSortingOption == .price ? 100 : 0)
                    }
                }
            }
            .onTapGesture {
                DispatchQueue.main.async { [self] in
                    if viewModel.destinationArrow {
                        viewModel.sortingMethod = viewModel.priceSortDown
                    }
                    else {
                        viewModel.sortingMethod = viewModel.priceSortUp
                    }
                    viewModel.selectedSortingOption = .price
                    viewModel.destinationArrow.toggle()
                }
            }
            Spacer()
            ZStack {
                HStack {
                    Text("Amount")
                        .font(.system(size: 9.5, design: .default))
                        .foregroundColor(.blue)
                    if viewModel.destinationArrow {
                        Image(systemName: "arrow.up")
                            .resizable()
                            .frame(width: 6, height: 8)
                            .foregroundColor(.green)
                            .opacity(viewModel.selectedSortingOption == .amount ? 100 : 0)
                    } else {
                        Image(systemName: "arrow.down")
                            .resizable()
                            .frame(width: 6, height: 8)
                            .foregroundColor(.red)
                            .opacity(viewModel.selectedSortingOption == .amount ? 100 : 0)
                    }
                }
            }
            .onTapGesture {
                DispatchQueue.main.async { [self] in
                    if viewModel.destinationArrow {
                        viewModel.sortingMethod = viewModel.amountSortDown
                    }
                    else {
                        viewModel.sortingMethod = viewModel.amountSortUp
                    }
                    viewModel.selectedSortingOption = .amount
                    viewModel.destinationArrow.toggle()
                }
            }
            Spacer()
            ZStack {
                HStack {
                    Text("Side")
                        .font(.system(size: 9.5, design: .default))
                        .foregroundColor(.blue)
                    if viewModel.destinationArrow {
                        Image(systemName: "arrow.up")
                            .resizable()
                            .frame(width: 6, height: 8)
                            .foregroundColor(.green)
                            .opacity(viewModel.selectedSortingOption == .side ? 100 : 0)
                    } else {
                        Image(systemName: "arrow.down")
                            .resizable()
                            .frame(width: 6, height: 8)
                            .foregroundColor(.red)
                            .opacity(viewModel.selectedSortingOption == .side ? 100 : 0)
                    }
                }
            }
            .onTapGesture {
                DispatchQueue.main.async { [self] in
                    if viewModel.destinationArrow {
                        viewModel.sortingMethod = viewModel.sideSortUp
                    }
                    else {
                        viewModel.sortingMethod = viewModel.sideSortDown
                    }
                    viewModel.selectedSortingOption = .side
                    viewModel.destinationArrow.toggle()
                }
            }
            Spacer()
        }
        .padding(7)
        .background(Color("Panel"))
    }
}

struct PanelUpperLine_Previews: PreviewProvider {
    static var previews: some View {
        PanelUpperLine()
    }
}

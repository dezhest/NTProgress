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
            typeAndArrow(type: "Date", typeValueEnum: .date)
            .onTapGesture {
                viewModel.changeTypeByTap(ComparedSortType.dateSortUp, ComparedSortType.dateSortDown)
                viewModel.selectedSortingOption = .date
                viewModel.destinationArrow.toggle()
            }
            Spacer()
            typeAndArrow(type: "Instrument", typeValueEnum: .name)
            .onTapGesture {
                viewModel.changeTypeByTap(ComparedSortType.nameSortUp, ComparedSortType.nameSortDown)
                viewModel.selectedSortingOption = .name
                viewModel.destinationArrow.toggle()
            }
            Spacer()
            typeAndArrow(type: "Price", typeValueEnum: .price)
            .onTapGesture {
                viewModel.changeTypeByTap(ComparedSortType.priceSortUp, ComparedSortType.priceSortDown)
                viewModel.selectedSortingOption = .price
                viewModel.destinationArrow.toggle()
            }
            Spacer()
            typeAndArrow(type: "Amount", typeValueEnum: .amount)
            .onTapGesture {
                viewModel.changeTypeByTap(ComparedSortType.amountSortUp, ComparedSortType.amountSortDown)
                viewModel.selectedSortingOption = .amount
                viewModel.destinationArrow.toggle()
            }
            Spacer()
            typeAndArrow(type: "Side", typeValueEnum: .side)
            .onTapGesture {
                viewModel.changeTypeByTap(ComparedSortType.sideSortDown, ComparedSortType.sideSortUp)
                viewModel.selectedSortingOption = .side
                viewModel.destinationArrow.toggle()
            }
            Spacer()
        }
        .padding(7)
        .background(Color("Panel"))
    }
    @ViewBuilder
    func typeAndArrow(type: String, typeValueEnum: SortType) -> some View {
        ZStack {
            Spacer()
            HStack {
                Text(type)
                    .font(.system(size: 12, design: .default))
                    .foregroundColor(.blue)
                if viewModel.destinationArrow {
                    Image(systemName: "arrow.up")
                        .resizable()
                        .frame(width: 8, height: 10)
                        .foregroundColor(.green)
                        .opacity(viewModel.selectedSortingOption == typeValueEnum ? 100 : 0)
                        .offset(x: -5)
                } else {
                    Image(systemName: "arrow.down")
                        .resizable()
                        .frame(width: 8, height: 10)
                        .foregroundColor(.red)
                        .opacity(viewModel.selectedSortingOption == typeValueEnum ? 100 : 0)
                        .offset(x: -5)
                }
                    
            }
        }
    }
}

struct PanelUpperLine_Previews: PreviewProvider {
    static var previews: some View {
        PanelUpperLine()
    }
}

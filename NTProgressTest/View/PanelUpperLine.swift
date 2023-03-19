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
                viewModel.changeTypeByTap(viewModel.model.dataSortUp, viewModel.model.dataSortDown)
                viewModel.model.selectedSortingOption = .date
                viewModel.model.destinationArrow.toggle()
            }
            Spacer()
            typeAndArrow(type: "Instrument", typeValueEnum: .name)
            .onTapGesture {
                viewModel.changeTypeByTap(viewModel.model.nameSortUp, viewModel.model.nameSortDown)
                viewModel.model.selectedSortingOption = .name
                viewModel.model.destinationArrow.toggle()
            }
            Spacer()
            typeAndArrow(type: "Price", typeValueEnum: .price)
            .onTapGesture {
                viewModel.changeTypeByTap(viewModel.model.priceSortUp, viewModel.model.priceSortDown)
                viewModel.model.selectedSortingOption = .price
                viewModel.model.destinationArrow.toggle()
            }
            Spacer()
            typeAndArrow(type: "Amount", typeValueEnum: .amount)
            .onTapGesture {
                viewModel.changeTypeByTap(viewModel.model.amountSortUp, viewModel.model.amountSortDown)
                viewModel.model.selectedSortingOption = .amount
                viewModel.model.destinationArrow.toggle()
            }
            Spacer()
            typeAndArrow(type: "Side", typeValueEnum: .side)
            .onTapGesture {
                viewModel.changeTypeByTap(viewModel.model.sideSortDown, viewModel.model.sideSortUp)
                viewModel.model.selectedSortingOption = .side
                viewModel.model.destinationArrow.toggle()
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
                if viewModel.model.destinationArrow {
                    Image(systemName: "arrow.up")
                        .resizable()
                        .frame(width: 8, height: 10)
                        .foregroundColor(.green)
                        .opacity(viewModel.model.selectedSortingOption == typeValueEnum ? 100 : 0)
                        .offset(x: -5)
                } else {
                    Image(systemName: "arrow.down")
                        .resizable()
                        .frame(width: 8, height: 10)
                        .foregroundColor(.red)
                        .opacity(viewModel.model.selectedSortingOption == typeValueEnum ? 100 : 0)
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

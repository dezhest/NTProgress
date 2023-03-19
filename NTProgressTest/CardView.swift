//
//  CardView.swift
//  NTProgressTest
//
//  Created by Denis Zhesterev on 17.03.2023.
//

import SwiftUI

struct CardView: View {
    var deal: Deal
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack {
            Text("\(deal.dateModifier.formattedString())")
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
            .frame(maxHeight: 30 ,alignment: .trailing)
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
extension CardView: Equatable {
  static func == (lhs: CardView, rhs: CardView) -> Bool {
      return lhs.deal.dateModifier == rhs.deal.dateModifier &&
      lhs.deal.price == rhs.deal.price &&
      lhs.deal.amount == rhs.deal.amount &&
      lhs.deal.side == rhs.deal.side &&
      lhs.deal.instrumentName == rhs.deal.instrumentName &&
      lhs.deal.id == rhs.deal.id
  }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(deal: Deal(id: Int64(), dateModifier: Date(), instrumentName: String(), price: Double(), amount: Double(), side: .sell))
    }
}

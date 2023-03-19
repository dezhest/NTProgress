//
//  LoadingCircle.swift
//  NTProgressTest
//
//  Created by Denis Zhesterev on 19.03.2023.
//

import SwiftUI

struct LoadingCircle: View {
    @State private var isLoading = false
    @State private var rotationAngle: Angle = .degrees(0)
    @State var rotation = 0
    let screenSize = UIScreen.main.bounds
    var body: some View {
        VStack {
            Circle()
                .trim(from: 0, to: 0.7)
                .stroke(Color.blue, lineWidth: 10)
                .frame(width: 80, height: 80)
                .rotationEffect(Angle(degrees: isLoading ? 36000 : 0))
                .animation(.linear(duration: 100), value: rotation)
        }
        .onAppear {
            self.isLoading = true
            rotation += 36000
        }
        .onDisappear {
            self.isLoading = false
        }
    }
}




struct LoadingCircle_Previews: PreviewProvider {
    static var previews: some View {
        LoadingCircle()
    }
}

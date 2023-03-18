import SwiftUI

struct ContentView: View {
    @State private var rotation: Double = 0.0
    
    var body: some View {
        Rectangle()
            .frame(width: 100, height: 100)
            .foregroundColor(.blue)
            .rotationEffect(Angle(degrees: rotation))
            .animation(.linear(duration: 1.0).repeatForever(autoreverses: false))
            .onAppear {
                self.rotation = 360.0
            }
    }
}

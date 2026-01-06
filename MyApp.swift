import SwiftUI

struct ContentView: View {
    var body: some View {
        Circle()
        .fill(.blue)
        .padding()
        .overlay(
            Image(systemName: "figure.basketball")
                .font(.system(size: 144))
                .foregroundColor(.white)
        )
    }
}

struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

MyApp.main()
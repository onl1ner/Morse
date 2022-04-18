import SwiftUI

@main
struct MyApp: App {
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

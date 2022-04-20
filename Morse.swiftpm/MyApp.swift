import SwiftUI

@main
struct MyApp: App {
    init() {
        // Setting container inset to .zero gives
        // no effect, so I had to guesstimate the
        // values to remove unwanted padding around
        // text view.
        UITextView.appearance().textContainerInset = .init(
            top: -5.0,
            left: -5.0,
            bottom: 0.0,
            right: 5.0
        )
        
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(translator: .init())
        }
    }
}

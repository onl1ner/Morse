import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                
            }
            .navigationTitle("Morse")
            .toolbar {
                Image(systemName: "questionmark.circle.fill")
                    .foregroundColor(.accentColor)
            }
        }
    }
}

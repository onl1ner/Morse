import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                
            }
            .navigationTitle("Morze")
            .toolbar {
                Image(systemName: "questionmark.circle.fill")
                    .foregroundColor(.accentColor)
            }
        }
    }
}

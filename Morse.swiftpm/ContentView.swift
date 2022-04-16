import SwiftUI

struct ContentView: View {
    @State private var languagePair: LanguagePair = .init(
        leftItem: .english,
        rightItem: .morse
    )
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    LanguagePairView(languagePair: self.$languagePair)
                        .frame(maxWidth: .infinity)
                }
                .padding(.all, 16.0)
            }
            .navigationTitle("Translator")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

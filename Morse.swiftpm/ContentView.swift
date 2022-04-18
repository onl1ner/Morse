import SwiftUI

struct ContentView: View {
    @State private var languagePair: LanguagePair = .init(
        leftItem: .english,
        rightItem: .morse
    )
    
    @State private var isTranslatable: Bool = false
    @State private var originText: String = ""
    
    let translator: MorseTranslator
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                VStack(spacing: 16.0) {
                    LanguagePairView(languagePair: self.$languagePair)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 16.0)
                    
                    VStack(alignment: .leading) {
                        VStack(alignment: .trailing) {
                            if self.isTranslatable {
                                Button {
                                    self.originText = ""
                                } label: {
                                    Image(systemName: "trash")
                                        .font(.system(size: 18.0))
                                        .foregroundColor(.accentColor)
                                }
                            }
                            
                            TextView(placeholder: "Enter text", text: self.$originText)
                                .frame(height: 300.0)
                        }
                        
                        Spacer()
                    }
                    .padding(16.0)
                    .frame(maxHeight: .infinity)
                    .background(Color.secondarySystemBackground)
                    .cornerRadius(16.0, corners: [.topLeft, .topRight])
                    .ignoresSafeArea(.all, edges: .bottom)
                }
                
                if self.isTranslatable {
                    Button {
                        
                    } label: {
                        Text("Translate!")
                            .font(.headline)
                            .padding(8.0)
                            .foregroundColor(.white)
                            .background(Color.accentColor)
                            .cornerRadius(8.0)
                    }
                    .padding(.bottom, 16.0)
                    .transition(.opacity)
                    .zIndex(1.0)
                }
            }
            .padding(.top, 16.0)
            .navigationTitle("Morse Translator")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
        .onChange(of: self.originText) { text in
            withAnimation {
                self.isTranslatable = !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            }
        }
    }
}

import SwiftUI

struct ContentView: View {
    @State private var languagePair: LanguagePair = .init(
        leftItem: .english,
        rightItem: .morse
    )
    
    @State private var isTranslatable: Bool = false
    @State private var originText: String = ""
    @State private var translation: MorseTranslation?
    
    @FocusState private var isEditing: Bool
    
    let translator: MorseTranslator
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                VStack(spacing: 16.0) {
                    LanguagePairView(languagePair: self.$languagePair)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 16.0)
                    
                    VStack(alignment: .trailing) {
                        if self.isTranslatable {
                            Button {
                                withAnimation {
                                    self.originText = ""
                                    self.translation = nil
                                    self.isEditing = false
                                }
                            } label: {
                                Image(systemName: "trash")
                                    .font(.system(size: 18.0))
                                    .foregroundColor(.accentColor)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 16.0) {
                            VStack(alignment: .leading) {
                                if self.translation != nil {
                                    Text("From \(self.languagePair.leftItem.rawValue)")
                                        .font(.headline)
                                        .foregroundColor(.secondaryLabel)
                                        .transition(.opacity)
                                }
                                
                                TextView(
                                    placeholder: "Enter text",
                                    text: self.$originText,
                                    focus: _isEditing
                                )
                            }
                            
                            if let translation = translation {
                                Group {
                                    Divider()
                                    
                                    ScrollView(showsIndicators: false) {
                                        VStack(alignment: .leading) {
                                            Text("To \(self.languagePair.rightItem.rawValue)")
                                                .font(.headline)
                                                .foregroundColor(.secondaryLabel)
                                            
                                            Text(translation.translatedText)
                                                .font(.system(size: 32.0, weight: .bold))
                                        }
                                    }
                                }
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(16.0)
                    .frame(maxHeight: .infinity)
                    .background(Color.secondarySystemBackground)
                    .cornerRadius(16.0, corners: [.topLeft, .topRight])
                    .ignoresSafeArea(.all, edges: .bottom)
                }
                
                if self.isTranslatable && self.translation == nil {
                    Button {
                        withAnimation {
                            self.translation = self.translator.translate(
                                text: self.originText,
                                from: self.languagePair.leftItem,
                                to: self.languagePair.rightItem
                            )
                            
                            self.isEditing = false
                        }
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
        .onChange(of: self.isEditing) { isEditing in
            if isEditing {
                withAnimation {
                    self.translation = nil
                }
            }
        }
    }
}

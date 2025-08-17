import SwiftUI

public struct GameView: View {
    @State private var viewModel = GameGridViewModel()
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Grid Display
                VStack(spacing: 2) {
                    ForEach(0..<viewModel.rows, id: \.self) { row in
                        HStack(spacing: 2) {
                            ForEach(0..<viewModel.columns, id: \.self) { column in
                                GridTileView(
                                    character: viewModel.character(at: row, column: column),
                                    isEmpty: viewModel.isEmpty(at: row, column: column),
                                    onTap: {
                                        handleTileTap(row: row, column: column)
                                    }
                                )
                            }
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                
                // Game Info
                VStack(alignment: .leading, spacing: 8) {
                    Text("Game Status")
                        .font(.headline)
                    
                    HStack {
                        Text("Characters: \(viewModel.characterCount)")
                        Spacer()
                        Text("Empty: \(viewModel.emptyPositions.count)")
                    }
                    
                    HStack {
                        Text("Grid Full: \(viewModel.isFull ? "Yes" : "No")")
                        Spacer()
                        Text("Grid Empty: \(viewModel.isEmpty ? "Yes" : "No")")
                    }
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
                
                // Action Buttons
                VStack(spacing: 12) {
                    Button("Run Demo") {
                        runDemo()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("Clear Grid") {
                        viewModel.clearGrid()
                    }
                    .buttonStyle(.bordered)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Lil48 Game")
        }
    }
    
    private func handleTileTap(row: Int, column: Int) {
        if viewModel.isEmpty(at: row, column: column) {
            // Place a random character
            let characters: [GameCharacter] = [
                .coolKittyKate, .bullyBob, .quickRick, 
                .snifflingSteve, .principalYavno, .superCoolKittyKate
            ]
            let randomCharacter = characters.randomElement() ?? .coolKittyKate
            viewModel.placeCharacter(randomCharacter, at: row, column: column)
        } else {
            // Remove character
            viewModel.removeCharacter(at: row, column: column)
        }
    }
    
    private func runDemo() {
        viewModel.clearGrid()
        // Place some demo characters
        viewModel.placeCharacter(.coolKittyKate, at: 0, column: 0)
        viewModel.placeCharacter(.bullyBob, at: 1, column: 1)
    }
}

private struct GridTileView: View {
    let character: GameCharacter?
    let isEmpty: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Rectangle()
                .fill(tileColor)
                .frame(width: 80, height: 80)
                .overlay(
                    Text(tileText)
                        .font(.caption)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                )
                .cornerRadius(4)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var tileColor: Color {
        guard let character = character else { return .gray.opacity(0.3) }
        
        switch character {
        case .coolKittyKate: return .pink
        case .bullyBob: return .red
        case .quickRick: return .green
        case .snifflingSteve: return .blue
        case .principalYavno: return .purple
        case .superCoolKittyKate: return .orange
        }
    }
    
    private var tileText: String {
        guard let character = character else { return "Empty" }
        
        switch character {
        case .coolKittyKate: return "Cool\nKitty\nKate"
        case .bullyBob: return "Bully\nBob"
        case .quickRick: return "Quick\nRick"
        case .snifflingSteve: return "Sniffling\nSteve"
        case .principalYavno: return "Principal\nYavno"
        case .superCoolKittyKate: return "Super\nCool\nKitty"
        }
    }
}

// Preview disabled for Swift Package Manager builds
// #Preview {
//     GameView()
// }
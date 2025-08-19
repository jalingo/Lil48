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
                                    character: viewModel.character(row: row, column: column),
                                    isEmpty: viewModel.isEmpty(row: row, column: column)
                                )
                            }
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                .gesture(
                    DragGesture(minimumDistance: 50)
                        .onEnded { value in
                            handleSwipe(value)
                        }
                )
                .overlay(
                    GameStateOverlay(
                        gameState: viewModel.gameState,
                        onNewGame: {
                            viewModel.startNewGame()
                        }
                    )
                )
                
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
                    if viewModel.isEmpty {
                        Button("Start Game") {
                            viewModel.spawnInitialCharacter()
                        }
                        .buttonStyle(.bordered)
                    }
                    
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
    
    private func handleSwipe(_ value: DragGesture.Value) {
        let horizontalMovement = value.translation.width
        let verticalMovement = value.translation.height
        
        if abs(horizontalMovement) > abs(verticalMovement) {
            if horizontalMovement > 0 {
                _ = viewModel.moveCharacters(direction: .right)
            } else {
                _ = viewModel.moveCharacters(direction: .left)
            }
        } else {
            if verticalMovement > 0 {
                _ = viewModel.moveCharacters(direction: .down)
            } else {
                _ = viewModel.moveCharacters(direction: .up)
            }
        }
    }
}

private struct GridTileView: View {
    let character: GameCharacter?
    let isEmpty: Bool
    
    var body: some View {
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

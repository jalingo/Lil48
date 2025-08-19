import SwiftUI

public struct GameStateOverlay: View {
    let gameState: GameState
    let onNewGame: () -> Void
    
    public init(gameState: GameState, onNewGame: @escaping () -> Void) {
        self.gameState = gameState
        self.onNewGame = onNewGame
    }
    
    public var body: some View {
        if gameState != .playing {
            ZStack {
                Color.black.opacity(0.8)
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    Text(overlayTitle)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(overlayMessage)
                        .font(.title2)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Button("Play Again") {
                        onNewGame()
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(gameState == .victory ? Color.green : Color.red)
                    .cornerRadius(12)
                }
                .padding()
            }
        }
    }
    
    public var overlayTitle: String {
        switch gameState {
        case .victory: return "You Won!"
        case .loss: return "Game Over"
        case .playing: return ""
        }
    }
    
    public var overlayMessage: String {
        switch gameState {
        case .victory: return "Congratulations!\nYou cleared the entire grid!"
        case .loss: return "No more moves available.\nTry again!"
        case .playing: return ""
        }
    }
}
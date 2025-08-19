import Testing
import SwiftUI
@testable import Lil48

@Suite("GameStateOverlay Component Tests")
struct GameStateOverlayTests {
    
    @Test("Overlay shows victory message when game is won")
    @MainActor func victoryGame_overlayRendered_showsVictoryMessage() {
        let overlay = GameStateOverlay(gameState: .victory, onNewGame: {})
        
        #expect(overlay.overlayTitle == "You Won!")
        #expect(overlay.overlayMessage.contains("Congratulations"))
    }
    
    @Test("Overlay shows loss message when game is over")
    @MainActor func lossGame_overlayRendered_showsLossMessage() {
        let overlay = GameStateOverlay(gameState: .loss, onNewGame: {})
        
        #expect(overlay.overlayTitle == "Game Over")
        #expect(overlay.overlayMessage.contains("No more moves"))
    }
    
    @Test("Overlay shows empty strings when game is playing")
    @MainActor func playingGame_overlayQueried_returnsEmptyStrings() {
        let overlay = GameStateOverlay(gameState: .playing, onNewGame: {})
        
        #expect(overlay.overlayTitle == "")
        #expect(overlay.overlayMessage == "")
    }
    
    @Test("Overlay triggers new game callback when button would be pressed")
    @MainActor func overlayButton_callback_triggersNewGameCallback() {
        var newGameCalled = false
        let overlay = GameStateOverlay(gameState: .victory, onNewGame: {
            newGameCalled = true
        })
        
        overlay.onNewGame()
        
        #expect(newGameCalled == true)
    }
}
// Lil48 Game Library
// Character-based puzzle game with dynamic grid expansion

import Foundation
import SwiftUI

/// Main entry point for the Lil48 game library
public struct Lil48 {
    
    /// Current version of the Lil48 game
    public static let version = "1.0.0"
    
    /// Initialize the Lil48 game library
    public init() {}
}

// Export main components for easy access
public typealias Game = GameView
public typealias ViewModel = GameGridViewModel
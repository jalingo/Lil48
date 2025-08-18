import SwiftUI

@Observable
public class GameGridViewModel {
    private var gameGrid = GameGrid()
    
    public init() {}
    
    public var rows: Int { gameGrid.rows }
    public var columns: Int { gameGrid.columns }
    
    public func character(at row: Int, column: Int) -> GameCharacter? {
        let position = GridPosition(row: row, column: column)
        return try? gameGrid.character(at: position)
    }
    
    public func isEmpty(at row: Int, column: Int) -> Bool {
        let position = GridPosition(row: row, column: column)
        return (try? gameGrid.isEmpty(at: position)) ?? false
    }
    
    public func placeCharacter(_ character: GameCharacter, at row: Int, column: Int) {
        let position = GridPosition(row: row, column: column)
        try? gameGrid.place(character, at: position)
    }
    
    // MARK: - GREEN PHASE: Minimal implementations to make tests pass
    
    /// 1. isEmpty property - computed property that returns true when grid has no characters
    public var isEmpty: Bool {
        for row in 0..<rows {
            for column in 0..<columns {
                if !isEmpty(at: row, column: column) {
                    return false
                }
            }
        }
        return true
    }
    
    /// 2. isFull property - computed property that returns true when all positions occupied
    public var isFull: Bool {
        for row in 0..<rows {
            for column in 0..<columns {
                if isEmpty(at: row, column: column) {
                    return false
                }
            }
        }
        return true
    }
    
    /// 3. characterCount property - computed property returning total number of characters
    public var characterCount: Int {
        var count = 0
        for row in 0..<rows {
            for column in 0..<columns {
                if !isEmpty(at: row, column: column) {
                    count += 1
                }
            }
        }
        return count
    }
    
    /// 4. gridSummary property - computed property returning debug string representation
    public var gridSummary: String {
        var summary = "\(rows)x\(columns) Grid:\n"
        for row in 0..<rows {
            for column in 0..<columns {
                if let character = character(at: row, column: column) {
                    summary += "\(character) "
                } else {
                    summary += "[ ] "
                }
            }
            summary += "\n"
        }
        return summary
    }
    
    /// 5. emptyPositions property - computed property returning [(Int, Int)] of empty coordinates
    public var emptyPositions: [(row: Int, column: Int)] {
        var positions: [(row: Int, column: Int)] = []
        for row in 0..<rows {
            for column in 0..<columns {
                if isEmpty(at: row, column: column) {
                    positions.append((row: row, column: column))
                }
            }
        }
        return positions
    }
    
    /// 6. occupiedPositions property - computed property returning [(Int, Int)] of occupied coordinates
    public var occupiedPositions: [(row: Int, column: Int)] {
        var positions: [(row: Int, column: Int)] = []
        for row in 0..<rows {
            for column in 0..<columns {
                if !isEmpty(at: row, column: column) {
                    positions.append((row: row, column: column))
                }
            }
        }
        return positions
    }
    
    /// 7. removeCharacter(at row: Int, column: Int) method - removes character from position
    public func removeCharacter(at row: Int, column: Int) {
        let position = GridPosition(row: row, column: column)
        try? gameGrid.removeCharacter(at: position)
    }
    
    /// 8. clearGrid() method - removes all characters from grid
    public func clearGrid() {
        for row in 0..<rows {
            for column in 0..<columns {
                removeCharacter(at: row, column: column)
            }
        }
    }
    
    /// 9. moveCharacters(direction:) method - executes movement in specified direction
    public func moveCharacters(direction: MovementDirection) -> Bool {
        gameGrid.move(direction: direction)
    }
    
    /// 10. spawnInitialCharacter() method - spawns first character to start game
    public func spawnInitialCharacter() {
        _ = gameGrid.spawnInitialCharacter()
    }
}
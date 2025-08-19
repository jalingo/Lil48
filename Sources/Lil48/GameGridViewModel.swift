import SwiftUI

@Observable
public class GameGridViewModel {
    private var gameGrid = GameGrid()
    
    public init() {}
    
    public var rows: Int { gameGrid.rows }
    public var columns: Int { gameGrid.columns }
    
    public func character(row: Int, column: Int) -> GameCharacter? {
        let position = GridPosition(row: row, column: column)
        return try? gameGrid.character(row: position)
    }
    
    public func isEmpty(row: Int, column: Int) -> Bool {
        let position = GridPosition(row: row, column: column)
        return (try? gameGrid.isEmpty(row: position)) ?? false
    }
    
    public func placeCharacter(_ character: GameCharacter, row: Int, column: Int) {
        let position = GridPosition(row: row, column: column)
        try? gameGrid.place(character, at: position)
    }
        
    public var isEmpty: Bool {
        for row in 0..<rows {
            for column in 0..<columns {
                if !isEmpty(row: row, column: column) {
                    return false
                }
            }
        }
        return true
    }
    
    public var isFull: Bool {
        for row in 0..<rows {
            for column in 0..<columns {
                if isEmpty(row: row, column: column) {
                    return false
                }
            }
        }
        return true
    }
    
    public var characterCount: Int {
        var count = 0
        for row in 0..<rows {
            for column in 0..<columns {
                if !isEmpty(row: row, column: column) {
                    count += 1
                }
            }
        }
        return count
    }
    
    public var gridSummary: String {
        var summary = "\(rows)x\(columns) Grid:\n"
        for row in 0..<rows {
            for column in 0..<columns {
                if let character = character(row: row, column: column) {
                    summary += "\(character) "
                } else {
                    summary += "[ ] "
                }
            }
            summary += "\n"
        }
        return summary
    }
    
    public var emptyPositions: [(row: Int, column: Int)] {
        var positions: [(row: Int, column: Int)] = []
        for row in 0..<rows {
            for column in 0..<columns {
                if isEmpty(row: row, column: column) {
                    positions.append((row: row, column: column))
                }
            }
        }
        return positions
    }
    
    public var occupiedPositions: [(row: Int, column: Int)] {
        var positions: [(row: Int, column: Int)] = []
        for row in 0..<rows {
            for column in 0..<columns {
                if !isEmpty(row: row, column: column) {
                    positions.append((row: row, column: column))
                }
            }
        }
        return positions
    }
    
    public func removecharacter(row: Int, column: Int) {
        let position = GridPosition(row: row, column: column)
        try? gameGrid.removecharacter(row: position)
    }
    
    public func clearGrid() {
        for row in 0..<rows {
            for column in 0..<columns {
                removecharacter(row: row, column: column)
            }
        }
    }
    
    public func moveCharacters(direction: MovementDirection) -> Bool {
        gameGrid.move(direction: direction)
    }
    
    public func spawnInitialCharacter() {
        _ = gameGrid.spawnInitialCharacter()
    }
}

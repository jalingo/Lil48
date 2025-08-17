import Foundation

enum GridError: Error {
    case positionOutOfBounds
}

struct GridPosition {
    let row: Int
    let column: Int
}

public enum GameCharacter {
    case coolKittyKate
    case bullyBob
    case quickRick
    case snifflingSteve
    case principalYavno
    case superCoolKittyKate
}

public enum MovementDirection {
    case up, down, left, right
}

struct GameGrid {
    private enum Constants {
        static let defaultSize = 2
    }
    
    private var tiles: [[GameCharacter?]]
    
    var rows: Int { Constants.defaultSize }
    var columns: Int { Constants.defaultSize }
    
    init() {
        tiles = Array(repeating: Array(repeating: nil, count: Constants.defaultSize), count: Constants.defaultSize)
    }
    
    private func isValidPosition(_ position: GridPosition) -> Bool {
        position.row >= 0 && position.row < rows &&
        position.column >= 0 && position.column < columns
    }
    
    func isEmpty(at position: GridPosition) throws -> Bool {
        guard isValidPosition(position) else { throw GridError.positionOutOfBounds }
        return tiles[position.row][position.column] == nil
    }
    
    mutating func place(_ character: GameCharacter, at position: GridPosition) throws {
        guard isValidPosition(position) else { throw GridError.positionOutOfBounds }
        tiles[position.row][position.column] = character
    }
    
    func character(at position: GridPosition) throws -> GameCharacter? {
        guard isValidPosition(position) else { throw GridError.positionOutOfBounds }
        return tiles[position.row][position.column]
    }
    
    mutating func removeCharacter(at position: GridPosition) throws {
        guard isValidPosition(position) else { throw GridError.positionOutOfBounds }
        tiles[position.row][position.column] = nil
    }
    
    func canMove(from position: GridPosition, in direction: MovementDirection) -> Bool {
        switch direction {
        case .up: position.row > 0
        case .down: position.row < rows - 1
        case .left: position.column > 0
        case .right: position.column < columns - 1
        }
    }
    
    mutating func move(direction: MovementDirection) -> Bool {
        var hasMovement = false
        let newTiles = Array(repeating: Array(repeating: nil as GameCharacter?, count: columns), count: rows)
        var resultTiles = newTiles
        
        for row in 0..<rows {
            for column in 0..<columns {
                if let character = tiles[row][column] {
                    let currentPos = GridPosition(row: row, column: column)
                    let newPos = slidePosition(from: currentPos, direction: direction)
                    
                    if newPos.row != currentPos.row || newPos.column != currentPos.column {
                        hasMovement = true
                    }
                    
                    resultTiles[newPos.row][newPos.column] = character
                }
            }
        }
        
        if hasMovement {
            tiles = resultTiles
        }
        
        return hasMovement
    }
    
    private func slidePosition(from position: GridPosition, direction: MovementDirection) -> GridPosition {
        var newRow = position.row
        var newColumn = position.column
        
        switch direction {
        case .right:
            newColumn = columns - 1
        case .left:
            newColumn = 0
        case .up:
            newRow = 0
        case .down:
            newRow = rows - 1
        }
        
        return GridPosition(row: newRow, column: newColumn)
    }
}
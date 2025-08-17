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
        var resultTiles = tiles
        
        let positions = getAllPositions()
        let sortedPositions = sortPositionsForDirection(positions, direction: direction)
        
        for position in sortedPositions {
            if let character = tiles[position.row][position.column] {
                let newPos = slidePosition(from: position, direction: direction, in: resultTiles)
                
                if newPos.row != position.row || newPos.column != position.column {
                    hasMovement = true
                    resultTiles[position.row][position.column] = nil
                    resultTiles[newPos.row][newPos.column] = character
                }
            }
        }
        
        if hasMovement {
            tiles = resultTiles
        }
        
        return hasMovement
    }
    
    private func getAllPositions() -> [GridPosition] {
        var positions: [GridPosition] = []
        for row in 0..<rows {
            for column in 0..<columns {
                positions.append(GridPosition(row: row, column: column))
            }
        }
        return positions
    }
    
    private func sortPositionsForDirection(_ positions: [GridPosition], direction: MovementDirection) -> [GridPosition] {
        switch direction {
        case .right:
            return positions.sorted { $0.column > $1.column }
        case .left:
            return positions.sorted { $0.column < $1.column }
        case .down:
            return positions.sorted { $0.row > $1.row }
        case .up:
            return positions.sorted { $0.row < $1.row }
        }
    }
    
    private func slidePosition(from position: GridPosition, direction: MovementDirection, in grid: [[GameCharacter?]]) -> GridPosition {
        var newRow = position.row
        var newColumn = position.column
        
        switch direction {
        case .right:
            for col in (position.column + 1)..<columns {
                if grid[position.row][col] == nil {
                    newColumn = col
                } else {
                    break
                }
            }
        case .left:
            for col in (0..<position.column).reversed() {
                if grid[position.row][col] == nil {
                    newColumn = col
                } else {
                    break
                }
            }
        case .down:
            for row in (position.row + 1)..<rows {
                if grid[row][position.column] == nil {
                    newRow = row
                } else {
                    break
                }
            }
        case .up:
            for row in (0..<position.row).reversed() {
                if grid[row][position.column] == nil {
                    newRow = row
                } else {
                    break
                }
            }
        }
        
        return GridPosition(row: newRow, column: newColumn)
    }
}
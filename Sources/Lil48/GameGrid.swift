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
    
    var nextCharacter: GameCharacter? {
        switch self {
        case .coolKittyKate: return .bullyBob
        case .bullyBob: return .quickRick
        case .quickRick: return .snifflingSteve
        case .snifflingSteve: return .principalYavno
        case .principalYavno: return .superCoolKittyKate
        case .superCoolKittyKate: return nil
        }
    }
}

public enum MovementDirection {
    case up, down, left, right
}

struct GameGrid {
    private enum Constants {
        static let defaultSize = 2
        static let maxSize = 5
    }
    
    private var tiles: [[GameCharacter?]]
    private var currentSize: Int
    
    var rows: Int { currentSize }
    var columns: Int { currentSize }
    
    init() {
        currentSize = Constants.defaultSize
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
        var shouldExpandGrid = false
        
        let positions = getAllPositions()
        let sortedPositions = sortPositionsForDirection(positions, direction: direction)
        
        for position in sortedPositions {
            if let character = tiles[position.row][position.column] {
                let slideResult = slidePosition(from: position, direction: direction, in: resultTiles, currentCharacter: character)
                let newPos = slideResult.position
                
                if newPos.row != position.row || newPos.column != position.column {
                    hasMovement = true
                    resultTiles[position.row][position.column] = nil
                    
                    let promotionResult = handleCharacterPromotion(character: character, shouldPromote: slideResult.shouldPromote)
                    resultTiles[newPos.row][newPos.column] = promotionResult.finalCharacter
                    if promotionResult.shouldExpandGrid {
                        shouldExpandGrid = true
                    }
                }
            }
        }
        
        if hasMovement {
            tiles = resultTiles
            if shouldExpandGrid {
                _ = expandGrid()
            }
        }
        
        return hasMovement
    }
    
    private func handleCharacterPromotion(character: GameCharacter, shouldPromote: Bool) -> (finalCharacter: GameCharacter?, shouldExpandGrid: Bool) {
        guard shouldPromote else {
            return (character, false)
        }
        
        if character == .superCoolKittyKate {
            return (nil, true)
        } else if let promotedCharacter = character.nextCharacter {
            return (promotedCharacter, false)
        }
        
        return (character, false)
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
    
    private func slidePosition(from position: GridPosition, direction: MovementDirection, in grid: [[GameCharacter?]], currentCharacter: GameCharacter) -> (position: GridPosition, shouldPromote: Bool, targetCharacter: GameCharacter?) {
        var newRow = position.row
        var newColumn = position.column
        var shouldPromote = false
        var targetCharacter: GameCharacter? = nil
        
        switch direction {
        case .right:
            for col in (position.column + 1)..<columns {
                if let obstacle = grid[position.row][col] {
                    if obstacle == currentCharacter {
                        shouldPromote = true
                        targetCharacter = obstacle
                        newColumn = col
                    }
                    break
                } else {
                    newColumn = col
                }
            }
        case .left:
            for col in (0..<position.column).reversed() {
                if let obstacle = grid[position.row][col] {
                    if obstacle == currentCharacter {
                        shouldPromote = true
                        targetCharacter = obstacle
                        newColumn = col
                    }
                    break
                } else {
                    newColumn = col
                }
            }
        case .down:
            for row in (position.row + 1)..<rows {
                if let obstacle = grid[row][position.column] {
                    if obstacle == currentCharacter {
                        shouldPromote = true
                        targetCharacter = obstacle
                        newRow = row
                    }
                    break
                } else {
                    newRow = row
                }
            }
        case .up:
            for row in (0..<position.row).reversed() {
                if let obstacle = grid[row][position.column] {
                    if obstacle == currentCharacter {
                        shouldPromote = true
                        targetCharacter = obstacle
                        newRow = row
                    }
                    break
                } else {
                    newRow = row
                }
            }
        }
        
        return (GridPosition(row: newRow, column: newColumn), shouldPromote, targetCharacter)
    }
    
    mutating func expandGrid() -> Bool {
        guard currentSize < Constants.maxSize else { return false }
        
        let newSize = currentSize + 1
        var newTiles = Array(repeating: Array(repeating: nil as GameCharacter?, count: newSize), count: newSize)
        
        for row in 0..<currentSize {
            for column in 0..<currentSize {
                newTiles[row][column] = tiles[row][column]
            }
        }
        
        currentSize = newSize
        tiles = newTiles
        return true
    }
}
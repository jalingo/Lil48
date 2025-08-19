import Foundation

enum GridError: Error {
    case positionOutOfBounds
}

struct GridPosition: Equatable, Hashable {
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

public enum GameState {
    case victory
    case loss
    case playing
}

struct GameGrid {
    private enum Constants {
        static let defaultSize = 4
        static let maxSize = 9
        static let minSpawnChance = 0.7
        static let maxSpawnChance = 1.0
    }
    
    private var tiles: [[GameCharacter?]]
    private var currentSize: Int
    
    var rows: Int { currentSize }
    var columns: Int { currentSize }
    
    init() {
        currentSize = Constants.defaultSize
        tiles = Array(repeating: Array(repeating: nil, count: Constants.defaultSize), count: Constants.defaultSize)
        
        // Place initial character at random position
        let randomRow = Int.random(in: 0..<Constants.defaultSize)
        let randomCol = Int.random(in: 0..<Constants.defaultSize)
        tiles[randomRow][randomCol] = .coolKittyKate
    }
    
    private func isValidPosition(_ position: GridPosition) -> Bool {
        position.row >= 0 && position.row < rows &&
        position.column >= 0 && position.column < columns
    }
    
    func isEmpty(row position: GridPosition) throws -> Bool {
        guard isValidPosition(position) else { throw GridError.positionOutOfBounds }
        return tiles[position.row][position.column] == nil
    }
    
    mutating func place(_ character: GameCharacter, at position: GridPosition) throws {
        guard isValidPosition(position) else { throw GridError.positionOutOfBounds }
        tiles[position.row][position.column] = character
    }
    
    func character(row position: GridPosition) throws -> GameCharacter? {
        guard isValidPosition(position) else { throw GridError.positionOutOfBounds }
        return tiles[position.row][position.column]
    }
    
    mutating func removecharacter(row position: GridPosition) throws {
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
    
    mutating func move(direction: MovementDirection, allowSpawning: Bool = true) -> Bool {
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
            
            let spawnChance = calculateSpawnChance()
            let randomValue = Double.random(in: 0...1)
            if randomValue < spawnChance && allowSpawning {
                _ = spawnCharacter()
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
        
        let newSize = self.currentSize + 1
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
    
    mutating func spawnInitialCharacter() -> Bool {
        tiles[0][0] = .coolKittyKate
        return true
    }
    
    mutating func spawnCharacter() -> Bool {
        let empty = emptyPositions
        guard let randomPosition = empty.randomElement() else { return false }
        
        tiles[randomPosition.row][randomPosition.column] = getSpawnCharacter()
        return true
    }
    
    func calculateSpawnChance() -> Double {
        guard self.characterCount > 0 else { return 0.0 }
        
        let gridFillRatio = Double(self.characterCount) / Double(self.rows * self.columns)
        return max(Constants.minSpawnChance, Constants.maxSpawnChance - gridFillRatio)
    }
    
    func getSpawnCharacter() -> GameCharacter {
        let weights = getCharacterWeights()
        let random = Double.random(in: 0...1)
        
        var cumulative = 0.0
        for (character, weight) in weights {
            cumulative += weight
            if random <= cumulative {
                return character
            }
        }
        
        return .coolKittyKate
    }
    
    private func getCharacterWeights() -> [GameCharacter: Double] {
        switch self.currentSize {
        case 4:
            return [.coolKittyKate: 1.0]
        case 5:
            return [.coolKittyKate: 0.9, .bullyBob: 0.1]
        case 6:
            return [.coolKittyKate: 0.8, .bullyBob: 0.15, .quickRick: 0.05]
        case 7:
            return [.coolKittyKate: 0.7, .bullyBob: 0.2, .quickRick: 0.08, .snifflingSteve: 0.02]
        case 8:
            return [.coolKittyKate: 0.6, .bullyBob: 0.25, .quickRick: 0.1, .snifflingSteve: 0.05]
        case 9:
            return [.coolKittyKate: 0.5, .bullyBob: 0.25, .quickRick: 0.15, .snifflingSteve: 0.08, .principalYavno: 0.02]
        default:
            return [.coolKittyKate: 1.0]
        }
    }
    
    var characterCount: Int {
        var count = 0
        for row in 0..<currentSize {
            for column in 0..<currentSize {
                if tiles[row][column] != nil {
                    count += 1
                }
            }
        }
        return count
    }
    
    var emptyPositions: [GridPosition] {
        var positions: [GridPosition] = []
        for row in 0..<currentSize {
            for column in 0..<currentSize {
                if tiles[row][column] == nil {
                    positions.append(GridPosition(row: row, column: column))
                }
            }
        }
        return positions
    }
    
    var occupiedPositions: [GridPosition] {
        var positions: [GridPosition] = []
        for row in 0..<currentSize {
            for column in 0..<currentSize {
                if tiles[row][column] != nil {
                    positions.append(GridPosition(row: row, column: column))
                }
            }
        }
        return positions
    }
    
    var gameState: GameState {
        if characterCount == 0 {
            return .victory
        }
        
        if emptyPositions.isEmpty && !hasMovesAvailable() {
            return .loss
        }
        
        return .playing
    }
    
    private func hasMovesAvailable() -> Bool {
        for row in 0..<currentSize {
            for col in 0..<currentSize {
                if let character = tiles[row][col] {
                    // Check right neighbor
                    if col < currentSize - 1 {
                        if let rightNeighbor = tiles[row][col + 1] {
                            if character == rightNeighbor {
                                return true
                            }
                        }
                    }
                    
                    // Check down neighbor  
                    if row < currentSize - 1 {
                        if let downNeighbor = tiles[row + 1][col] {
                            if character == downNeighbor {
                                return true
                            }
                        }
                    }
                }
            }
        }
        return false
    }
}

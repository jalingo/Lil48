import Testing
@testable import Lil48

/// Tests for basic grid foundation functionality (Iteration 1)
struct GridFoundationTests {
    
    @Test("New grid is completely empty")
    func initialState_gridCreated_allPositionsEmpty() throws {
        // Given - Starting a new game
        // When - Grid is created
        // Then - All positions should be empty
        
        let grid = GameGrid()
        #expect(try grid.isEmpty(row: GridPosition(row: 0, column: 0)))
        #expect(try grid.isEmpty(row: GridPosition(row: 0, column: 1)))
        #expect(try grid.isEmpty(row: GridPosition(row: 1, column: 0)))
        #expect(try grid.isEmpty(row: GridPosition(row: 1, column: 1)))
    }
    
    @Test("Character can be placed at valid position")
    func emptyPosition_characterPlaced_positionBecomesOccupied() throws {
        // Given - Empty grid and a character
        // When - Character is placed at position
        // Then - Position should contain the character
        
        var grid = GameGrid()
        let character = GameCharacter.coolKittyKate
        let position = GridPosition(row: 0, column: 0)
        
        try grid.place(character, at: position)
        
        #expect(try !grid.isEmpty(row: position))
        #expect(try grid.character(row: position) == character)
    }
    
    @Test("Movement is blocked at board boundaries")
    func edgePosition_moveOffBoard_isBlocked() {
        
        let grid = GameGrid()
        let edge = grid.rows
        
        // Top edge - can't move up
        #expect(grid.canMove(from: GridPosition(row: 0, column: 0), in: .up) == false)
        
        // Bottom edge - can't move down  
        #expect(grid.canMove(from: GridPosition(row: edge, column: 0), in: .down) == false)
        
        // Left edge - can't move left
        #expect(grid.canMove(from: GridPosition(row: 0, column: 0), in: .left) == false)
        
        // Right edge - can't move right
        #expect(grid.canMove(from: GridPosition(row: 0, column: edge), in: .right) == false)
    }
    
    @Test("Valid movements are allowed within grid boundaries")
    func validPosition_validDirection_movementAllowed() {
        let grid = GameGrid()
        
        // From top-left (0,0): can move right and down
        #expect(grid.canMove(from: GridPosition(row: 0, column: 0), in: .right) == true)
        #expect(grid.canMove(from: GridPosition(row: 0, column: 0), in: .down) == true)
        
        // From top-right (0,1): can move left and down
        #expect(grid.canMove(from: GridPosition(row: 0, column: 1), in: .left) == true)
        #expect(grid.canMove(from: GridPosition(row: 0, column: 1), in: .down) == true)
        
        // From bottom-left (1,0): can move right and up
        #expect(grid.canMove(from: GridPosition(row: 1, column: 0), in: .right) == true)
        #expect(grid.canMove(from: GridPosition(row: 1, column: 0), in: .up) == true)
        
        // From bottom-right (1,1): can move left and up
        #expect(grid.canMove(from: GridPosition(row: 1, column: 1), in: .left) == true)
        #expect(grid.canMove(from: GridPosition(row: 1, column: 1), in: .up) == true)
    }
    
    @Test("Invalid positions throw out of bounds error")
    func invalidPosition_gridOperations_throwsError() throws {
        var grid = GameGrid()
        let pastEdge = grid.rows
        
        #expect(throws: GridError.positionOutOfBounds) {
            try grid.isEmpty(row: GridPosition(row: -1, column: 0))
        }
        
        #expect(throws: GridError.positionOutOfBounds) {
            try grid.character(row: GridPosition(row: pastEdge, column: 0))
        }
        
        #expect(throws: GridError.positionOutOfBounds) {
            try grid.place(.coolKittyKate, at: GridPosition(row: pastEdge, column: pastEdge + 1))
        }
    }
    
    @Test("New grid starts with initial character")
    func newGrid_initialization_hasInitialCharacter() throws {
        let grid = GameGrid()
        
        #expect(grid.characterCount == 1)
        #expect(grid.gameState == .playing)
    }
    
    @Test("Empty grid after clearing all characters is victory")
    func clearedGrid_gameState_isVictory() throws {
        var grid = GameGrid()
        
        // Clear the initial character to simulate victory
        let occupiedPositions = grid.occupiedPositions
        if let position = occupiedPositions.first {
            try grid.removecharacter(row: position)
        }
        
        #expect(grid.characterCount == 0)
        #expect(grid.gameState == .victory)
    }
    
    @Test("Full grid with no moves is loss")
    func fullGridNoMoves_gameState_isLoss() throws {
        var grid = GameGrid()
        
        // Fill grid with alternating characters so no merges are possible
        for row in 0..<grid.rows {
            for col in 0..<grid.columns {
                let character: GameCharacter = (row + col) % 2 == 0 ? .coolKittyKate : .bullyBob
                try grid.place(character, at: GridPosition(row: row, column: col))
            }
        }
        
        #expect(grid.gameState == .loss)
    }
    
    @Test("Full grid with merge available continues")
    func fullGridWithMerge_gameState_isContinue() throws {
        var grid = GameGrid()
        
        // Fill grid with same characters so merges are possible
        for row in 0..<grid.rows {
            for col in 0..<grid.columns {
                try grid.place(.coolKittyKate, at: GridPosition(row: row, column: col))
            }
        }
        
        #expect(grid.gameState == .playing)
    }
}

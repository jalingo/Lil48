import Testing
@testable import Lil48

/// Tests for basic grid foundation functionality (Iteration 1)
struct GridFoundationTests {
    
    @Test("Grid initializes with 3x3 dimensions")
    func initialState_gridCreated_hasThreeByThreeDimensions() {
        // Given - Starting a new game
        // When - Grid is created
        // Then - Should have 3 rows and 3 columns
        
        let grid = GameGrid()
        #expect(grid.rows == 3)
        #expect(grid.columns == 3)
    }
    
    @Test("New grid is completely empty")
    func initialState_gridCreated_allPositionsEmpty() throws {
        // Given - Starting a new game
        // When - Grid is created
        // Then - All positions should be empty
        
        let grid = GameGrid()
        #expect(try grid.isEmpty(at: GridPosition(row: 0, column: 0)))
        #expect(try grid.isEmpty(at: GridPosition(row: 0, column: 1)))
        #expect(try grid.isEmpty(at: GridPosition(row: 1, column: 0)))
        #expect(try grid.isEmpty(at: GridPosition(row: 1, column: 1)))
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
        
        #expect(try !grid.isEmpty(at: position))
        #expect(try grid.character(at: position) == character)
    }
    
    @Test("Movement is blocked at board boundaries")
    func edgePosition_moveOffBoard_isBlocked() {
        
        let grid = GameGrid()
        
        // Top edge - can't move up
        #expect(grid.canMove(from: GridPosition(row: 0, column: 0), in: .up) == false)
        
        // Bottom edge - can't move down  
        #expect(grid.canMove(from: GridPosition(row: 2, column: 0), in: .down) == false)
        
        // Left edge - can't move left
        #expect(grid.canMove(from: GridPosition(row: 0, column: 0), in: .left) == false)
        
        // Right edge - can't move right
        #expect(grid.canMove(from: GridPosition(row: 0, column: 2), in: .right) == false)
    }
    
    @Test("Valid movements are allowed within grid boundaries")
    func validPosition_validDirection_movementAllowed() {
        // Given - 2x2 grid with positions that can move in certain directions
        // When - Valid movement is attempted
        // Then - Movement should be allowed
        
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
        
        #expect(throws: GridError.positionOutOfBounds) {
            try grid.isEmpty(at: GridPosition(row: -1, column: 0))
        }
        
        #expect(throws: GridError.positionOutOfBounds) {
            try grid.character(at: GridPosition(row: 3, column: 0))
        }
        
        #expect(throws: GridError.positionOutOfBounds) {
            try grid.place(.coolKittyKate, at: GridPosition(row: 3, column: 3))
        }
    }
}

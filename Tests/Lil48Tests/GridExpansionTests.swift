import Testing
@testable import Lil48

struct GridExpansionTests {
    @Test("Grid starts with 4x4 dimensions")
    func gameGrid_initialState_has3x3Dimensions() throws {
        let grid = GameGrid()
        
        #expect(grid.rows == 4)
        #expect(grid.columns == 4)
    }
    
    @Test("Grid expands to 4x4 when expansion triggered")
    func gameGrid_triggerExpansion_expandsTo4x4() throws {
        var grid = GameGrid()
        let originalRows = grid.rows
        let originalCols = grid.columns
        
        let expanded = grid.expandGrid()
        
        #expect(expanded == true)
        #expect(grid.rows == originalRows + 1)
        #expect(grid.columns == originalCols + 1)
    }
    
    @Test("Existing characters remain in same positions after expansion")
    func gridWithCharacters_expandGrid_preservesCharacterPositions() throws {
        var grid = GameGrid()
        try grid.place(.coolKittyKate, at: GridPosition(row: 0, column: 0))
        try grid.place(.bullyBob, at: GridPosition(row: 1, column: 1))
        
        let expanded = grid.expandGrid()
        
        #expect(expanded == true)
        #expect(try grid.character(row: GridPosition(row: 0, column: 0)) == .coolKittyKate)
        #expect(try grid.character(row: GridPosition(row: 1, column: 1)) == .bullyBob)
        #expect(try grid.isEmpty(row: GridPosition(row: 3, column: 3)))
    }
    
    @Test("Grid expansion has maximum size limit")
    func gameGrid_expandMultipleTimes_reachesMaximumSize() throws {
        var grid = GameGrid()
        let start = grid.rows
        let maxSize = 9
        let outOfRangeOffset = 2 // How many attempts past range to try

        for index in start..<maxSize + outOfRangeOffset {
            let result = grid.expandGrid()
            #expect(result == (index < maxSize), "failed on \(index)")
        }
        
        #expect(grid.rows == maxSize)
        #expect(grid.columns == maxSize)
    }
    
    @Test("Two Super Cool Kitty Kates colliding triggers grid expansion")
    func twoSuperCoolKittyKates_moveTowardEachOther_triggersGridExpansion() throws {
        var grid = GameGrid()
        try grid.place(.superCoolKittyKate, at: GridPosition(row: 0, column: 0))
        try grid.place(.superCoolKittyKate, at: GridPosition(row: 0, column: 1))
        
        let originalSize = grid.rows
        let result = grid.move(direction: .right)
        
        #expect(result == true)
        #expect(grid.rows == originalSize + 1)
        #expect(grid.columns == originalSize + 1)
        #expect(grid.characterCount >= 0)
    }
}

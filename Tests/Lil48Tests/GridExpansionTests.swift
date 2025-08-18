import Testing
@testable import Lil48

struct GridExpansionTests {
    @Test("Grid starts with 3x3 dimensions")
    func gameGrid_initialState_has3x3Dimensions() throws {
        let grid = GameGrid()
        
        #expect(grid.rows == 3)
        #expect(grid.columns == 3)
    }
    
    @Test("Grid expands to 4x4 when expansion triggered")
    func gameGrid_triggerExpansion_expandsTo4x4() throws {
        var grid = GameGrid()
        
        let expanded = grid.expandGrid()
        
        #expect(expanded == true)
        #expect(grid.rows == 4)
        #expect(grid.columns == 4)
    }
    
    @Test("Existing characters remain in same positions after expansion")
    func gridWithCharacters_expandGrid_preservesCharacterPositions() throws {
        var grid = GameGrid()
        try grid.place(.coolKittyKate, at: GridPosition(row: 0, column: 0))
        try grid.place(.bullyBob, at: GridPosition(row: 1, column: 1))
        
        let expanded = grid.expandGrid()
        
        #expect(expanded == true)
        #expect(try grid.character(at: GridPosition(row: 0, column: 0)) == .coolKittyKate)
        #expect(try grid.character(at: GridPosition(row: 1, column: 1)) == .bullyBob)
        #expect(try grid.isEmpty(at: GridPosition(row: 3, column: 3)))
    }
    
    @Test("Grid expansion has maximum size limit")
    func gameGrid_expandMultipleTimes_reachesMaximumSize() throws {
        var grid = GameGrid()
        
        let firstExpansion = grid.expandGrid()
        let secondExpansion = grid.expandGrid()
        let thirdExpansion = grid.expandGrid()
        
        #expect(firstExpansion == true)
        #expect(secondExpansion == true)
        #expect(thirdExpansion == false)
        #expect(grid.rows == 5)
        #expect(grid.columns == 5)
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

import Testing
@testable import Lil48

struct GridExpansionTests {
    @Test("Grid starts with 2x2 dimensions")
    func gameGrid_initialState_has2x2Dimensions() throws {
        let grid = GameGrid()
        
        #expect(grid.rows == 2)
        #expect(grid.columns == 2)
    }
    
    @Test("Grid expands to 3x3 when expansion triggered")
    func gameGrid_triggerExpansion_expandsTo3x3() throws {
        var grid = GameGrid()
        
        let expanded = grid.expandGrid()
        
        #expect(expanded == true)
        #expect(grid.rows == 3)
        #expect(grid.columns == 3)
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
        #expect(try grid.isEmpty(at: GridPosition(row: 2, column: 2)))
    }
    
    @Test("Grid expansion has maximum size limit")
    func gameGrid_expandMultipleTimes_reachesMaximumSize() throws {
        var grid = GameGrid()
        
        let firstExpansion = grid.expandGrid()
        let secondExpansion = grid.expandGrid()
        let thirdExpansion = grid.expandGrid()
        let fourthExpansion = grid.expandGrid()
        
        #expect(firstExpansion == true)
        #expect(secondExpansion == true)
        #expect(thirdExpansion == true)
        #expect(fourthExpansion == false)
        #expect(grid.rows == 5)
        #expect(grid.columns == 5)
    }
}
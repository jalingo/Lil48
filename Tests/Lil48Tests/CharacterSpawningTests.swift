import Testing
@testable import Lil48

struct CharacterSpawningTests {
    @Test("Grid spawns initial character when empty")
    func emptyGrid_spawnInitialCharacter_placesCharacterInGrid() throws {
        var grid = GameGrid()
        
        let spawned = grid.spawnInitialCharacter()
        
        #expect(spawned == true)
        #expect(grid.characterCount == 1)
        let expectedMax = (grid.rows * grid.columns) - 1
        #expect(grid.emptyPositions.count == expectedMax)
    }
    
    @Test("Character spawning frequency increases with grid size")
    func largerGrid_moveSucceeds_hasHigherSpawnChance() throws {
        var grid = GameGrid()
        _ = grid.expandGrid()
        _ = grid.expandGrid()
        try grid.place(.coolKittyKate, at: GridPosition(row: 0, column: 0))
        
        let spawnChance = grid.calculateSpawnChance()
        
        #expect(spawnChance > 0.3)
        #expect(spawnChance <= 1.0)
    }
    
    @Test("Default grid has moderate spawn chance")
    func defaultGrid_calculateSpawnChance_returnsModerateChance() throws {
        let grid = GameGrid()
        
        let spawnChance = grid.calculateSpawnChance()
        
        #expect(spawnChance >= 0.15)
        #expect(spawnChance <= 0.25)
    }
    
    @Test("Spawned character is always Cool Kitty Kate")
    func anyGrid_spawnCharacter_spawnsOnlyCoolKittyKate() throws {
        var grid = GameGrid()
        
        _ = grid.spawnInitialCharacter()
        let spawnedPosition = grid.occupiedPositions.first!
        
        #expect(try grid.character(row: spawnedPosition) == .coolKittyKate)
    }
    
    @Test("Character spawns in random empty position")
    func partiallyFilledGrid_spawnCharacter_usesEmptyPosition() throws {
        var grid = GameGrid()
        try grid.place(.bullyBob, at: GridPosition(row: 0, column: 0))
        try grid.place(.quickRick, at: GridPosition(row: 1, column: 1))
        
        let spawned = grid.spawnCharacter()
        
        #expect(spawned == true)
        #expect(grid.characterCount == 3)
        let emptyPositions = [GridPosition(row: 0, column: 1), GridPosition(row: 1, column: 0)]
        let occupiedPositions = grid.occupiedPositions
        let newCharacterPosition = occupiedPositions.first(where: { pos in
            pos != GridPosition(row: 0, column: 0) && pos != GridPosition(row: 1, column: 1)
        })
        #expect(emptyPositions.contains(where: { $0 == newCharacterPosition! }))
    }
}

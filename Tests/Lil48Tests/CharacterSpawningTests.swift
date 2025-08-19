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
    
    @Test("Empty grid has zero spawn chance")
    func emptyGrid_calculateSpawnChance_returnsZero() throws {
        let grid = GameGrid()
        
        let spawnChance = grid.calculateSpawnChance()
        
        #expect(spawnChance == 0.0)
    }
    
    @Test("Grid with characters has high spawn chance")
    func gridWithCharacters_calculateSpawnChance_returnsHighChance() throws {
        var grid = GameGrid()
        try grid.place(.coolKittyKate, at: GridPosition(row: 0, column: 0))
        
        let spawnChance = grid.calculateSpawnChance()
        
        #expect(spawnChance >= 0.7)
        #expect(spawnChance <= 1.0)
    }
    
    @Test("4x4 grid spawns only Cool Kitty Kate")
    func grid4x4_getSpawnCharacter_alwaysReturnsCoolKittyKate() throws {
        let grid = GameGrid()
        
        for _ in 0..<10 {
            let character = grid.getSpawnCharacter()
            #expect(character == .coolKittyKate)
        }
    }
    
    @Test("5x5 grid spawns Cool Kitty Kate and Bully Bob")
    func grid5x5_getSpawnCharacter_returnsCoolKittyKateOrBullyBob() throws {
        var grid = GameGrid()
        _ = grid.expandGrid()
        
        var foundCoolKitty = false
        var foundBullyBob = false
        var foundOther = false
        
        for _ in 0..<100 {
            let character = grid.getSpawnCharacter()
            switch character {
            case .coolKittyKate: foundCoolKitty = true
            case .bullyBob: foundBullyBob = true
            default: foundOther = true
            }
        }
        
        #expect(foundCoolKitty == true)
        #expect(foundBullyBob == true)
        #expect(foundOther == false)
    }
    
    @Test("9x9 grid can spawn all characters except Super Cool Kitty Kate")
    func grid9x9_getSpawnCharacter_canSpawnAllExceptSuper() throws {
        var grid = GameGrid()
        let maxSize = 9
        while grid.rows < maxSize {
            _ = grid.expandGrid()
        }
        
        var foundCharacters: Set<GameCharacter> = []
        
        for _ in 0..<1000 {
            let character = grid.getSpawnCharacter()
            foundCharacters.insert(character)
        }
        
        #expect(foundCharacters.contains(.coolKittyKate))
        #expect(foundCharacters.contains(.bullyBob))
        #expect(foundCharacters.contains(.quickRick))
        #expect(foundCharacters.contains(.snifflingSteve))
        #expect(foundCharacters.contains(.principalYavno))
        #expect(!foundCharacters.contains(.superCoolKittyKate))
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
    
    @Test("Expanded grid spawns character using adaptive logic")
    func expandedGrid_spawnCharacter_usesAdaptiveCharacterSelection() throws {
        var grid = GameGrid()
        _ = grid.expandGrid()
        
        var spawnedCharacters: Set<GameCharacter> = []
        
        for _ in 0..<50 {
            var testGrid = grid
            let spawned = testGrid.spawnCharacter()
            #expect(spawned == true)
            
            let newPositions = testGrid.occupiedPositions
            if let newPosition = newPositions.first {
                if let character = try testGrid.character(row: newPosition) {
                    spawnedCharacters.insert(character)
                }
            }
        }
        
        #expect(spawnedCharacters.contains(.coolKittyKate))
        #expect(spawnedCharacters.contains(.bullyBob))
    }
    
    @Test("Character spawns in random empty positions")
    func partiallyFilledGrid_spawnCharacter_usesRandomEmptyPosition() throws {
        var grid = GameGrid()
        try grid.place(.bullyBob, at: GridPosition(row: 1, column: 1))
        try grid.place(.quickRick, at: GridPosition(row: 2, column: 2))
        
        var spawnPositions: Set<GridPosition> = []
        
        for _ in 0..<20 {
            var testGrid = grid
            let spawned = testGrid.spawnCharacter()
            #expect(spawned == true)
            
            let newPositions = testGrid.occupiedPositions
            let newPosition = newPositions.first { pos in
                pos != GridPosition(row: 1, column: 1) && pos != GridPosition(row: 2, column: 2)
            }
            if let position = newPosition {
                spawnPositions.insert(position)
            }
        }
        
        #expect(spawnPositions.count > 1)
    }
}

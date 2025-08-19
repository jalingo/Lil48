import Testing
@testable import Lil48

struct MovementTests {
    
    @Test("Single character moves right when space available")
    func singleCharacter_movesRight_slidesToRightmostPosition() throws {
        var grid = try GameGrid.createEmpty()
        let edge = grid.columns
        try grid.place(.coolKittyKate, at: GridPosition(row: 0, column: 0))
        
        let result = grid.move(direction: .right, allowSpawning: false)
        
        #expect(result == true)
        #expect(try grid.character(row: GridPosition(row: 0, column: edge - 1)) == .coolKittyKate)
        #expect(grid.characterCount >= 1)
    }
    
    @Test("Single character cannot move right when at rightmost edge")
    func characterAtRightEdge_movesRight_remainsInPlace() throws {
        var grid = try GameGrid.createEmpty()
        
        let edge = grid.columns - 1
        try grid.place(.coolKittyKate, at: GridPosition(row: 0, column: edge))
        
        let result = grid.move(direction: .right, allowSpawning: false)
        
        #expect(result == false)
        #expect(try grid.character(row: GridPosition(row: 0, column: edge)) == .coolKittyKate)
    }
    
    @Test("Multiple characters move together in same direction")
    func multipleCharacters_moveRight_allSlideTogetherUntilBlocked() throws {
        var grid = try GameGrid.createEmpty()
        let edge = grid.columns - 1
        try grid.place(.coolKittyKate, at: GridPosition(row: 0, column: 0))
        try grid.place(.bullyBob, at: GridPosition(row: 1, column: 0))
        
        let result = grid.move(direction: .right, allowSpawning: false)
        
        #expect(result == true)
        #expect(try grid.character(row: GridPosition(row: 0, column: edge)) == .coolKittyKate)
        #expect(try grid.character(row: GridPosition(row: 1, column: edge)) == .bullyBob)
        #expect(grid.characterCount >= 2)
    }
    
    @Test("Character moves up when space available")
    func singleCharacter_movesUp_slidesToTopPosition() throws {
        var grid = try GameGrid.createEmpty()
        try grid.place(.coolKittyKate, at: GridPosition(row: 1, column: 0))
        
        let result = grid.move(direction: .up, allowSpawning: false)
        
        #expect(result == true)
        #expect(try grid.isEmpty(row: GridPosition(row: 1, column: 0)))
        #expect(try grid.character(row: GridPosition(row: 0, column: 0)) == .coolKittyKate)
    }
    
    @Test("No characters present results in no movement")
    func emptyGrid_moveAnyDirection_returnsFalse() throws {
        var grid = try GameGrid.createEmpty()
        
        let resultRight = grid.move(direction: .right, allowSpawning: false)
        let resultLeft = grid.move(direction: .left, allowSpawning: false)
        let resultUp = grid.move(direction: .up, allowSpawning: false)
        let resultDown = grid.move(direction: .down, allowSpawning: false)
        
        #expect(resultRight == false)
        #expect(resultLeft == false) 
        #expect(resultUp == false)
        #expect(resultDown == false)
    }
    
    @Test("Character blocked by another character stops before collision")
    func characterBlockedByAnother_movesRight_stopsBeforeCollision() throws {
        var grid = try GameGrid.createEmpty()
        let edge = grid.columns - 1
        try grid.place(.coolKittyKate, at: GridPosition(row: 0, column: 0))
        try grid.place(.bullyBob, at: GridPosition(row: 0, column: 1))
        
        let result = grid.move(direction: .right, allowSpawning: false)
        
        #expect(result == true)
        #expect(try grid.character(row: GridPosition(row: 0, column: edge - 1)) == .coolKittyKate)
        #expect(try grid.character(row: GridPosition(row: 0, column: edge)) == .bullyBob)
    }
    
    @Test("Two identical characters merge into next character when colliding")
    func twoIdenticalCharacters_moveTowardEachOther_promoteToNextCharacter() throws {
        var grid = GameGrid()
        let edge = grid.columns - 1
        try grid.place(.coolKittyKate, at: GridPosition(row: 0, column: 0))
        try grid.place(.coolKittyKate, at: GridPosition(row: 0, column: 1))
        
        let result = grid.move(direction: .right, allowSpawning: false)
        
        #expect(result == true)
        #expect(try grid.character(row: GridPosition(row: 0, column: edge)) == .bullyBob)
        #expect(grid.characterCount >= 1)
    }
    
    @Test("Newly promoted character cannot collide again in same move")
    func ckk_ckk_bb_moveRight_preventsDoubleMerge() throws {
        var grid = try GameGrid.createEmpty()
        try grid.place(.coolKittyKate, at: GridPosition(row: 0, column: 0))
        try grid.place(.coolKittyKate, at: GridPosition(row: 0, column: 1))
        try grid.place(.bullyBob, at: GridPosition(row: 0, column: 2))
        
        let result = grid.move(direction: .right, allowSpawning: false)
        
        #expect(result == true)
        // Two Bully Bobs should exist separately (no cascading merge in same move)
        #expect(try grid.character(row: GridPosition(row: 0, column: 3)) == .bullyBob)
        #expect(try grid.character(row: GridPosition(row: 0, column: 2)) == .bullyBob)
        #expect(try grid.isEmpty(row: GridPosition(row: 0, column: 1)))
        #expect(try grid.isEmpty(row: GridPosition(row: 0, column: 0)))
    }
}

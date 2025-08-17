import Testing
@testable import Lil48

struct MovementTests {
    
    @Test("Single character moves right when space available")
    func singleCharacter_movesRight_slidesToRightmostPosition() throws {
        var grid = GameGrid()
        try grid.place(.coolKittyKate, at: GridPosition(row: 0, column: 0))
        
        let result = grid.move(direction: .right)
        
        #expect(result == true)
        #expect(try grid.isEmpty(at: GridPosition(row: 0, column: 0)))
        #expect(try grid.character(at: GridPosition(row: 0, column: 1)) == .coolKittyKate)
    }
    
    @Test("Single character cannot move right when at rightmost edge")
    func characterAtRightEdge_movesRight_remainsInPlace() throws {
        var grid = GameGrid()
        try grid.place(.coolKittyKate, at: GridPosition(row: 0, column: 1))
        
        let result = grid.move(direction: .right)
        
        #expect(result == false)
        #expect(try grid.character(at: GridPosition(row: 0, column: 1)) == .coolKittyKate)
    }
    
    @Test("Multiple characters move together in same direction")
    func multipleCharacters_moveRight_allSlideTogetherUntilBlocked() throws {
        var grid = GameGrid()
        try grid.place(.coolKittyKate, at: GridPosition(row: 0, column: 0))
        try grid.place(.bullyBob, at: GridPosition(row: 1, column: 0))
        
        let result = grid.move(direction: .right)
        
        #expect(result == true)
        #expect(try grid.isEmpty(at: GridPosition(row: 0, column: 0)))
        #expect(try grid.isEmpty(at: GridPosition(row: 1, column: 0)))
        #expect(try grid.character(at: GridPosition(row: 0, column: 1)) == .coolKittyKate)
        #expect(try grid.character(at: GridPosition(row: 1, column: 1)) == .bullyBob)
    }
    
    @Test("Character moves up when space available")
    func singleCharacter_movesUp_slidesToTopPosition() throws {
        var grid = GameGrid()
        try grid.place(.coolKittyKate, at: GridPosition(row: 1, column: 0))
        
        let result = grid.move(direction: .up)
        
        #expect(result == true)
        #expect(try grid.isEmpty(at: GridPosition(row: 1, column: 0)))
        #expect(try grid.character(at: GridPosition(row: 0, column: 0)) == .coolKittyKate)
    }
    
    @Test("No characters present results in no movement")
    func emptyGrid_moveAnyDirection_returnsFalse() throws {
        var grid = GameGrid()
        
        let resultRight = grid.move(direction: .right)
        let resultLeft = grid.move(direction: .left)
        let resultUp = grid.move(direction: .up)
        let resultDown = grid.move(direction: .down)
        
        #expect(resultRight == false)
        #expect(resultLeft == false) 
        #expect(resultUp == false)
        #expect(resultDown == false)
    }
    
    @Test("Character blocked by another character stops before collision")
    func characterBlockedByAnother_movesRight_stopsBeforeCollision() throws {
        var grid = GameGrid()
        try grid.place(.coolKittyKate, at: GridPosition(row: 0, column: 0))
        try grid.place(.bullyBob, at: GridPosition(row: 0, column: 1))
        
        let result = grid.move(direction: .right)
        
        #expect(result == false)
        #expect(try grid.character(at: GridPosition(row: 0, column: 0)) == .coolKittyKate)
        #expect(try grid.character(at: GridPosition(row: 0, column: 1)) == .bullyBob)
    }
}
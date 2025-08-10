import SwiftUI

@Observable
public class GameGridViewModel {
    private var gameGrid = GameGrid()
    
    public init() {}
    
    public var rows: Int { gameGrid.rows }
    public var columns: Int { gameGrid.columns }
    
    public func character(at row: Int, column: Int) -> GameCharacter? {
        let position = GridPosition(row: row, column: column)
        return try? gameGrid.character(at: position)
    }
    
    public func isEmpty(at row: Int, column: Int) -> Bool {
        let position = GridPosition(row: row, column: column)
        return (try? gameGrid.isEmpty(at: position)) ?? false
    }
    
    public func placeCharacter(_ character: GameCharacter, at row: Int, column: Int) {
        let position = GridPosition(row: row, column: column)
        try? gameGrid.place(character, at: position)
    }
}
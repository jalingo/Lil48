import Foundation
@testable import Lil48

extension GameGrid {
    static func createEmpty() throws -> GameGrid {
        var grid = GameGrid()
        if let occupiedPosition = grid.occupiedPositions.first {
            try grid.removecharacter(row: occupiedPosition)
        }
        return grid
    }
}
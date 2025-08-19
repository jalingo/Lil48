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

extension GameGridViewModel {
    static func createEmpty() throws -> GameGridViewModel {
        let viewModel = GameGridViewModel()
        if let occupiedPosition = viewModel.occupiedPositions.first {
            viewModel.removecharacter(row: occupiedPosition.row, column: occupiedPosition.column)
        }
        return viewModel
    }
}
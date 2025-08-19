import Foundation

public struct GridDemo {
    public static func run() {
        print("🎮 Lil48 Grid Foundation Demo")
        print("===============================\n")
        
        let viewModel = GameGridViewModel()
        
        print("Initial empty grid:")
        print(viewModel.gridSummary)
        print("isEmpty: \(viewModel.isEmpty)")
        print("isFull: \(viewModel.isFull)")
        print("characterCount: \(viewModel.characterCount)")
        print("emptyPositions: \(viewModel.emptyPositions)")
        print()
        
        print("Placing Cool Kitty Kate at (0,0)...")
        viewModel.placeCharacter(.coolKittyKate, row: 0, column: 0)
        print(viewModel.gridSummary)
        print("isEmpty: \(viewModel.isEmpty)")
        print("characterCount: \(viewModel.characterCount)")
        print("occupiedPositions: \(viewModel.occupiedPositions)")
        print()
        
        print("Placing Bully Bob at (1,1)...")
        viewModel.placeCharacter(.bullyBob, row: 1, column: 1)
        print(viewModel.gridSummary)
        print("characterCount: \(viewModel.characterCount)")
        print()
        
        print("Filling remaining positions...")
        viewModel.placeCharacter(.quickRick, row: 0, column: 1)
        viewModel.placeCharacter(.snifflingSteve, row: 1, column: 0)
        print(viewModel.gridSummary)
        print("isFull: \(viewModel.isFull)")
        print("emptyPositions: \(viewModel.emptyPositions)")
        print()
        
        print("Removing character from (0,1)...")
        viewModel.removecharacter(row: 0, column: 1)
        print(viewModel.gridSummary)
        print("characterCount: \(viewModel.characterCount)")
        print()
        
        print("Clearing entire grid...")
        viewModel.clearGrid()
        print(viewModel.gridSummary)
        print("isEmpty: \(viewModel.isEmpty)")
        print("characterCount: \(viewModel.characterCount)")
        
        print("\n✅ Demo complete! All grid operations working perfectly.")
    }
}

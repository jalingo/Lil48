import SwiftUI
import Lil48

struct ContentView: View {
    @State private var viewModel = GameGridViewModel()
    
    var body: some View {
        VStack {
            Text("Lil48 Grid")
                .font(.largeTitle)
                .padding()
            
            GridView(viewModel: viewModel)
                .padding()
            
            Spacer()
        }
    }
}

struct GridView: View {
    let viewModel: GameGridViewModel
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: viewModel.columns), spacing: 8) {
            ForEach(0..<viewModel.rows, id: \.self) { row in
                ForEach(0..<viewModel.columns, id: \.self) { column in
                    GridCellView(
                        character: viewModel.character(row: row, column: column),
                        row: row,
                        column: column,
                        onTap: { row, column in
                            viewModel.placeCharacter(.coolKittyKate, row: row, column: column)
                        }
                    )
                }
            }
        }
        .frame(maxWidth: 300, maxHeight: 300)
    }
}

struct GridCellView: View {
    let character: GameCharacter?
    let row: Int
    let column: Int
    let onTap: (Int, Int) -> Void
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(character == nil ? Color.gray.opacity(0.3) : characterColor)
            .frame(width: 60, height: 60)
            .overlay {
                if character != nil {
                    Circle()
                        .fill(characterColor)
                        .frame(width: 40, height: 40)
                }
            }
            .onTapGesture {
                onTap(row, column)
            }
    }
    
    private var characterColor: Color {
        guard let character else { return .clear }
        switch character {
        case .coolKittyKate: return .brown
        case .bullyBob: return .red
        case .quickRick: return .green
        case .snifflingSteve: return .blue
        case .principalYavno: return .black
        case .superCoolKittyKate: return .purple
        }
    }
}


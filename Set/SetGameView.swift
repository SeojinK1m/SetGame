//
//  ContentView.swift
//  Set
//
//  Created by Sam Kim on 11/16/22.
//

import SwiftUI

struct SetGameView: View {
    @ObservedObject var viewModel: SetGameViewModel
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text(String(viewModel.score))
                    .padding([.horizontal], 30)
                    .font(.largeTitle)
                    .foregroundColor(.blue)
            }
            
            AspectVGrid(items: viewModel.cards, aspectRatio: 2/3) { card in
                CardView(
                    shapeCount: card.shapeCount,
                    shapeColor: getShapeColor(color: card.shapeColor),
                    shapeType: card.shapeType,
                    selected: card.selected,
                    shapeContent: card.shapeContent,
                    chosenAndRight: card.chosenAndRight,
                    chosenAndWrong: card.chosenAndWrong,
                    hint: card.hint
                )
                .onTapGesture {
                    viewModel.choose(card)
                }
            }
            .padding([.horizontal], 20)
            
            //  buttons
            HStack {
                Spacer()
                Button(action: viewModel.getHint) {
                    Image(systemName: "info.bubble")
                }
                Spacer()
                Button(action: handleButton) {
                    Text("More Cards")
                }
                .disabled(viewModel.noMoreCardsInDeck)
                Spacer()
                Button(action: handleNewGame) {
                    Image(systemName: "arrow.counterclockwise")
                }
                Spacer()
            }
            
        }
        .font(.title)
    }
    
    func handleButton() -> Void {
        viewModel.dealMoreCards()
    }
    
    func handleNewGame() -> Void {
        viewModel.newGame()
    }
    
    func getShapeColor(color: ShapeColor) -> Color {
        if color == ShapeColor.red {
            return Color.red
        } else if color == ShapeColor.green {
            return Color.green
        } else {
            return Color.purple
        }
    }
}

struct CardView: View {
    let shapeCount: Int
    let shapeColor: Color
    let shapeType: ShapeType
    let selected: Bool
    let shapeContent: ShapeContent
    let chosenAndRight: Bool
    let chosenAndWrong: Bool
    let hint: Bool
    
    var body: some View {
        ZStack{
            let cardShape = RoundedRectangle(cornerRadius: 10)
            if selected {
                cardShape.foregroundColor(.yellow)
            } else {
                cardShape.foregroundColor(.white)
            }
            
            cardShape.strokeBorder(lineWidth: 2)
            if hint {
                cardShape.strokeBorder(Color.blue, lineWidth: 4)
            }
            
            VStack {
                ForEach(0..<shapeCount, id: \.self) { i in
                    if shapeType == ShapeType.oval {
                        OvalCardShape(shapeColor: shapeColor, content: shapeContent)
                    } else if shapeType == ShapeType.diamond {
                        DiamondCardShape(shapeColor: shapeColor, content: shapeContent)
                    } else {
                        SquiggleCardShape(shapeColor: shapeColor, content: shapeContent)
                    }
                }
                .aspectRatio(
                    CGSize(width: 2.5, height: 1),
                    contentMode: .fit
                )
            }.aspectRatio(CGSize(width: 4, height: 5), contentMode: .fit)
            
            if chosenAndRight {
                cardShape
                    .foregroundColor(.blue)
                    .opacity(0.7)
            }
            
            if chosenAndWrong {
                cardShape
                    .foregroundColor(.red)
                    .opacity(0.7)
            }
        }
        .aspectRatio(CGSize(width: 2, height: 3), contentMode: .fit)
        .padding(3)
    }
}




























struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        let viewModel: SetGameViewModel = SetGameViewModel()
        SetGameView(
            viewModel: viewModel
        )
    }
}



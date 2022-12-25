//
//  ContentView.swift
//  Set
//
//  Created by Sam Kim on 11/16/22.
//

import SwiftUI

struct SetGameView: View {
    @ObservedObject var viewModel: SetGameViewModel
    @State private var dealtCards = Set<Int>()
    private var cardsInPlay: Int {
        dealtCards.count
    }
    @Namespace private var dealingNameSpace
    @Namespace private var discardingNameSpace
    
    private var cardsDealt: Array<SetGameModel.Card> {
        viewModel.cards.filter{dealtCards.contains($0.id)}
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text(String(viewModel.score))
                    .padding([.horizontal], 30)
                    .font(.largeTitle)
                    .foregroundColor(.blue)
            }
            
            AspectVGrid(items: cardsDealt, aspectRatio: 2/3) { card in
                CardView(
                    shapeCount: card.shapeCount,
                    shapeColor: getShapeColor(color: card.shapeColor),
                    shapeType: card.shapeType,
                    shapeContent: card.shapeContent,
                    selected: card.selected,
                    chosenAndRight: card.chosenAndRight,
                    chosenAndWrong: card.chosenAndWrong,
                    hint: card.hint,
                    isDealt: dealtCards.contains(card.id)
                )
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        viewModel.choose(card)
                    }
                }
                .matchedGeometryEffect(id: card.id, in: dealingNameSpace)
                .matchedGeometryEffect(id: card.id, in: discardingNameSpace)
                .transition(.asymmetric(insertion: .identity, removal: .scale ))
                .rotationEffect(Angle.degrees(card.chosenAndRight ? 360 : 0))
                .rotationEffect(Angle.degrees(card.chosenAndWrong ? -360 : 0))
            }
            .padding([.horizontal], 20)
            
            //  buttons
            HStack {
                Spacer()
                deckOfUndealtCards
                deckOfDiscardedCards
                Spacer()
                Button(action: handleHint) {
                    Image(systemName: "info.bubble")
                }
                Spacer()
                Button(action: handleNewGame) {
                    Image(systemName: "arrow.counterclockwise")
                }
                Spacer()
            }
            
        }
        .font(.title)
    }
    func handleHint() -> Void {
        viewModel.getHint(cardsDealt)
    }
    
    func handleDeal() -> Void {
        for card in viewModel.cards.prefix(cardsInPlay + 3) {
            dealtCards.insert(card.id)
        }
        viewModel.dealMoreCards(cardsDealt)
    }
    
    func handleNewGame() -> Void {
        viewModel.newGame()
        dealtCards = []
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
    
    private func zIndex(for card: SetGameModel.Card) -> Double {
        return -Double(viewModel.cards.firstIndex(where: {$0.id == card.id}) ?? 0)
    }
    
    var deckOfUndealtCards: some View {
        ZStack {
            ForEach(viewModel.cards.filter{!dealtCards.contains($0.id)}) { card in
                CardView(shapeCount: card.shapeCount,
                         shapeColor: getShapeColor(color: card.shapeColor),
                         shapeType: card.shapeType,
                         shapeContent: card.shapeContent,
                         selected: card.selected,
                         isDealt: dealtCards.contains(card.id)
                )
                .zIndex(zIndex(for: card))
                .matchedGeometryEffect(id: card.id, in: dealingNameSpace)
                .transition(.asymmetric(insertion: .scale, removal: .identity))
            }
        }
        .frame(width: 60, height: 90)
        .onTapGesture {
            withAnimation(.easeInOut) {
                handleDeal()
            }
        }
    }
    
    var deckOfDiscardedCards: some View {
        ZStack {
            ForEach(viewModel.matchedCards) { card in
                CardView(shapeCount: card.shapeCount,
                         shapeColor: getShapeColor(color: card.shapeColor),
                         shapeType: card.shapeType,
                         shapeContent: card.shapeContent,
                         selected: card.selected,
                         isDealt: dealtCards.contains(card.id)
                )
                .matchedGeometryEffect(id: card.id, in: discardingNameSpace)
            }
        }
        .frame(width: 60, height: 90)
    }
}

struct CardView: View {
    let shapeCount: Int
    let shapeColor: Color
    let shapeType: ShapeType
    let shapeContent: ShapeContent
    var selected: Bool
    var chosenAndRight: Bool = false
    var chosenAndWrong: Bool = false
    var hint: Bool = false
    var isDealt: Bool
    
    var body: some View {
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
        }
        .aspectRatio(CGSize(width: 4, height: 5), contentMode: .fit)
        .cardify(isDealt: isDealt, selected: selected, chosenAndRight: chosenAndRight, chosenAndWrong: chosenAndWrong, hint: hint)
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



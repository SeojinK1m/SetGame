//
//  SetGameViewModel.swift
//  Set
//
//  Created by Sam Kim on 11/17/22.
//

import Foundation

//  publishes changes in the model to the view
class SetGameViewModel: ObservableObject {
    @Published private var model: SetGameModel
    var cards: Array<SetGameModel.Card> {
        return Array(model.cards[0 ..< model.cardsInPlay])
    }
    var noMoreCardsInDeck: Bool {
        model.noMoreCardsInDeck
    }
    var score: Int {
        model.score
    }
    
    init() {
        model = SetGameModel()
    }
    
    //  MARK: - Intent(s)
    func dealMoreCards() {
        model.dealMoreCards()
    }
    
    func choose(_ card : SetGameModel.Card) {
        model.choose(card)
    }
    
    func newGame() {
        model = SetGameModel()
    }
    
    func getHint() {
        if let _ = model.possibleSet {
            model.showHint()
        }
    }
}


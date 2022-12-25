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
        model.cards
    }
    var matchedCards: Array<SetGameModel.Card> {
        model.matchedCards
    }
    var score: Int {
        model.score
    }
    
    init() {
        model = SetGameModel()
    }
    
    //  MARK: - Intent(s)
    func dealMoreCards(_ cards: Array<SetGameModel.Card>) {
        model.dealMoreCards(cardsAlreadyDealt: cards)
    }
    
    func choose(_ card : SetGameModel.Card) {
        model.choose(card)
    }
    
    func newGame() {
        model = SetGameModel()
    }
    
    func getHint(_ cards: Array<SetGameModel.Card>) {
        if let hint = model.getHint(among: cards) {
            model.showHint(hint)
        }
    }
}


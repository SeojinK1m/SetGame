//
//  SetGameModel.swift
//  Set
//
//  Created by Sam Kim on 11/17/22.
//

import Foundation

struct SetGameModel {
    private(set) var cards: Array<Card>
    private(set) var matchedCards: Array<Card>
    private(set) var indicesOfChosenCards: Set<Int> {
        get { Set(cards.indices.filter({cards[$0].selected})) }
        set {  }
    }
    
    private var isValidSet: Bool {
        isValidSetFunction(indicesOfChosenCards: indicesOfChosenCards)
    }
    private var numberOfChosenAndRightCards: Int {
        cards.indices.filter({cards[$0].chosenAndRight}).count
    }
    private(set) var score: Int
    
    init() {
        score = 0
        cards = []
        matchedCards = []
        indicesOfChosenCards = []
        for color in ShapeColor.allCases {
            for shape in ShapeType.allCases {
                for content in ShapeContent.allCases {
                    for i in 1...3 {
                        let card = Card(
                            id: cards.count,
                            shapeCount: i,
                            shapeColor: color,
                            shapeType: shape,
                            shapeContent: content
                        )
                        cards.append(card)
                    }
                }
            }
        }
        cards.shuffle()
    }
    
    mutating func dealMoreCards(cardsAlreadyDealt: Array<SetGameModel.Card>) {
        if isValidSet {
            var setOfSelectedCardIDs = Set<Int>()
            for index in indicesOfChosenCards {
                setOfSelectedCardIDs.insert(cards[index].id)
                cards[index].selected.toggle()
                matchedCards.append(cards[index])
            }
            cards = cards.filter {
                !setOfSelectedCardIDs.contains($0.id)
            }
        } else {
            if let _ = getHint(among: cardsAlreadyDealt) {
                score -= 3
            }
        }
    }
    
    mutating func choose(_ card: Card) {
        for index in cards.indices {
            cards[index].hint = false
        }
        if let indexOfCard = cards.firstIndex(where: {$0.id == card.id}) {
            //  check if selected card is already selected
            var numberOfSelectedCards = indicesOfChosenCards.count
            if !indicesOfChosenCards.contains(indexOfCard) {
                if numberOfSelectedCards == 3 {
                    if isValidSet {
                        for index in indicesOfChosenCards {
                            cards[index].selected.toggle()
                            matchedCards.append(cards[index])
                        }
                    } else {
                        resetCards(indicesOfCardsToToggle: indicesOfChosenCards)
                    }
                    cards[indexOfCard].selected.toggle()
                    cards = cards.filter {
                        !matchedCards.contains($0)
                    }
                    
                } else {
                    cards[indexOfCard].selected.toggle()
                    numberOfSelectedCards = indicesOfChosenCards.count
                    if numberOfSelectedCards == 3 {
                        if isValidSet {
                            for index in indicesOfChosenCards {
                                cards[index].chosenAndRight.toggle()
                            }
                            score += 5
                        } else {
                            for index in indicesOfChosenCards {
                                cards[index].chosenAndWrong.toggle()
                            }
                            score -= 5
                        }
                    }
                }
            } else {
                if indicesOfChosenCards.count == 3 {
                    if !isValidSet {
                        resetCards(indicesOfCardsToToggle: indicesOfChosenCards)
                        cards[indexOfCard].selected.toggle()
                    }
                } else {
                    cards[indexOfCard].selected.toggle()
                }
            }
        }
    }
    
    func isValidSetFunction(indicesOfChosenCards: Set<Int>) -> Bool {
        var one = 0
        var two = 0
        var three = 0
        
        var oval = 0
        var diamond = 0
        var squiggle = 0
        
        var green = 0
        var red = 0
        var purple = 0
        
        var empty = 0
        var semi = 0
        var opaque = 0
        
        if (indicesOfChosenCards.count != 3) {
            return false
        }
        
        for index in indicesOfChosenCards {
            let number = cards[index].shapeCount
            if number == 1 {
                one += 1
            } else if number == 2 {
                two += 1
            } else {
                three += 1
            }
            
            let type = cards[index].shapeType
            switch type {
            case .oval:
                oval += 1
            case .diamond:
                diamond += 1
            case .squiggle:
                squiggle += 1
            }
            
            let color = cards[index].shapeColor
            switch color {
            case .purple:
                purple += 1
            case .green:
                green += 1
            case .red:
                red += 1
            }
            
            let content = cards[index].shapeContent
            switch content {
            case .empty:
                empty += 1
            case .opaque:
                opaque += 1
            case .semiOpaque:
                semi += 1
            }
        }
        
        return !(one == 2 || two == 2 || three == 2 || green == 2 || red == 2 || purple == 2 || empty == 2 || semi == 2 || opaque == 2 || oval == 2 || diamond == 2 || squiggle == 2)
    }
    
    mutating func resetCards(indicesOfCardsToToggle: Set<Int>) {
        for index in indicesOfCardsToToggle {
            cards[index].selected = false
            cards[index].chosenAndWrong = false
            cards[index].chosenAndRight = false
        }
    }
    
    mutating func getHint(among: Array<SetGameModel.Card>) -> Set<Int>? {
        let filteredAmong = among.filter{ card in
            !matchedCards.contains(card)
        }
        for i in filteredAmong.indices {
            for j in filteredAmong.indices {
                for k in filteredAmong.indices {
                    if(i != j && j != k && i != k) {
                        let s = Set<Int>([i,j,k])
                        if isValidSetFunction(indicesOfChosenCards: s) {
                            return s
                        }
                    }
                }
            }
        }
        return nil
    }
    
    mutating func showHint(_ hint: Set<Int>) {
        for index in hint {
            cards[index].hint = true
        }
    }

    struct Card: Identifiable, Hashable {
        let id: Int
        let shapeCount: Int
        let shapeColor: ShapeColor
        let shapeType: ShapeType
        let shapeContent: ShapeContent
        var selected = false
        var chosenAndRight = false
        var chosenAndWrong = false
        var hint = false
    }
    
}

enum ShapeType: CaseIterable {
    case diamond, oval, squiggle
}

enum ShapeColor: CaseIterable {
    case red, green, purple
}

enum ShapeContent: CaseIterable {
    case empty, semiOpaque, opaque
}




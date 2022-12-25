//
//  Cardify.swift
//  Set
//
//  Created by Sam Kim on 12/24/22.
//

import SwiftUI

struct Cardify: AnimatableModifier {
    var _rotation: Double
    var _selected: Bool
    var _chosenAndRight: Bool = false
    var _chosenAndWrong: Bool = false
    var _hint: Bool = false
    
    var animatableData: Double {
        get {_rotation}
        set {_rotation = newValue}
    }
    
    init(isDealt: Bool, selected: Bool, chosenAndRight: Bool, chosenAndWrong: Bool, hint: Bool) {
        _rotation = isDealt ? 0 : 180
        _selected = selected
        _chosenAndWrong = chosenAndWrong
        _chosenAndRight = chosenAndRight
        _hint = hint
    }
    
    func body(content: Content) -> some View {
        let cardShape = RoundedRectangle(cornerRadius: 10)
        ZStack {
            if _rotation < 90 {
                cardShape.strokeBorder(lineWidth: 2)
                
                if _selected {
                    cardShape.foregroundColor(.yellow)
                } else {
                    cardShape.foregroundColor(.white)
                }
                if _hint {
                    cardShape.strokeBorder(Color.blue, lineWidth: 4)
                }
                if _chosenAndRight {
                    cardShape
                        .foregroundColor(.blue)
                        .opacity(0.7)
                }
                if _chosenAndWrong {
                    cardShape
                        .foregroundColor(.red)
                        .opacity(0.7)
                }
                
                cardShape.strokeBorder(lineWidth: 2)
                content
            } else {
                cardShape.fill()
            }
        }
        .aspectRatio(CGSize(width: 2, height: 3), contentMode: .fit)
        .padding(3)
    }
}

extension View {
    func cardify(isDealt: Bool, selected: Bool, chosenAndRight: Bool, chosenAndWrong: Bool, hint: Bool) -> some View {
        return self.modifier(Cardify(isDealt: isDealt, selected: selected, chosenAndRight: chosenAndRight, chosenAndWrong: chosenAndWrong, hint: hint))
    }
}

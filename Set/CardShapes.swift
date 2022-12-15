//
//  CardShapes.swift
//  Set
//
//  Created by Sam Kim on 11/16/22.
//

import Foundation
import SwiftUI

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let widthHalf = (rect.width * 0.7) / 2
        let heightHalf = (rect.height * 0.7) / 2
        
        let topPoint = CGPoint(
            x: center.x,
            y: center.y + heightHalf)
        let leftPoint = CGPoint(
            x: center.x - widthHalf,
            y: center.y
        )
        let bottomPoint = CGPoint(
            x: center.x,
            y: center.y - heightHalf
        )
        let rightPoint = CGPoint(
            x: center.x + widthHalf,
            y: center.y
        )
        p.move(to: topPoint)
        p.addLine(to: leftPoint)
        p.addLine(to: bottomPoint)
        p.addLine(to: rightPoint)
        p.addLine(to: topPoint)
        
        return p
    }
}

struct Oval: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let widthHalf = (rect.width * 0.7) / 2
        let heightHalf = (rect.height * 0.7) / 2
        
        let leftPoint = CGPoint(
            x: center.x - widthHalf + heightHalf,
            y: center.y + heightHalf
        )
        let rightPoint = CGPoint(
            x: center.x + widthHalf - heightHalf,
            y: center.y - heightHalf
        )
        
        p.move(to: leftPoint)
        p.addArc(
            center: CGPoint(x: leftPoint.x, y: center.y),
            radius: heightHalf,
            startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 270),
            clockwise: false
        )
        p.addLine(to: rightPoint)
        p.addArc(
            center: CGPoint(x: rightPoint.x, y: center.y),
            radius: heightHalf,
            startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 90),
            clockwise: false
        )
        p.addLine(to: leftPoint)

        return p
    }
}

struct Squiggle: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let heightHalf = (rect.height * 0.7) / 2
        
        let start = CGPoint(x: center.x, y: center.y)
        p.move(to: start)
        p.addArc(
            center: CGPoint(x: start.x - heightHalf, y: start.y),
            radius: heightHalf,
            startAngle: Angle(degrees: 0),
            endAngle: Angle(degrees: 180), clockwise: false
        )
        p.addArc(
            center: CGPoint(x: start.x + heightHalf, y: start.y),
            radius: heightHalf,
            startAngle: Angle(degrees: 180),
            endAngle: Angle(degrees: 0), clockwise: false
        )
        p.addLine(to: center)
        
        return p
    }
}

struct OvalCardShape: View {
    let shapeColor: Color
    let content: ShapeContent
    
    var body: some View {
        ZStack {
            let shape = Oval()
            switch content {
            case ShapeContent.empty:
                shape.opacity(0)
            case ShapeContent.semiOpaque:
                shape.opacity(0.5)
            case ShapeContent.opaque:
                shape.opacity(1)
            }
            shape.stroke(lineWidth: 3)
        }
        .foregroundColor(shapeColor)
    }
}

struct DiamondCardShape: View {
    let shapeColor: Color
    let content: ShapeContent
    
    var body: some View {
        ZStack {
            let shape = Diamond()
            switch content {
            case ShapeContent.empty:
                shape.opacity(0)
            case ShapeContent.semiOpaque:
                shape.opacity(0.5)
            case ShapeContent.opaque:
                shape.opacity(1)
            }
            shape.stroke(lineWidth: 3)
        }
        .foregroundColor(shapeColor)
    }
}

struct SquiggleCardShape: View {
    let shapeColor: Color
    let content: ShapeContent
    
    var body: some View {
        ZStack {
            let shape = Squiggle()
            switch content {
            case ShapeContent.empty:
                shape.opacity(0)
            case ShapeContent.semiOpaque:
                shape.opacity(0.5)
            case ShapeContent.opaque:
                shape.opacity(1)
            }
            shape.stroke(lineWidth: 3)
        }
        .foregroundColor(shapeColor)
    }
}

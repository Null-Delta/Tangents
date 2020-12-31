//
//  GraphicView.swift
//  Tangents
//
//  Created by Рустам Хахук on 25.12.2020.
//

import Foundation
import Cocoa

class GraphicView: NSView {
    private var scale: CGFloat = 10.0
    private var offset: CGPoint = .zero
    private var moveMode: Bool = true
    private var functionValues: [CGPoint] = []
    private var functionDifValues: [CGPoint] = []
    
    private var lineValues: [CGPoint] = []
    private var lineValues2: [CGPoint] = []

    var function: String = ""
    var function2: String = ""

    private var moveGesture = NSPanGestureRecognizer(target: self, action: #selector(onMove(gesture:)))
    
    init() {
        super.init(frame: .zero)
        
        moveGesture = NSPanGestureRecognizer(target: self, action: #selector(onMove(gesture:)))
        addGestureRecognizer(moveGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onMove(gesture: NSPanGestureRecognizer) {
        if moveMode {
            let point = CGPoint(x: (gesture.location(in: self).x - bounds.width / 2) / scale, y: (gesture.location(in: self).y - bounds.height / 2) / scale)
            
            let valX = (2*point.x + sqrt((2*point.x)*(2*point.x)-4*point.y)) / 2
            let valY = Function.calculate(function: function, value: valX)
            let dif = Function.convertNormal(function: Function.differetial(function: function))
            let realK = Function.calculate(function: dif, value: valX)
            let val = (bounds.width / 2) / scale + 1

            var valuesLine: [CGPoint] = []
            //valuesLine.append(CGPoint(x: -val + valX, y: -val * realK + valY))
            //valuesLine.append(CGPoint(x: val + valX, y: val * realK + valY))

            
            for i in Int(-val*scale)..<Int(val * scale) {
                valuesLine.append(CGPoint(x: (CGFloat(i) / scale) + valX, y: (CGFloat(i) / scale) * realK + valY))
            }
            
            updateLineValues(values: valuesLine)
            
            
            let valX2 = (2*point.x - sqrt((2*point.x)*(2*point.x)-4*point.y)) / 2
            let valY2 = Function.calculate(function: function, value: valX2)
            let realK2 = Function.calculate(function: dif, value: valX2)
            var valuesLine2: [CGPoint] = []
            
            for i in Int(-val*scale)..<Int(val * scale) {
                valuesLine2.append(CGPoint(x: (CGFloat(i) / scale) + valX2, y: (CGFloat(i) / scale) * realK2 + valY2))
            }
            
            updateLineValues2(values: valuesLine2)


        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        let context = NSGraphicsContext.current!.cgContext
        
        context.setFillColor(CGColor.init(red: 0.1, green: 0.1, blue: 0.1, alpha: 1))
        context.setStrokeColor(CGColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 1))
        context.setLineWidth(5)
        
        
        context.addRect(bounds)
        context.fillPath()
        
        drawGrids(ctx: context)
        drawGrid(ctx: context)
        //redrawFunctionDif(ctx: context)
        redrawFunctionLine(ctx: context)
        redrawFunctionLine2(ctx: context)
        redrawFunction(ctx: context)
    }
    
    func updateValues(values: [CGPoint]) {
        functionValues = values
        needsDisplay = true
        displayIfNeeded()
    }
    
    
    func updateDifValues(values: [CGPoint]) {
        functionDifValues = values
        needsDisplay = true
        displayIfNeeded()
    }
    
    func updateLineValues(values: [CGPoint]) {
        lineValues = values
        needsDisplay = true
        displayIfNeeded()
    }
    
    func updateLineValues2(values: [CGPoint]) {
        lineValues2 = values
        needsDisplay = true
        displayIfNeeded()
    }
    
    func updateScale(to: CGFloat) {
        scale = to
        needsDisplay = true
        displayIfNeeded()
    }
    
    private func isNormalValue(point: CGPoint) -> Bool {
        return !(point.x.isInfinite || point.x == -.infinity || point.x.isNaN || point.y.isInfinite || point.y == -.infinity || point.y.isNaN)
    }
    
    func redrawFunction(ctx: CGContext) {
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)

        ctx.setStrokeColor(CGColor.init(red: 0.5, green: 0, blue: 0, alpha: 1))
        ctx.setLineWidth(2)
        
        if isNormalValue(point: functionValues.first ?? .zero) {
            ctx.move(to: CGPoint(x: (functionValues.first ?? .zero).x * scale + center.x + offset.x, y: (functionValues.first ?? .zero).y * scale + center.y + offset.y))
        }
                
        if functionValues.count > 0 {
            for i in 0..<functionValues.count - 1 {

                if isNormalValue(point: functionValues[i]) {
                    ctx.addLine(to: CGPoint(x: functionValues[i].x * scale + center.x + offset.x, y: functionValues[i].y * scale + center.y + offset.y))
                } else {
                    if isNormalValue(point: functionValues[i+1]) {
                        ctx.move(to: CGPoint(x: functionValues[i+1].x * scale + center.x + offset.x, y: functionValues[i+1].y * scale + center.y + offset.y))
                    }
                }
            }
        }
        ctx.strokePath()
    }
    
    func redrawFunctionDif(ctx: CGContext) {
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)

        ctx.setStrokeColor(CGColor.init(red: 0, green: 0.5, blue: 0, alpha: 1))
        ctx.setLineWidth(2)
        
        if isNormalValue(point: functionDifValues.first ?? .zero) {
            ctx.move(to: CGPoint(x: (functionDifValues.first ?? .zero).x * scale + center.x + offset.x, y: (functionDifValues.first ?? .zero).y * scale + center.y + offset.y))
        }
                
        if functionDifValues.count > 0 {
            for i in 0..<functionDifValues.count - 1 {

                if isNormalValue(point: functionDifValues[i]) {
                    ctx.addLine(to: CGPoint(x: functionDifValues[i].x * scale + center.x + offset.x, y: functionDifValues[i].y * scale + center.y + offset.y))
                } else {
                    if isNormalValue(point: functionDifValues[i+1]) {
                        ctx.move(to: CGPoint(x: functionDifValues[i+1].x * scale + center.x + offset.x, y: functionDifValues[i+1].y * scale + center.y + offset.y))
                    }
                }
            }
        }
        ctx.strokePath()
    }
    
    func redrawFunctionLine(ctx: CGContext) {
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)

        ctx.setStrokeColor(CGColor.init(red: 0, green: 0.5, blue: 0.0, alpha: 1))
        ctx.setLineWidth(2)
        
        if isNormalValue(point: lineValues.first ?? .zero) {
            ctx.move(to: CGPoint(x: (lineValues.first ?? .zero).x * scale + center.x + offset.x, y: (lineValues.first ?? .zero).y * scale + center.y + offset.y))
        }
                
        if lineValues.count > 0 {
            for i in 0..<lineValues.count - 1 {

                if isNormalValue(point: lineValues[i]) {
                    ctx.addLine(to: CGPoint(x: lineValues[i].x * scale + center.x + offset.x, y: lineValues[i].y * scale + center.y + offset.y))
                } else {
                    if isNormalValue(point: lineValues[i+1]) {
                        ctx.move(to: CGPoint(x: lineValues[i+1].x * scale + center.x + offset.x, y: lineValues[i+1].y * scale + center.y + offset.y))
                    }
                }
            }
        }
        ctx.strokePath()
    }
    
    func redrawFunctionLine2(ctx: CGContext) {
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)

        ctx.setStrokeColor(CGColor.init(red: 0, green: 0.5, blue: 0.0, alpha: 1))
        ctx.setLineWidth(2)
        
        if isNormalValue(point: lineValues2.first ?? .zero) {
            ctx.move(to: CGPoint(x: (lineValues2.first ?? .zero).x * scale + center.x + offset.x, y: (lineValues2.first ?? .zero).y * scale + center.y + offset.y))
        }
                
        if lineValues2.count > 0 {
            for i in 0..<lineValues2.count - 1 {

                if isNormalValue(point: lineValues2[i]) {
                    ctx.addLine(to: CGPoint(x: lineValues2[i].x * scale + center.x + offset.x, y: lineValues2[i].y * scale + center.y + offset.y))
                } else {
                    if isNormalValue(point: lineValues2[i+1]) {
                        ctx.move(to: CGPoint(x: lineValues2[i+1].x * scale + center.x + offset.x, y: lineValues[i+1].y * scale + center.y + offset.y))
                    }
                }
            }
        }
        ctx.strokePath()
    }
    
    private func drawGrid(ctx: CGContext) {
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        
        ctx.setLineWidth(2)
        ctx.setStrokeColor(CGColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1))
        
        ctx.move(to: CGPoint(x: center.x + offset.x, y: 0))
        ctx.addLine(to: CGPoint(x: center.x + offset.x, y: bounds.height))
        
        ctx.move(to: CGPoint(x: 0, y: center.y + offset.y))
        ctx.addLine(to: CGPoint(x: bounds.width, y: center.y + offset.y))
        
        ctx.strokePath()
    }
    
    private func drawGrids(ctx: CGContext) {
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let val = (bounds.width / 2) / (scale) + 1
        let drawings = Int(val / 25)
        
        ctx.setLineWidth(1)
        ctx.setStrokeColor(CGColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1))
        
        for i in Int(-val)..<Int(val) {
            if drawings == 0 || i % drawings == 0 {
                ctx.move(to: CGPoint(x: 0, y: CGFloat(i) * scale + center.y))
                ctx.addLine(to: CGPoint(x: bounds.width, y: CGFloat(i) * scale + center.y))
                
                ctx.move(to: CGPoint(x: CGFloat(i) * scale + center.x, y: 0))
                ctx.addLine(to: CGPoint(x: CGFloat(i) * scale + center.x, y: bounds.height))
            }
        }
        
        ctx.strokePath()
    }
}

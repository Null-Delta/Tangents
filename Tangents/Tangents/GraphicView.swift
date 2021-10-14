//
//  GraphicView.swift
//  Tangents
//
//  Created by Рустам Хахук on 25.12.2020.
//

import Foundation
import Cocoa

struct LagrangeState {
    var n: CGFloat
    var from: CGFloat
    var to: CGFloat
    var needDraw: Bool
    var isChebishev: Bool
}

struct SplineState {
    var n: CGFloat
    var from: CGFloat
    var to: CGFloat
    var needDraw: Bool
}

class GraphicView: NSView {
    private var scale: CGFloat = 10.0
    private var offset: CGPoint = .zero
    private var moveMode: Bool = true
        
    var function: String = "" {
        didSet {
            needsDisplay = true
            displayIfNeeded()
        }
    }
    
    var state: LagrangeState = LagrangeState(n: 10, from: -10, to: 10, needDraw: true, isChebishev: false) {
        didSet {
            needsDisplay = true
            displayIfNeeded()
        }
    }
    
    var spline: SplineState = SplineState(n: 5, from: -10, to: 10, needDraw: true) {
        didSet {
            
        }
    }
    
    private var quality: CGFloat = 100
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        drawFunction(fn: function, withColor: CGColor(red: 1, green: 0, blue: 0, alpha: 1), ctx: context)
        //drawLagrange(ctx: context)
        drawLagrange2(ctx: context)
        //drawSpline(from: CGPoint(x: 0, y: 0), to: CGPoint(x: 1, y: 1), ctx: context)
    }
    
    func updateScale(to: CGFloat) {
        scale = to
        needsDisplay = true
        displayIfNeeded()
    }
    
    private func drawLagrange(ctx: CGContext) {
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)

        ctx.setStrokeColor(CGColor(red: 0, green: 1, blue: 0, alpha: 1))
        ctx.setLineWidth(2)
        ctx.setFillColor(CGColor(red: 0, green: 1, blue: 0, alpha: 1))
        
        var localVals: [CGPoint] = []
        
        if(state.isChebishev) {
            for i in 1..<Int(state.n + 1) {
                let localX = state.from + ((-cos((2 * CGFloat(i) - 1) / (2 * state.n) * 3.1459) + 1) / 2) * (state.to - state.from)
                                
                localVals.append(CGPoint(x: localX, y: Function.calculate(function: function, value: localX)))
                
                ctx.addEllipse(in: CGRect(origin: CGPoint(x: localVals.last!.x * scale - 4 + center.x + offset.x, y: localVals.last!.y * scale - 4 + center.y + offset.y) , size: CGSize(width: 8, height: 8)))

            }
        } else {
            for i in 0..<Int(state.n) {
                localVals.append(CGPoint(x: state.from + (state.to - state.from) / (state.n - 1) * CGFloat(i), y: Function.calculate(function: function, value: state.from + (state.to - state.from) / (state.n - 1) * CGFloat(i))))
                ctx.addEllipse(in: CGRect(origin: CGPoint(x: localVals.last!.x * scale - 4 + center.x + offset.x, y: localVals.last!.y * scale - 4 + center.y + offset.y) , size: CGSize(width: 8, height: 8)))
            }
        }
        
        ctx.fillPath()
        
        var i = state.from*quality
        let step = (bounds.width / 2) / quality
        
//        while(i < bounds.width / 2) {
//
//        }
        
        for i in Int(state.from*quality)...Int(state.to * quality) {
            var result = 0.0

            for j in 0..<Int(state.n) {
                var localRes = 1.0
                
                for v in 0..<Int(state.n) where v != j {
                    localRes *= ((CGFloat(i) / quality)-localVals[v].x)/(localVals[j].x - localVals[v].x)
                }
                
                localRes *= localVals[j].y
                
                result += localRes
            }
            
            if(i == Int(state.from * quality)) {
                ctx.move(to: CGPoint(x: CGFloat(i) / quality * scale + center.x + offset.x, y: result * scale + center.y + offset.y))
            } else {
                ctx.addLine(to: CGPoint(x: CGFloat(i) / quality * scale + center.x + offset.x, y: result * scale + center.y + offset.y))
            }
        }

        ctx.strokePath()
    }
    
    private func drawLagrange2(ctx: CGContext) {
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)

        ctx.setStrokeColor(CGColor(red: 0, green: 1, blue: 0, alpha: 1))
        ctx.setLineWidth(2)
        ctx.setFillColor(CGColor(red: 0, green: 1, blue: 0, alpha: 1))
        
        var localVals: [CGPoint] = []
        
        if(state.isChebishev) {
            for i in 1..<Int(state.n + 1) {
                let localX = state.from + ((-cos((2 * CGFloat(i) - 1) / (2 * state.n) * 3.1459) + 1) / 2) * (state.to - state.from)
                                
                localVals.append(CGPoint(x: localX, y: Function.calculate(function: function, value: localX)))
                
                ctx.addEllipse(in: CGRect(origin: CGPoint(x: localVals.last!.x * scale - 4 + center.x + offset.x, y: localVals.last!.y * scale - 4 + center.y + offset.y) , size: CGSize(width: 8, height: 8)))

            }
        } else {
            for i in 0..<Int(state.n) {
                localVals.append(CGPoint(x: state.from + (state.to - state.from) / (state.n - 1) * CGFloat(i), y: Function.calculate(function: function, value: state.from + (state.to - state.from) / (state.n - 1) * CGFloat(i))))
                ctx.addEllipse(in: CGRect(origin: CGPoint(x: localVals.last!.x * scale - 4 + center.x + offset.x, y: localVals.last!.y * scale - 4 + center.y + offset.y) , size: CGSize(width: 8, height: 8)))
            }
        }
        
        ctx.fillPath()
        
        var i = state.from*scale
        let step = (bounds.width / 2) / quality
        
        ctx.move(to: CGPoint(x: 0, y: 0))

        
        while(i < state.to*scale) {
            
            var result = 0.0

            for j in 0..<Int(state.n) {
                var localRes = 1.0
                
                for v in 0..<Int(state.n) where v != j {
                    localRes *= ((i / scale)-localVals[v].x)/(localVals[j].x - localVals[v].x)
                }
                
                localRes *= localVals[j].y
                
                result += localRes
            }
            
            if(i == state.from * scale) {
                //ctx.move(to: CGPoint(x: 0, y: 0))
                ctx.move(to: CGPoint(x: i + center.x + offset.x, y: result * scale + center.y + offset.y))
            } else {
                //ctx.addLine(to: CGPoint(x: i, y: 0))

                ctx.addLine(to: CGPoint(x: i + center.x + offset.x, y: result * scale + center.y + offset.y))
            }
            
            i += step
            //if( i > state.to * scale) {
             //   i = state.to * scale - 1
                
            //}
        }
        
        var result = 0.0

        for j in 0..<Int(state.n) {
            var localRes = 1.0
            
            for v in 0..<Int(state.n) where v != j {
                localRes *= ((state.to )-localVals[v].x)/(localVals[j].x - localVals[v].x)
            }
            
            localRes *= localVals[j].y
            
            result += localRes
        }

        ctx.addLine(to: CGPoint(x: state.to * scale + center.x + offset.x, y: result * scale + center.y + offset.y))
        
     
        ctx.strokePath()
    }
    
    private func isNormalValue(point: CGPoint) -> Bool {
        return !(point.x.isInfinite || point.x == -.infinity || point.x.isNaN || point.y.isInfinite || point.y == -.infinity || point.y.isNaN)
    }
    
    func drawFunction(fn: String, withColor: CGColor, ctx: CGContext) {
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)

        ctx.setStrokeColor(withColor)
        ctx.setLineWidth(2)
        
        let val = (bounds.width / 2) / quality + 1

        
        ctx.move(to: CGPoint(x: -val * quality * scale + center.x + offset.x, y: Function.calculate(function: fn, value: -val * quality) * scale + center.y + offset.y))

        var i = -(bounds.width / 2)
        
        let step = (bounds.width / 2) / quality
        
        //print(step)
        
        while(i <= (bounds.width / 2)) {
            //print(scale)
            ctx.addLine(to: CGPoint(x: i + center.x + offset.x, y: Function.calculate(function: fn, value: i / scale) * scale + center.y + offset.y))
            i += step
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

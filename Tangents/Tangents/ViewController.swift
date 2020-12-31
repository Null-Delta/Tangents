//
//  ViewController.swift
//  Tangents
//
//  Created by Рустам Хахук on 25.12.2020.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var GraphParent: NSView!
    @IBOutlet weak var drawButton: NSButton!
    
    @IBOutlet weak var fieldX: NSTextField!
    @IBOutlet weak var fieldY: NSTextField!
    
    @IBOutlet weak var zoomInButton: NSButton!
    @IBOutlet weak var zoomOutButton: NSButton!

    private var quality: CGFloat = 10.0

    private var graphic: GraphicView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        graphic = GraphicView()
        graphic.translatesAutoresizingMaskIntoConstraints = false
        
        GraphParent.addSubview(graphic, positioned: .below, relativeTo: nil)

        graphic.leftAnchor.constraint(equalTo: GraphParent.leftAnchor).isActive = true
        graphic.rightAnchor.constraint(equalTo: GraphParent.rightAnchor).isActive = true
        graphic.topAnchor.constraint(equalTo: GraphParent.topAnchor).isActive = true
        graphic.bottomAnchor.constraint(equalTo: GraphParent.bottomAnchor).isActive = true
        
        drawButton.target = self
        drawButton.action = #selector(onDraw)
        
        zoomInButton.target = self
        zoomInButton.action = #selector(zoomIn)
        
        zoomOutButton.target = self
        zoomOutButton.action = #selector(zoomOut)

        // Do any additional setup after loading the view.
    }

    @objc func onDraw() {
        var values: [CGPoint] = []
        
        graphic.function = fieldY.stringValue.lowercased()
        graphic.function2 = fieldX.stringValue.lowercased()

        let val = (graphic.bounds.width / 2) / quality + 1
        for i in Int(-val*quality)..<Int(val * quality) {
            values.append(CGPoint(x: Function.calculate(function: fieldX.stringValue.lowercased(), value: CGFloat(i) / quality), y: Function.calculate(function: fieldY.stringValue.lowercased(), value: CGFloat(i) / quality)))
        }

        print("hey?")
        graphic.updateValues(values: values)
        
        
        let dif = Function.convertNormal(function: Function.differetial(function: fieldY.stringValue.lowercased()))
        let dif2 = Function.convertNormal(function: Function.differetial(function: fieldX.stringValue.lowercased()))
        
        print(dif)
        
        let point = CGPoint(x: -1, y: -1)
                
        let valX = (2*point.x + sqrt((2*point.x)*(2*point.x)-4*point.y)) / 2
        let valY = Function.calculate(function: fieldY.stringValue.lowercased(), value: valX)
        
        let realK = Function.calculate(function: dif, value: valX)
        
        var valuesDif: [CGPoint] = []
        for i in Int(-val*quality)..<Int(val * quality) {
            valuesDif.append(CGPoint(x: CGFloat(i) / quality, y: Function.calculate(function: dif, value: CGFloat(i) / quality)))
        }
        //print(valuesDif)
        
        graphic.updateDifValues(values: valuesDif)
        
        var valuesLine: [CGPoint] = []
        for i in Int(-val*quality)..<Int(val * quality) {
            valuesLine.append(CGPoint(x: (CGFloat(i) / quality) + valX, y: (CGFloat(i) / quality) * realK + valY))
        }
        
        graphic.updateLineValues(values: valuesLine)


    }
    
    @objc func zoomIn() {
        quality *= 1.1
        graphic.updateScale(to: quality)
        onDraw()
    }
    
    @objc func zoomOut() {
        quality /= 1.1
        graphic.updateScale(to: quality)
        onDraw()
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}


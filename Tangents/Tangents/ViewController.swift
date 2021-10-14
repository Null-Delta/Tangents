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
    
    @IBOutlet weak var lagrangeButton: NSButton!
    @IBOutlet weak var lagrangeN: NSTextField!
    @IBOutlet weak var lagrangeFrom: NSTextField!
    @IBOutlet weak var lagrangeTo: NSTextField!

    @IBOutlet weak var Chebishev: NSButton!


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
        
        lagrangeButton.target = self
        lagrangeButton.action = #selector(onLagrange)
        
        Chebishev.target = self
        Chebishev.action = #selector(onChebish)

        // Do any additional setup after loading the view.
    }
    
    @objc func onLagrange() {
        let n = lagrangeN.stringValue.count == 0 ? 2.0 : CGFloat(Int(lagrangeN.stringValue)!)
        let from = lagrangeFrom.stringValue.count == 0 ? 1.0 : CGFloat(Int(lagrangeFrom.stringValue)!)
        let to = lagrangeTo.stringValue.count == 0 ? 1.0 : CGFloat(Int(lagrangeTo.stringValue)!)
        
        graphic.state = LagrangeState(n: n, from: from, to: to, needDraw: true, isChebishev: false)
    }
    
    
    @objc func onChebish() {
        let n = lagrangeN.stringValue.count == 0 ? 2.0 : CGFloat(Int(lagrangeN.stringValue)!)
        let from = lagrangeFrom.stringValue.count == 0 ? 1.0 : CGFloat(Int(lagrangeFrom.stringValue)!)
        let to = lagrangeTo.stringValue.count == 0 ? 1.0 : CGFloat(Int(lagrangeTo.stringValue)!)
        
        graphic.state = LagrangeState(n: n, from: from, to: to, needDraw: true, isChebishev: true)
    }
    
    @objc func onSplain() {
        
    }

    @objc func onDraw() {
        graphic.function = fieldY.stringValue.lowercased()
    }
    
    
    @objc func drawLagrange() {
        
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


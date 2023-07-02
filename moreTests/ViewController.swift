//
//  ViewController.swift
//  moreTests
//
//  Created by Robert Disbrow on 6/29/23.
//

import UIKit
import PencilKit

class canvasViewController: UIViewController, PKCanvasViewDelegate {
    
    @IBOutlet var canvasView: PKCanvasView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        canvasView.backgroundColor = .gray
        canvasView.delegate = self
        canvasView.tool = PKInkingTool(.pen, color: .black, width: 15)
        canvasView.drawingPolicy = .anyInput
        canvasView.becomeFirstResponder()
        
    }
    
    @IBAction func selectPen(_ sender: Any) {
        print("called selectPen")
        canvasView.tool = PKInkingTool(.pen, color: .black, width: 15)
    }
    @IBAction func selectEraserPixel(_ sender: Any) {
        print("called selectEraserPixel")
        canvasView.tool = PKEraserTool(.bitmap)
    }
    @IBAction func selectEraserVector(_ sender: Any) {
        print("called selectEraserVector")
        canvasView.tool = PKEraserTool(.vector)
    }

    
    
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        // No additional functionality required at this time
    }

    
}

//
//  ViewController.swift
//  moreTestsFixedViews
//
//  Created by Robert Disbrow on 7/1/23.
//

import UIKit
import PencilKit

class ViewController: UIViewController,PKCanvasViewDelegate {
    @IBOutlet weak var canvasView: PKCanvasView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        canvasView.backgroundColor = .gray
        canvasView.delegate = self
        canvasView.tool = PKInkingTool(.pen, color: .black, width: 15)
        canvasView.drawingPolicy = .anyInput
        canvasView.becomeFirstResponder()
    }
    @IBAction func eraser(_ sender: Any) {
        canvasView.tool = PKEraserTool(.vector)
    }
    
    @IBAction func pencil(_ sender: Any) {
        canvasView.tool = PKInkingTool(.pen, color: .black, width: 15)
    }
    
    
}


//
//  ViewController.swift
//  moreTestsFixedViews
//
//  Created by Robert Disbrow on 7/1/23.
//

import UIKit
import PencilKit

class ViewController: UIViewController, PKCanvasViewDelegate {
    
    @IBOutlet weak var canvasView: PKCanvasView!
    @IBOutlet weak var imageView: UIImageView!
    
    var layers: [PKDrawing] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        canvasView.backgroundColor = .clear
        canvasView.delegate = self
        canvasView.tool = PKInkingTool(.pen, color: .black, width: 15)
        canvasView.drawingPolicy = .anyInput
        canvasView.becomeFirstResponder()
        
        imageView.backgroundColor = .gray
    }
    
    @IBAction func eraser(_ sender: Any) {
        canvasView.tool = PKEraserTool(.vector)
    }
    
    @IBAction func pencil(_ sender: Any) {
        canvasView.tool = PKInkingTool(.pen, color: .black, width: 15)
    }
    
    // This method is called when the user is about to start a new stroke.
    func canvasViewDidBeginUsingTool(_ canvasView: PKCanvasView) {
        // When a new stroke begins, if there's a drawing from the previous stroke, we add it to the layer stack and clear the canvas.
        if !canvasView.drawing.bounds.isEmpty {
            layers.insert(canvasView.drawing, at: 0)
            canvasView.drawing = PKDrawing()
        }
        
        // We then composite our layers onto the imageView.
        imageView.image = compositeLayers()
    }
    
    func compositeLayers() -> UIImage {
        var image: UIImage?
        
        for (index, layer) in layers.enumerated() {
            let alpha = CGFloat(1 - 0.05 * Double(index))
            let layerImage = layer.image(from: layer.bounds, scale: 1).withAlpha(alpha)
            
            if let currentImage = image {
                UIGraphicsBeginImageContext(currentImage.size)
                
                currentImage.draw(at: .zero)
                layerImage.draw(at: .zero)
                
                image = UIGraphicsGetImageFromCurrentImageContext()
                
                UIGraphicsEndImageContext()
            } else {
                image = layerImage
            }
        }
        
        return image ?? UIImage()
    }
}

extension UIImage {
    func withAlpha(_ alpha: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: .zero, blendMode: .normal, alpha: alpha)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? self
    }
}




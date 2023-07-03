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
    var shouldUpdateLayers: Bool = false
    
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
    
    func canvasViewDidEndUsingTool(_ canvasView: PKCanvasView) {
        shouldUpdateLayers = true
    }
    
    func canvasViewDidFinishRendering(_ canvasView: PKCanvasView) {
        if shouldUpdateLayers && !canvasView.drawing.bounds.isEmpty {
            layers.insert(canvasView.drawing, at: 0)
            canvasView.drawing = PKDrawing()
            
            imageView.image = compositeLayers()
            
            shouldUpdateLayers = false
        }
    }
    
    func compositeLayers() -> UIImage {
        var image: UIImage?
        
        for (index, layer) in layers.enumerated() {
            let alpha = CGFloat(1 - 0.05 * Double(index))
            let layerImage = layer.image(from: canvasView.bounds, scale: 1).withAlpha(alpha)
            
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




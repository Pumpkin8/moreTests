//
//  ViewController.swift
//  moreTestsFixedViews
//
//  Created by Robert Disbrow on 7/1/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    var layers: [UIImage] = []
    var currentLayer: UIImage?
    var lastPoint = CGPoint.zero
    var color = UIColor.black
    var brushWidth: CGFloat = 15.0
    var opacity: CGFloat = 1.0

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.backgroundColor = .gray

        // Initialize the current layer
        currentLayer = blankImage()
    }

    // Returns a blank image
    func blankImage() -> UIImage {
        UIGraphicsBeginImageContext(imageView.frame.size)
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image
    }

    // Handles the start of a touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastPoint = touches.first?.location(in: imageView) ?? CGPoint.zero
    }

    // Handles the movement of a touch
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        let currentPoint = touch.location(in: imageView)

        drawLine(from: lastPoint, to: currentPoint)

        lastPoint = currentPoint
    }

    // Handles the end of a touch
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let currentLayer = currentLayer {
            layers.append(currentLayer)
        }
        currentLayer = blankImage()
        updateLayers()
    }

    // Draws a line from one point to another
    func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
        UIGraphicsBeginImageContext(imageView.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else { return }

        currentLayer?.draw(in: imageView.bounds)

        context.move(to: fromPoint)
        context.addLine(to: toPoint)

        context.setLineCap(.round)
        context.setBlendMode(.normal)
        context.setLineWidth(brushWidth)
        context.setStrokeColor(color.cgColor)

        context.strokePath()

        currentLayer = UIGraphicsGetImageFromCurrentImageContext()
        imageView.image = currentLayer

        UIGraphicsEndImageContext()
    }

    // Updates the opacity of each layer
    func updateLayers() {
        UIGraphicsBeginImageContext(imageView.frame.size)

        var layersToRemove = [UIImage]()
        for (index, layer) in layers.reversed().enumerated() {
            let alpha = CGFloat(1 - 0.05 * Double(index))
            if alpha <= 0 {
                layersToRemove.append(layer)
            } else {
                layer.withAlpha(alpha)?.draw(in: imageView.bounds)
            }
        }

        // Remove any layers that have become fully transparent
        layers.removeAll(where: { layersToRemove.contains($0) })

        imageView.image = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
    }


}

extension UIImage {
    // Returns a copy of the image with a specific alpha
    func withAlpha(_ alpha: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: .zero, blendMode: .normal, alpha: alpha)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}




//
//  FDBubbleImageGenerator.swift
//  Fedimos
//
//  Created by Vivien BERNARD on 11/01/2019.
//  Copyright © 2018-2019 Fedimos.
//

import UIKit

/// An helper class used to generate an image and store it.
private class _Image {
    let cornerRadius: CGFloat
    let orientation: FDBubblePathOrientation
    let isTipVisible: Bool
    
    private let bubblePath: FDBubblePath
    
    var image: UIImage?
    
    init(cornerRadius: CGFloat, orientation: FDBubblePathOrientation, isTipVisible: Bool) {
        self.cornerRadius = cornerRadius
        self.orientation = orientation
        self.isTipVisible = isTipVisible
        
        let options = FDBubblePathOptions(cornerRadius: cornerRadius,
                                          contentInsets: .zero,
                                          orientation: orientation,
                                          isTipVisible: isTipVisible)
        bubblePath = FDBubblePath(options: options)
    }
    
    func generateImageIfNecessary() -> UIImage {
        if let generated = image { return generated }
        
        let bounds = CGRect(x: 0, y: 0, width: 3*cornerRadius, height: 2*cornerRadius)
        let layer = CAShapeLayer()
        layer.bounds = bounds
        layer.fillColor = UIColor.black.cgColor
        layer.path = bubblePath.bubblePath(withSize: bounds.size).cgPath
        
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        let renderedImage = renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
        
        let contentInsets = bubblePath.bubbleContentInsets()
        let capInsets = UIEdgeInsets(top: cornerRadius + contentInsets.top,
                                     left: cornerRadius + contentInsets.left,
                                     bottom: cornerRadius + contentInsets.bottom,
                                     right: cornerRadius + contentInsets.right)
        let returnedImage = renderedImage.resizableImage(withCapInsets: capInsets, resizingMode: .stretch)
        
        self.image = returnedImage
        return returnedImage
    }
    
}

/// An object used to generate bubble images.
///
/// The class itself stores the last generator so that if a new generator is created with the same settings,
/// no image will be re-rendered.
class FDBubbleImageGenerator: NSObject {
    
    static private var lastImageGenerator: FDBubbleImageGenerator?
    
    let cornerRadius: CGFloat
    
    private var _leftTipBubble: _Image
    private var _leftNoTipBubble: _Image
    private var _rightTipBubble: _Image
    private var _rightNoTipBubble: _Image
    private var _nonOrientedBubble: _Image
    
    init(cornerRadius: CGFloat) {
        self.cornerRadius = cornerRadius
        if FDBubbleImageGenerator.lastImageGenerator?.cornerRadius == cornerRadius {
            let last = FDBubbleImageGenerator.lastImageGenerator!
            _leftTipBubble = last._leftTipBubble
            _leftNoTipBubble = last._leftNoTipBubble
            _rightTipBubble = last._rightTipBubble
            _rightNoTipBubble = last._rightNoTipBubble
            _nonOrientedBubble = last._nonOrientedBubble
        } else {
            _leftTipBubble = _Image(cornerRadius: cornerRadius, orientation: .left, isTipVisible: true)
            _leftNoTipBubble = _Image(cornerRadius: cornerRadius, orientation: .left, isTipVisible: false)
            _rightTipBubble = _Image(cornerRadius: cornerRadius, orientation: .right, isTipVisible: true)
            _rightNoTipBubble = _Image(cornerRadius: cornerRadius, orientation: .right, isTipVisible: false)
            _nonOrientedBubble = _Image(cornerRadius: cornerRadius, orientation: .none, isTipVisible: false)
        }
        
        super.init()
        
        FDBubbleImageGenerator.lastImageGenerator = self
    }
    
    func image(for orientation: FDBubblePathOrientation, isTipVisible: Bool) -> UIImage {
        switch orientation {
        case .left:
            if isTipVisible {
                return leftTipBubble()
            } else {
                return leftNoTipBubble()
            }
        case .right:
            if isTipVisible {
                return rightTipBubble()
            } else {
                return rightNoTipBubble()
            }
        case .none:
            return nonOrientedBubble()
        }
    }
    
    func leftTipBubble() -> UIImage {
        return _leftTipBubble.generateImageIfNecessary()
    }
    
    func leftNoTipBubble() -> UIImage {
        return _leftNoTipBubble.generateImageIfNecessary()
    }
    
    func rightTipBubble() -> UIImage {
        return _rightTipBubble.generateImageIfNecessary()
    }
    
    func rightNoTipBubble() -> UIImage {
        return _rightNoTipBubble.generateImageIfNecessary()
    }
    
    func nonOrientedBubble() -> UIImage {
        return _nonOrientedBubble.generateImageIfNecessary()
    }

}

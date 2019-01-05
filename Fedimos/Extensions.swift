//
//  Extensions.swift
//  Fedimos
//
//  Created by Vivien BERNARD on 25/05/2018.
//  Copyright © 2018-2019 Fedimos.
//

import UIKit

// A file containing all the extensions and the operators.

// MARK: - Extensions -

extension UIEdgeInsets {
    
    var horizontal: CGFloat {
        return left + right
    }
    
    var vertical: CGFloat {
        return top + bottom
    }
    
    init(allEdges edges: CGFloat) {
        self.init(top: edges, left: edges, bottom: edges, right: edges)
    }
    
}

extension CGRect {
    
    func insetBy(dxy: CGFloat) -> CGRect {
        return insetBy(dx: dxy, dy: dxy)
    }
    
}

extension Int {
    func arrayInRange<T>(with function: (Int) -> (T)) -> [T] {
        if self <= 0 { return [] }
        var array = [T]()
        for i in 0..<self {
            array.append(function(i))
        }
        return array
    }
}


extension CGPoint {
    static func + (a: CGPoint, b: CGPoint) -> CGPoint {
        return CGPoint(x: a.x + b.x, y: a.y + b.y)
    }
    
    static func - (a: CGPoint, b: CGPoint) -> CGPoint {
        return CGPoint(x: a.x - b.x, y: a.y - b.y)
    }
}

extension Array {
    
    mutating func remove(where expression: (Element) -> Bool) {
        var i = count-1
        while i >= 0 {
            if expression(self[i]) {
                self.remove(at: i)
                i -= 1
            }
            i -= 1
        }
    }
    
}

// Layout extensions

extension NSLayoutConstraint {
    
    /// Returns an array of constraints between two items edge to edge.
    ///
    /// - Parameters:
    ///   - from: The first item of the constraints.
    ///   - to: The second item of the constraints.
    ///   - edgeInsets: The offset in each direction.
    static func constraintsEdgeToEdge(from source: Any, to destination: Any?, edgeInsets: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        let c1 = NSLayoutConstraint(item: source, attribute: .top, relatedBy: .equal,
                                    toItem: destination, attribute: .top, multiplier: 1, constant: -edgeInsets.top)
        let c2 = NSLayoutConstraint(item: source, attribute: .leading, relatedBy: .equal,
                                    toItem: destination, attribute: .leading, multiplier: 1, constant: -edgeInsets.left)
        let c3 = NSLayoutConstraint(item: source, attribute: .bottom, relatedBy: .equal,
                                    toItem: destination, attribute: .bottom, multiplier: 1, constant: edgeInsets.bottom)
        let c4 = NSLayoutConstraint(item: source, attribute: .trailing, relatedBy: .equal,
                                    toItem: destination, attribute: .trailing, multiplier: 1, constant: edgeInsets.right)
        return [c1, c2, c3, c4]
    }
    
}

extension UIView {
    
    func oneSuperviewIs(_ view: UIView) -> Bool {
        var superview: UIView? = self
        while superview != nil {
            superview = superview?.superview
            if superview == view {
                return true
            }
        }
        return false
    }
    
}

extension UIScrollView {
    
    /// Updates the given view frame depending on the given viewSize it shoud get.
    /// The view will be centered in the scrollView. Use the parameter `insets` to
    /// add an inset in the view.
    ///
    /// - Parameters:
    ///   - view: The view to reframe.
    ///   - viewSize: The size the view should have.
    ///   - insets: The insets of the view.
    func layoutAndSetCentralContentSize(with view: UIView, viewSize: CGSize, insets: UIEdgeInsets = .zero) {
        let scrollViewVisibleSize = CGSize(width: frame.width - adjustedContentInset.horizontal,
                                           height: frame.height - adjustedContentInset.vertical)
        var scrollSize = CGSize.zero
        var origin = CGPoint.zero
        
        if viewSize.width + insets.horizontal > scrollViewVisibleSize.width {
            scrollSize.width = viewSize.width + insets.horizontal
            origin.x = insets.left
        } else {
            origin.x = (scrollViewVisibleSize.width - viewSize.width)/2
        }
        
        if viewSize.height + insets.vertical > scrollViewVisibleSize.height {
            scrollSize.height = viewSize.height + insets.vertical
            origin.y = insets.top
        } else {
            origin.y = (scrollViewVisibleSize.height - viewSize.height)/2
        }
        
        view.frame = CGRect(origin: origin, size: viewSize)
        self.contentSize = scrollSize
    }
}

extension UIImage {
    
    /// Returns an image with a modified alpha.
    ///
    /// - Parameter alpha: The new image alpha.
    func image(alpha: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: .zero, blendMode: .normal, alpha: alpha)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// Returns an image with a filled color on the alpha channel.
    ///
    /// - Parameter color: The filled color.
    func image(filledWith color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() ,
            let cgImage = self.cgImage else { return nil }
        context.scaleBy(x: 1, y: -1)
        context.translateBy(x: 0, y: -size.height)
        context.clip(to: CGRect(origin: .zero, size: size), mask: cgImage)
        context.setFillColor(color.cgColor)
        context.fill(CGRect(origin: .zero, size: size))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
}

extension CATransaction {
    
    static func doWithDisabledActions(_ block: () -> Void) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        block()
        CATransaction.commit()
    }
    
}

extension CALayer {
    
    /// Enabled rasterization and sets the correct rasterization scale.
    func enabledCorrectRasterization() {
        shouldRasterize = true
        rasterizationScale = UIScreen.main.scale
    }
    
}

extension CGAffineTransform {
    
    init(scale: CGFloat) {
        self = CGAffineTransform(scaleX: scale, y: scale)
    }
    
}

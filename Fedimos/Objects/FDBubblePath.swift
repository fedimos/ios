//
//  FDBubblePath.swift
//  Fedimos
//
//  Created by Vivien BERNARD on 31/08/2018.
//  Copyright © 2018-2019 Fedimos.
//

import UIKit

/// The orientation of the bubble tip.
///
/// - left: The tip is on the left side.
/// - right: The tip is on the right side.
/// - none: There is no tip on the bubble.
enum FDBubblePathOrientation {
    case left, right, none
}

/// The options for the bubble path.
struct FDBubblePathOptions {
    var cornerRadius: CGFloat
    var contentInsets: UIEdgeInsets
    var orientation: FDBubblePathOrientation
    var isTipVisible: Bool
}

/// An object used to create paths for bubbles.
///
/// In order to create a view with it, the contentSize should first be used in
/// `bubbleSize(forContentSize:, :)`. Then the returned size should be used in
/// `bubblePath(withSize:, :)`. The two are separated so that if the size of the first
/// is too big, you can still choose a smaller one for the path.
class FDBubblePath: NSObject {
    
    var options: FDBubblePathOptions
    
    init(options: FDBubblePathOptions) {
        self.options = options
        super.init()
    }
    
    /// Returns an additional width that should be added to the standart bubble size.
    private func additionalWidthForTip() -> CGFloat {
        switch options.orientation {
        case .left, .right:
            return options.cornerRadius * 0.3
        case .none:
            return 0
        }
    }
    
    /// Returns the content insets that should be used.
    func bubbleContentInsets() -> UIEdgeInsets {
        var bubbleContentInsets = options.contentInsets
        let additionalTipWidth = self.additionalWidthForTip()
        
        switch options.orientation {
        case .left:
            bubbleContentInsets.left += additionalTipWidth
        case .right:
            bubbleContentInsets.right += additionalTipWidth
        case .none:
            break
        }
        
        return bubbleContentInsets
    }
    
    /// The path for a bubble.
    /// Use `bubbleSize(forContentSize: options:)` to know what the size should be.
    ///
    /// - Parameters:
    ///   - size: The size of the entire bubble.
    /// - Returns: The path of the bubble.
    func bubblePath(withSize size: CGSize) -> UIBezierPath {
        let path = UIBezierPath()
        let additionalTipWidth = self.additionalWidthForTip()
        let cornerRadius = options.cornerRadius
        let orientation = options.orientation
        let isTipVisible = options.isTipVisible
        
        // We draw the path as a left bubble and if necessary, we mirror it.
        
        let corners = [CGPoint(x: cornerRadius + additionalTipWidth, y: cornerRadius),
                       CGPoint(x: size.width - cornerRadius, y: cornerRadius),
                       CGPoint(x: size.width - cornerRadius, y: size.height - cornerRadius),
                       CGPoint(x: cornerRadius + additionalTipWidth, y: size.height - cornerRadius)]
        
        path.addArc(withCenter: corners[0], radius: cornerRadius, startAngle: CGFloat.pi, endAngle: -CGFloat.pi/2, clockwise: true)
        path.addArc(withCenter: corners[1], radius: cornerRadius, startAngle: -CGFloat.pi/2, endAngle: 0, clockwise: true)
        path.addArc(withCenter: corners[2], radius: cornerRadius, startAngle: 0, endAngle: CGFloat.pi/2, clockwise: true)
        
        if orientation == .none || !isTipVisible {
            path.addArc(withCenter: corners[3], radius: cornerRadius, startAngle: CGFloat.pi/2, endAngle: CGFloat.pi, clockwise: true)
        } else {
            path.addArc(withCenter: corners[3], radius: cornerRadius, startAngle: CGFloat.pi/2, endAngle: CGFloat.pi*0.7, clockwise: true)
            path.addCurve(to: CGPoint(x: 0, y: size.height),
                          controlPoint1: CGPoint(x: additionalTipWidth, y: size.height),
                          controlPoint2: CGPoint(x: additionalTipWidth/2, y: size.height))
            path.addCurve(to: CGPoint(x: additionalTipWidth, y: size.height - cornerRadius*0.75),
                          controlPoint1: CGPoint(x: additionalTipWidth/2, y: size.height),
                          controlPoint2: CGPoint(x: additionalTipWidth, y: size.height - cornerRadius/4))
        }
        
        path.close()
        
        switch orientation {
        case .left:
            break
        case .right:
            path.apply(CGAffineTransform(scaleX: -1, y: 1))
            path.apply(CGAffineTransform(translationX: size.width, y: 0))
        case .none:
            break
        }
        
        return path
    }

}

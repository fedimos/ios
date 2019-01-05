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
    let cornerRadius: CGFloat
    let contentInsets: UIEdgeInsets
    let orientation: FDBubblePathOrientation
}

/// An object used to create path for bubbles.
class FDBubblePath: NSObject {
    
    static let shared = FDBubblePath()
    
    private override init() {
        super.init()
    }
    
    private func additionalWidthForTip(with options: FDBubblePathOptions) -> CGFloat {
        switch options.orientation {
        case .left, .right:
            return options.cornerRadius * 0.3
        case .none:
            return 0
        }
    }
    
    /// The size a bubble should have depending on the parameters.
    ///
    /// - Parameters:
    ///   - contentSize: The size of the content.
    ///   - options: The options for the path.
    func bubbleSize(forContentSize contentSize: CGSize, options: FDBubblePathOptions) -> CGSize {
        return CGSize(width: contentSize.width + options.contentInsets.horizontal + additionalWidthForTip(with: options),
                      height: contentSize.height + options.contentInsets.vertical)
    }
    
    /// The path for a bubble.
    /// Use `bubbleSize(forContentSize: options:)` to know what the size should be.
    ///
    /// - Parameters:
    ///   - size: The size of the entire bubble.
    ///   - options: The options for the path.
    /// - Returns: The path of the bubble and the contentRect inside the bubble.
    func bubblePath(withSize size: CGSize, options: FDBubblePathOptions) -> (path: UIBezierPath, contentRect: CGRect) {
        let path = UIBezierPath()
        let additionalTipWidth = additionalWidthForTip(with: options)
        let cornerRadius = options.cornerRadius
        let contentInsets = options.contentInsets
        let orientation = options.orientation
        
        let corners = [CGPoint(x: cornerRadius + additionalTipWidth, y: cornerRadius),
                       CGPoint(x: size.width - cornerRadius, y: cornerRadius),
                       CGPoint(x: size.width - cornerRadius, y: size.height - cornerRadius),
                       CGPoint(x: cornerRadius + additionalTipWidth, y: size.height - cornerRadius)]
        
        path.addArc(withCenter: corners[0], radius: cornerRadius, startAngle: CGFloat.pi, endAngle: -CGFloat.pi/2, clockwise: true)
        path.addArc(withCenter: corners[1], radius: cornerRadius, startAngle: -CGFloat.pi/2, endAngle: 0, clockwise: true)
        path.addArc(withCenter: corners[2], radius: cornerRadius, startAngle: 0, endAngle: CGFloat.pi/2, clockwise: true)
        
        switch orientation {
        case .left, .right:
            path.addArc(withCenter: corners[3], radius: cornerRadius, startAngle: CGFloat.pi/2, endAngle: CGFloat.pi*0.7, clockwise: true)
            path.addCurve(to: CGPoint(x: 0, y: size.height),
                          controlPoint1: CGPoint(x: additionalTipWidth, y: size.height),
                          controlPoint2: CGPoint(x: additionalTipWidth/2, y: size.height))
            path.addCurve(to: CGPoint(x: additionalTipWidth, y: size.height - cornerRadius*0.75),
                          controlPoint1: CGPoint(x: additionalTipWidth/2, y: size.height),
                          controlPoint2: CGPoint(x: additionalTipWidth, y: size.height - cornerRadius/4))
        case .none:
            path.addArc(withCenter: corners[3], radius: cornerRadius, startAngle: CGFloat.pi/2, endAngle: CGFloat.pi, clockwise: true)
        }
        path.close()
        
        var contentRect = CGRect(x: contentInsets.left,
                                 y: contentInsets.top,
                                 width: size.width - contentInsets.horizontal - additionalTipWidth,
                                 height: size.height - contentInsets.vertical)
        switch orientation {
        case .left:
            contentRect.origin.x += additionalTipWidth
        case .right:
            path.apply(CGAffineTransform(scaleX: -1, y: 1))
            path.apply(CGAffineTransform(translationX: size.width, y: 0))
        case .none:
            break
        }
        
        return (path, contentRect)
    }

}

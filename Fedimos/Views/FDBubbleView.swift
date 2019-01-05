//
//  FDBubbleView.swift
//  Fedimos
//
//  Created by Vivien BERNARD on 31/08/2018.
//  Copyright © 2018-2019 Fedimos.
//

import UIKit

class FDBubbleView: UIView {
    
    let contentView = UIView()
    
    private let bubbleShapeLayer = CAShapeLayer()
    
    var cornerRadius: CGFloat = 20 {
        didSet {
            setNeedsLayout()
        }
    }
    
    var bubbleTipOrientation = FDBubblePathOrientation.none {
        didSet {
            setNeedsLayout()
        }
    }
    
    var contentInsets: UIEdgeInsets = .zero {
        didSet {
            setNeedsLayout()
        }
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.addSublayer(bubbleShapeLayer)
        
        addSubview(contentView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let options = FDBubblePathOptions(cornerRadius: cornerRadius,
                                          contentInsets: contentInsets,
                                          orientation: bubbleTipOrientation)
        let size = FDBubblePath.shared.bubbleSize(forContentSize: contentView.intrinsicContentSize, options: options)
        let (path, contentRect) = FDBubblePath.shared.bubblePath(withSize: size, options: options)
        contentView.frame = contentRect
        bubbleShapeLayer.path = path.cgPath
    }
}

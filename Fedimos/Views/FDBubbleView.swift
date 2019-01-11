//
//  FDBubbleView.swift
//  Fedimos
//
//  Created by Vivien BERNARD on 31/08/2018.
//  Copyright © 2018-2019 Fedimos.
//

import UIKit

/// A structure used to setup contraints depending on a `UIEdgeInsets`.
private struct _ConstraintSet {
    let top: NSLayoutConstraint
    let right: NSLayoutConstraint
    let bottom: NSLayoutConstraint
    let left: NSLayoutConstraint
    
    func setAllActive(_ active: Bool) {
        top.isActive = active
        right.isActive = active
        bottom.isActive = active
        left.isActive = active
    }
    
    func setConstantsWith(edgeInsets: UIEdgeInsets) {
        top.constant = edgeInsets.top
        right.constant = -edgeInsets.right
        bottom.constant = -edgeInsets.bottom
        left.constant = edgeInsets.left
    }
}

/// A view representing a bubble.
class FDBubbleView: UIView {
    
    private let bubbleImageView = UIImageView()
    private var bubbleImageGenerator: FDBubbleImageGenerator!
    
    /// Returns the content view of the bubble object.
    let contentView = UIView()
    private var contentViewContraintSet: _ConstraintSet!
    
    var cornerRadius: CGFloat = 20 {
        didSet {
            bubbleImageGenerator = FDBubbleImageGenerator(cornerRadius: cornerRadius)
            updateBubbleImage()
            updateContentInsets()
        }
    }
    
    var bubbleTipOrientation = FDBubblePathOrientation.none {
        didSet {
            updateBubbleImage()
            updateContentInsets()
        }
    }
    
    var isTipVisible: Bool = true {
        didSet {
            updateBubbleImage()
            updateContentInsets()
        }
    }
    
    var contentInsets: UIEdgeInsets = .zero {
        didSet {
            updateContentInsets()
        }
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bubbleImageGenerator = FDBubbleImageGenerator(cornerRadius: cornerRadius)
        updateBubbleImage()
        
        addSubview(bubbleImageView)
        bubbleImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(NSLayoutConstraint.constraintsEdgeToEdge(from: self, to: bubbleImageView))
        
        addSubview(contentView)
        contentViewContraintSet = _ConstraintSet(top: contentView.topAnchor.constraint(equalTo: topAnchor),
                                                 right: contentView.rightAnchor.constraint(equalTo: rightAnchor),
                                                 bottom: contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
                                                 left: contentView.leftAnchor.constraint(equalTo: leftAnchor))
        contentViewContraintSet.setAllActive(true)
        contentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateBubbleImage() {
        bubbleImageView.image = bubbleImageGenerator.image(for: bubbleTipOrientation, isTipVisible: isTipVisible)
    }
    
    private func updateContentInsets() {
        let options = FDBubblePathOptions(cornerRadius: cornerRadius,
                                          contentInsets: contentInsets,
                                          orientation: bubbleTipOrientation,
                                          isTipVisible: isTipVisible)
        contentViewContraintSet.setConstantsWith(edgeInsets: FDBubblePath(options: options).bubbleContentInsets())
    }
    
}

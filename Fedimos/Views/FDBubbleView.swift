//
//  FDBubbleView.swift
//  Fedimos
//
//  Created by Vivien BERNARD on 31/08/2018.
//  Copyright © 2018-2019 Fedimos.
//

import UIKit

/// A view representing a bubble.
class FDBubbleView: UIView {
    
    private let bubbleImageView = UIImageView()
    private var bubbleImageGenerator: FDBubbleImageGenerator!
    
    /// Returns the content view of the bubble object.
    let contentView = UIView()
    
    /// The view used as the background of the bubble view.
    let backgroundView = UIView()
    
    var cornerRadius: CGFloat = 17 {
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
    
    /// The content insets that ate gonna affect the layout margins of the contentView.
    ///
    /// Leading is always in the side of the tip, no matter the language direction.
    /// If the bubble has no orientation, the leading value will be used for both leading and trailing.
    var contentInsets: NSDirectionalEdgeInsets = .zero {
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
        
        // Background view.
        addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(NSLayoutConstraint.constraintsEdgeToEdge(from: self, to: backgroundView))
        backgroundView.mask = bubbleImageView
        backgroundView.backgroundColor = .black
        
        // Content view.
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(NSLayoutConstraint.constraintsEdgeToEdge(from: self, to: contentView))
        
        // Setup.
        updateBubbleImage()
        updateContentInsets()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateBubbleImage() {
        bubbleImageView.image = bubbleImageGenerator.image(for: bubbleTipOrientation, isTipVisible: isTipVisible)
    }
    
    private func updateContentInsets() {
        let options = FDBubblePathOptions(cornerRadius: cornerRadius,
                                          contentInsets: convertContentInsets(),
                                          orientation: bubbleTipOrientation,
                                          isTipVisible: isTipVisible)
        let insets = FDBubblePath(options: options).bubbleContentInsets()
        contentView.layoutMargins = insets
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bubbleImageView.frame = bounds
    }
    
    /// Converts the directional content insets into an edge insets depending
    /// on the orientation of the bubble.
    private func convertContentInsets() -> UIEdgeInsets {
        let startInsets = contentInsets
        var finalInsets = UIEdgeInsets(top: startInsets.top, left: 0, bottom: startInsets.bottom, right: 0)
        
        switch bubbleTipOrientation {
        case .left:
            finalInsets.left = startInsets.leading
            finalInsets.right = startInsets.trailing
        case .right:
            finalInsets.left = startInsets.trailing
            finalInsets.right = startInsets.leading
        case .none:
            finalInsets.left = startInsets.leading
            finalInsets.right = startInsets.leading
        }
        
        return finalInsets
    }
    
}

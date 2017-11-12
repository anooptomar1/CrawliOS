//
//  PageAnimator.swift
//  TransitionTester
//
//  Created by Jack Chorley on 08/08/2017.
//  Copyright © 2017 iZolo LTD. All rights reserved.
//

import UIKit

class PageSlideAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    enum PageSlideDirection {
        case Left, Right
    }
    
    var direction: PageSlideDirection = .Left
    
    convenience init(direction: PageSlideDirection) {
        self.init()
        self.direction = direction
    }
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        var toStartOffset: CGFloat = 0
        
        var fromEndOffset: CGFloat = 0
        
        
        
        let from = transitionContext.viewController(forKey: .from)!
        let to = transitionContext.viewController(forKey: .to)!
        
        let finalFrame = transitionContext.finalFrame(for: to)
        let container = transitionContext.containerView
        
        let bounds = UIScreen.main.bounds
        
        switch direction {
        case .Left:
            toStartOffset = -bounds.size.width
            fromEndOffset = bounds.size.width
        case .Right:
            toStartOffset = bounds.size.width
            fromEndOffset = -bounds.size.width
        }
        
        to.view.frame = finalFrame.offsetBy(dx: toStartOffset, dy: 0)
        container.addSubview(to.view)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut, animations: {
            from.view.frame.origin.x = fromEndOffset
            to.view.frame.origin.x = 0
        }) { (success) in
            transitionContext.completeTransition(true)
        }
    }
    
}

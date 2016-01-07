//
//  TransitionViewController.swift
//  GitHubClone
//
//  Created by Cynthia Whitlatch on 1/7/16.
//  Copyright © 2016 Cynthia Whitlatch. All rights reserved.
//

import UIKit

class CustomTransition: NSObject, UIViewControllerAnimatedTransitioning {
    var duration = 1.0
    init(duration: NSTimeInterval) {
    self.duration = duration
}
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else {return}
        guard let containerView = transitionContext.containerView() else {return}
        let finalFrame = transitionContext.finalFrameForViewController(toViewController)
        toViewController.view.frame = CGRectMake(UIScreen.mainScreen().bounds.width/2, UIScreen.mainScreen().bounds.height/2, 50, 50)
        containerView.addSubview(toViewController.view)
        UIView.animateWithDuration(self.duration, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            toViewController.view.frame = finalFrame
            }) { (finished) -> Void in
                transitionContext.completeTransition(true)
        }
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return self.duration
    }
}

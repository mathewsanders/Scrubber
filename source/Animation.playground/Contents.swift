//: Animation

import UIKit
import PlaygroundSupport

let container = ScrubContainerView()
PlaygroundPage.current.liveView = container

let square = UIView()
container.addSubview(square)

container.startState = {
    square.transform = .identity
    square.bounds.size = CGSize(width: 150, height: 50)
    square.backgroundColor = .red
    square.center = container.center
}

container.animator = {
    
    
    let animator = UIViewPropertyAnimator(duration: 2.5, curve: .easeInOut)
    
    animator.addAnimations {
        
        UIView.animateKeyframes(withDuration: 1.0, delay: 0, options: [], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25) {
                square.backgroundColor = .blue
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0) {
                square.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.5) {
                square.bounds.size = CGSize(width: 50, height: 150)
            }
        })
    }
    
    return animator
}

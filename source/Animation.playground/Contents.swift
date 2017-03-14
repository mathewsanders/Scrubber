//: Animation

import UIKit
import PlaygroundSupport

let container = ScrubContainerView()
PlaygroundPage.current.liveView = container

let square = UIView()
container.addSubview(square)

container.startState = {
    square.transform = .identity
    square.bounds.size = CGSize(width: 100, height: 50)
    square.backgroundColor = .red
    square.center = container.center
}

container.animator = {
    let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeIn)
    
    animator.addAnimations {
        
        UIView.animateKeyframes(withDuration: 1, delay: 0, options: [.calculationModePaced], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.75) {
                
                square.backgroundColor = .yellow
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
            
                square.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            }
        })
    }
    
    return animator
}





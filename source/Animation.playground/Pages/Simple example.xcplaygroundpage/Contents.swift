//: Simple animation example

import UIKit
import PlaygroundSupport

let container = ScrubContainerView()
PlaygroundPage.current.liveView = container

// set up views to animate
let square = UIView()
square.center = container.center
container.addSubview(square)

// (optional) define state for start and reset
container.startState = {
    square.transform = .identity
    square.bounds.size = CGSize(width: 150, height: 50)
    square.backgroundColor = .red
}

// provide the container the animator to scrub
container.animator = {
    
    let animator = UIViewPropertyAnimator(duration: 2.5, curve: .easeInOut)
    
    animator.addAnimations {
        square.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
        square.bounds.size = CGSize(width: 50, height: 150)
        square.backgroundColor = .blue
    }
    
    return animator
}

//: Simple animation example

import UIKit
import PlaygroundSupport

let container = ScrubContainerView()
PlaygroundPage.current.liveView = container

// create objects and add to `container.stage`

// define the animation start/reset state
container.startState = {
    
}

container.animator = {
    
    // set up the animator
    let animator = UIViewPropertyAnimator(duration: 1.0, curve: .easeInOut)
    
    // define the animations
    animator.addAnimations {
        
    }
    
    return animator
}

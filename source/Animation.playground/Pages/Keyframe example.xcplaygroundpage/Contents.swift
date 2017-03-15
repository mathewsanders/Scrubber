//: [Previous](@previous)

//: Keyframe animation example

import UIKit
import PlaygroundSupport

let container = ScrubContainerView()
PlaygroundPage.current.liveView = container

// some useful variables to help with animations
let offstageLeft = CGAffineTransform(translationX: -100, y: 0)
let offstageRight = CGAffineTransform(translationX: 100, y: 0)
let capsuleFrameWide = CGRect(origin: .zero, size: CGSize(width: 80, height: 40))
let capsuleFrameNarrow = CGRect(origin: .zero, size: CGSize(width: 40, height: 40))

// create view to hold the dots ('capsule')
let capsule = UIView(frame: capsuleFrameWide)
capsule.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
capsule.layer.cornerRadius = 20
capsule.clipsToBounds = true
container.addSubview(capsule)

// create three dots and position relative to capsule
let capsuleDots = [UIView(), UIView(), UIView()]

capsuleDots.forEach({ dot in
    capsule.addSubview(dot)
    dot.center = capsule.center
    dot.bounds.size = CGSize(width: 10, height: 10)
    dot.layer.cornerRadius = 5
    dot.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
})

capsuleDots[0].center = capsule.center.applying(CGAffineTransform(translationX: 20, y: 0))
capsuleDots[1].center = capsule.center
capsuleDots[2].center = capsule.center.applying(CGAffineTransform(translationX: -20, y: 0))

capsule.center = container.center

// reset the dots and capsule for animation start
container.startState = {
    
    capsuleDots.forEach({ dot in
        dot.transform = offstageLeft
    })
    
    capsule.bounds = capsuleFrameNarrow
}

// define the four steps of the animation
container.animator = {
    
    let animator = UIViewPropertyAnimator(duration: 1.5, curve: .easeInOut)
    
    animator.addAnimations {
        
        UIView.animateKeyframes(withDuration: 2, delay: 0, options: [.calculationModeLinear], animations: {
            
            // Step 1: make the capsule grow to large size
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.1) {
                capsule.bounds = capsuleFrameWide
            }
            
            // enumerate over dots so they are slightly staggered
            for (index, dot) in capsuleDots.enumerated() {
                let offsetDelay = TimeInterval(index) * 0.025
                
                // Step 2: move the dots to their default positions, and fade in
                UIView.addKeyframe(withRelativeStartTime: 0.05 + offsetDelay, relativeDuration: 0.2) {
                    dot.transform = .identity
                    dot.alpha = 1.0
                }
                
                // Step 3: fade out dots and translate to the right
                UIView.addKeyframe(withRelativeStartTime: 0.8 + offsetDelay, relativeDuration: 0.2) {
                    
                    //dot.alpha = 0.0
                    dot.transform = offstageRight
                }
            }
            
            // Step 4: make capsure move to narrow width
            UIView.addKeyframe(withRelativeStartTime: 0.875, relativeDuration: 0.1) {
                capsule.bounds = capsuleFrameNarrow
            }
        })
    }
    
    return animator
}

//: [Next](@next)

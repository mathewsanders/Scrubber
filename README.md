# Playground Animation Scrubber 🎚

There are a lot of frameworks and tools for making animations and animated
transitions for your iOS projects.

If you're targeting iOS/tvOS 10.0+, then `UIViewPropertyAnimator` is probably
powerful enough for your needs: It includes the standard easing curves, a nice
implementation of spring physics, an easy way to define your own custom
timing curve, and a scalable API that allows from simple single step
interpolation, to chained, interruptible, and animations that can be modified on
the fly.

## ScrubContainerView
This project doesn't modify or build on top of `UIViewPropertyAnimator`, but
instead provides `ScrubContainerView`, a simple UIView subclass, that makes it
easier to create, explore, debug, and refine an animation in a playground.

1. Start by making a playground and importing `UIKit` and `PlaygroundSupport`

````Swift
import UIKit
import PlaygroundSupport
````

2. Create a new `ScrubContainerView` and make that the playground's `liveView`
(this presents the view in the playground's assistant editor panel.

````Swift
let container = ScrubContainerView()
PlaygroundPage.current.liveView = container
````

3. Next, go ahead an set up the objects to be animated, adding them to the
`stage` view of `ScrubContainerView` and setting their initial positions.

````Swift
let square = UIView()
container.stage.addSubview(square)
square.center = container.stage.center
square.transform = .identity
square.bounds.size = CGSize(width: 150, height: 50)
square.backgroundColor = .red
````

4. Finally, assign `animator` with a closure that returns a
`UIViewPropertyAnimator`. This defines the animations to perform.

````Swift
container.animator = {

    // create the animator with the duration and timing curve
    // (in this case using a spring-physics)
    let animator = UIViewPropertyAnimator(duration: 2.0, dampingRatio: 0.5)

    // define the properties to animate
    animator.addAnimations {
        square.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
        square.bounds.size = CGSize(width: 50, height: 150)
        square.backgroundColor = .blue
    }
    // return the animator
    return animator
}
````

`ScrubContainerView` adds a `UISlider` that lets you scrub through the animation
and look at it at any intermediate step.

<img src="./assets/scrubber-simple-1.gif" width="320">

An option for step #3 is to wrap the expressions that define the stating state
into the `startState` closure:

````Swift
container.startState = {
    square.transform = .identity
    square.bounds.size = CGSize(width: 150, height: 50)
    square.backgroundColor = .red
}
````

If this property is defined `ScrubContainerView` will add a button button that
lets you to watch the animation perform with it's defined duration and timing
curve:

<img src="./assets/scrubber-simple-2.gif" width="320">

### Initializers

A `ScrubContainerView` can be initialized multiple ways. The default initializer
creates a stage width a 300x300 pixel size.

`ScrubContainerView.init(width: Double, height: Double)` allows a stage of any size.

Convenience initializers `ScrubContainerView.init(device: Device)` and
`ScrubContainerView.init(device: Device, orientation: Orientation)` allow for
stages to be created for `Device.iPhoneSE`, `.iPhone`, and .`iPhonePlus` and
orientations `.portrait` or `.landscape`.

### Examples

The playground includes the example above, as well as a [slightly more complex
example](https://github.com/mathewsanders/Scrubber/blob/master/source/Animation.playground/Pages/Keyframe%20example.xcplaygroundpage/Contents.swift)
that includes a 4-step animation chained together using keyframes to show how
more complex multi-step animations can be built, and a blank template ready to
start writing a new animation from scratch.

<img src="./assets/scrubber-chained-1.gif" width="320">

## Roadmap
- [x] UISlider to scrub animations
- [x] Button to play animation with default timing curve and duration
- [x] Initializers for different device sizes
- [ ] Resume animation after scrubbing
- [ ] Pause/resume animation
- [ ] Scrub paused animation

## Requirements

- Swift 3.0
- iOS/tvOS 10.0+

## Author

Made with :heart: by [@permakittens](http://twitter.com/permakittens)

## Contributing

Feedback, or contributions for bug fixing or improvements are welcome. Feel free to submit a pull request or open an issue.

## License

MIT

import UIKit

public class ScrubContainerView: UIView {
    
    private let scrubber: UISlider
    private let playButton: UIButton
    private let resetButton: UIButton
    private var scrubAnimator: UIViewPropertyAnimator?
    
    /// The property animator to drive animations
    public var animator: (() -> UIViewPropertyAnimator)? {
        didSet {
            scrubAnimator = animator?()
        }
    }
    
    /// The start state for objects to be animated
    public var startState: (() -> ())? {
        didSet {
            guard let startState = startState else { return }
            
            startState()
            showButtons()
        }
    }
    
    public convenience init(width: Double, height: Double) {
        self.init(size: CGSize(width: width, height: height))
    }
    
    public init(size: CGSize = CGSize(width: 375, height: 667)) {
        
        playButton = UIButton(type: .system)
        resetButton = UIButton(type: .system)
        scrubber = UISlider()
        
        super.init(frame: CGRect(origin: .zero, size: size))
        
        backgroundColor = .white
        
        playButton.isHidden = true
        resetButton.isHidden = true
        
        let stack = UIStackView()
        stack.alignment = .fill
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 10
        
        stack.frame = CGRect(x: 0, y: size.height - 50, width: size.width, height: 50).insetBy(dx: 10, dy: 0)
        
        stack.addArrangedSubview(playButton)
        stack.addArrangedSubview(scrubber)
        stack.addArrangedSubview(resetButton)
        
        addSubview(stack)
        scrubber.addTarget(self, action: #selector(ScrubContainerView.handleScrub), for: .valueChanged)
    }
    
    private func showButtons() {
        
        playButton.setTitle("Play", for: .normal)
        resetButton.setTitle("Reset", for: .normal)
        
        playButton.addTarget(self, action: #selector(ScrubContainerView.handlePlay), for: .touchDown)
        resetButton.addTarget(self, action: #selector(ScrubContainerView.handleReset), for: .touchDown)
        
        playButton.isHidden = false
        resetButton.isHidden = false
    }
    
    func handlePlay() {
        
        guard let animator = animator?() else { return }
        
        animator.addAnimations {
            self.scrubber.setValue(1.0, animated: true)
        }
        
        playButton.isEnabled = false
        scrubber.isEnabled = false
        
        animator.startAnimation()
    }
    
    func handleReset() {
        
        scrubber.isEnabled = true
        playButton.isEnabled = true
        
        scrubAnimator?.stopAnimation(true)
        scrubAnimator = animator?()
        scrubber.setValue(0.0, animated: true)
        startState?()
    }
    
    func handleScrub() {
        playButton.isEnabled = false
        scrubAnimator?.fractionComplete = CGFloat(scrubber.value)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

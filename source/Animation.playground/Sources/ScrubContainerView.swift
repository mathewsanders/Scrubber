import UIKit

public class ScrubContainerView: UIView {
    
    private let scrubber: UISlider
    private let playButton: UIButton
    private let resetButton: UIButton
    
    private var _animator: UIViewPropertyAnimator?
    
    public var animator: (() -> UIViewPropertyAnimator)? {
        didSet {
            _animator = animator?()
        }
    }
    
    public var startState: (() -> ())? {
        didSet {
            startState?()
            
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
        
        //playButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        
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
    
    public func handlePlay() {
        
        guard let animator = animator?() else { return }
        
        animator.addAnimations {
            
            UIView.animateKeyframes(withDuration: 1, delay: 0, options: [.calculationModePaced], animations: {
                
                self.scrubber.setValue(1.0, animated: true)
            })
        }
        
        playButton.isEnabled = false
        scrubber.isEnabled = false
        
        animator.startAnimation()
        
    }
    
    public func handleReset() {
        
        scrubber.isEnabled = true
        playButton.isEnabled = true
        
        _animator?.stopAnimation(true)
        _animator = animator?()
        scrubber.setValue(0.0, animated: true)
        startState?()
    }
    
    public func handleScrub() {
        playButton.isEnabled = false
        _animator?.fractionComplete = CGFloat(scrubber.value)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

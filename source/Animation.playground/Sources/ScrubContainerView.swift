import UIKit

public class ScrubContainerView: UIView {
    
    private let scrubber: UISlider
    private let playButton: UIButton
    private let resetButton: UIButton
    private var scrubAnimator: UIViewPropertyAnimator?
    private var containerView = UIView()
    private let stack = UIStackView()
    
    public var stage: UIView {
        return containerView
    }
    
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
    
    public enum Device {
        case iPhone
        case iPhonePlus
        case iPhoneSE
        
        var portraitSize: CGSize {
            switch self {
            case .iPhoneSE: return CGSize(width: 320, height: 568)
            case .iPhone: return CGSize(width: 375, height: 667)
            case .iPhonePlus: return CGSize(width: 414, height: 736)
            }
        }
        
        func size(for orientation: Orientation) -> CGSize {
            switch orientation {
            case .portrait: return portraitSize
            case .landscape: return CGSize(width: portraitSize.height, height: portraitSize.width)
            }
        }
    }
    
    public enum Orientation {
        case portrait
        case landscape
    }
    
    public convenience init(width: Double, height: Double) {
        self.init(size: CGSize(width: width, height: height))
    }
    
    public convenience init(device: Device, orientation: Orientation = .portrait) {
        self.init(size: device.size(for: orientation))
    }
    
    public init(size: CGSize = CGSize(width: 300, height: 300)) {
        
        containerView.frame = CGRect(origin: .zero, size: size)
        containerView.backgroundColor = .white
        
        playButton = UIButton(type: .system)
        resetButton = UIButton(type: .system)
        scrubber = UISlider()
        
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: size.width + 20, height: size.height + 60)))
        
        backgroundColor = UIColor.groupTableViewBackground
        containerView.layer.cornerRadius = 4
        addSubview(containerView)
        
        containerView.transform = CGAffineTransform(translationX: 10, y: 10)
        
        playButton.isHidden = true
        resetButton.isHidden = true
        
        stack.alignment = .fill
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        
        stack.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        stack.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        stack.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        stack.addArrangedSubview(playButton)
        stack.addArrangedSubview(scrubber)
        stack.addArrangedSubview(resetButton)
        
        
        scrubber.addTarget(self, action: #selector(ScrubContainerView.handleScrub), for: .valueChanged)
    }
    
    public override func addSubview(_ view: UIView) {
        if view == containerView || view == stack {
            super.addSubview(view)
        }
        else {
            print("adding", view, "to contaier")
            containerView.addSubview(view)
        }
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
        
        animator.addCompletion({ _ in
            self.handleReset()
        })
        
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

# swift-chainable-animations
A μ-framework which makes chaining UIView animations more simple and elegant.

## Background
When using the `UIView.animate` api, you may find yourself using the `completion` to set up a new animation. This can quickly lead to code which is hard to read and suffers from the dreaded Pyramid Of Doom.

![Pyramid Of Doom](https://upload.wikimedia.org/wikipedia/en/0/04/Pyramid_of_Doom.jpg)

## How to get it

### Manually

Download `https://github.com/DomainGroupOSS/swift-chainable-animations/blob/master/ChainableAnimations/UIViewAnimationExtensions.swift` and add it to your project. Job done!
      

### Carthage

```
git "DomainGroupOSS/swift-chainable-animations" "0.1.1"    
```

### Cocoapods

```
pod "SwiftChainableAnimations", "0.1.1" 
```

### Swift Package Manager

`//TODO`

## Usage

`ChainableAnimations` is a single-file μ-framework which provides an alternate `UIView` api:
- Use `.prepareAnimation(...)` to define the first animation...
- ... and `.then(...)` any number of time afterwards to define a chain of linked animations, executed one after another.
- Animations will not be performed until you call `.animate(...)`.
- Parameters for all functions follow the existing `UIView.animate` conventions and will do what you expect them to.

### Before

```swift
UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseIn, animations: {
    self.titleImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
}, completion: { _ in
    UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseOut, animations: {
        self.titleImageView.transform = CGAffineTransform.identity
    }, completion: nil)
})
```

### After
```swift
import ChainableAnimations

UIView.prepareAnimation(withDuration: 0.15, options: .curveEaseIn) {
    self.titleImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
}.then(withDuration: 0.4, options: .curveEaseOut) {
    self.titleImageView.transform = CGAffineTransform.identity
}.animate()
```

### Before
```swift
UIView.animate(withDuration: stageDuration, delay: 0, options: .curveEaseIn, animations: stageOne) { _ in
    UIView.animate(withDuration: stageDuration, delay: 0, options: .curveEaseIn, animations: stageTwo, completion: { _ in
        UIView.animate(withDuration: stageDuration, delay: 0, options: .curveEaseIn, animations: stageThree, completion: nil)
    })
}
```

### After
```swift
import ChainableAnimations

UIView
    .prepareAnimation(withDuration: stageDuration, delay: 0, options: .curveEaseIn, animations: stageOne)
    .then(withDuration: stageDuration, delay: 0, options: .curveEaseIn, animations: stageTwo)
    .then(withDuration: stageDuration, delay: 0, options: .curveEaseIn, animations: stageThree)
    .animate()
```
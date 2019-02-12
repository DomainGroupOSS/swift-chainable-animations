//
//  UIViewAnimationExtensions.swift
//  Domain
//
//  Created by Sam Warner on 8/2/19.
//  Copyright © 2019 Fairfax Digital. All rights reserved.
//

import UIKit

public final class ChainableAnimation {
    
    fileprivate final class Rendered {
        let action: (_ predecessorsSucceeded: Bool) -> Void
        
        init(action: @escaping (_ predecessorsSucceeded: Bool) -> Void) {
            self.action = action
        }
    }
    
    private let duration: TimeInterval
    private let delay: TimeInterval
    private let options: UIView.AnimationOptions
    private let animations: () -> Void
    private let predecessor: ChainableAnimation?
    
    fileprivate init(
        duration: TimeInterval,
        delay: TimeInterval,
        options: UIView.AnimationOptions,
        animations: @escaping () -> Void,
        predecessor: ChainableAnimation?)
    {
        self.duration = duration
        self.delay = delay
        self.options = options
        self.animations = animations
        self.predecessor = predecessor
    }
    
    public func then(
        withDuration: TimeInterval,
        delay: TimeInterval = 0,
        options: UIView.AnimationOptions = [],
        animations: @escaping () -> Void) -> ChainableAnimation
    {
        return ChainableAnimation(
            duration: duration,
            delay: delay,
            options: options,
            animations: animations,
            predecessor: self)
    }
    
    public func animate(completion: ((_ success: Bool) -> Void)? = nil) {
        let chain = self.prepare()
        let render = chain.first?.render(then: chain.dropFirst(), completion: completion)
        render?.action(true)
    }
    
    private func prepare(chain: [ChainableAnimation] = []) -> [ChainableAnimation] {
        if let predecessor = self.predecessor {
            return predecessor.prepare(chain: [self] + chain)
        } else {
            return [self] + chain
        }
    }
    
    private func render(then chain: ArraySlice<ChainableAnimation>, completion: ((_ success: Bool) -> Void)? = nil) -> ChainableAnimation.Rendered {
        let next = chain.first
        let duration = self.duration
        let animations = self.animations
        let completion = next?.render(then: chain.dropFirst()).action ?? completion
        return Rendered { predecessorsSucceeded in
            UIView.animate(withDuration: duration, animations: animations, completion: { thisSucceeded in
                completion?(predecessorsSucceeded && thisSucceeded)
            })
        }
    }
}

public extension UIView {
    
    public static func prepareAnimation(
        withDuration duration: TimeInterval,
        delay: TimeInterval = 0,
        options: UIView.AnimationOptions = [],
        animations: @escaping () -> Void) -> ChainableAnimation
    {
        return ChainableAnimation(
            duration: duration,
            delay: delay,
            options: options,
            animations: animations,
            predecessor: nil
        )
    }
}

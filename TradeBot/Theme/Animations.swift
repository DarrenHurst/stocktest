//
//  Animations.swift
//  test
//
//  Created by Darren Hurst on 2021-04-20.
//
import Foundation
import SwiftUI




extension View {
    func runAnimation() -> Animation {
        Animation.linear(duration: 0.9).repeatForever()
    }
    func runBounce() -> Animation {
        Animation.default.repeatCount(5).speed(2)
    }
    func runSpring() -> Animation {
        Animation.interactiveSpring(response: 2, dampingFraction: 1, blendDuration: 2)
    }
    func stopAnimation() -> Animation {
        Animation.linear(duration: 0.3)
    }
    func runOnce() -> Animation {
        //Animation.easeIn(duration:0.75).speed(1)
        Animation.linear(duration: 0.8).speed(1.5)
    }
}

struct Animations {
  
    var drag = DragGesture()
                .onEnded {
                    if $0.translation.width < -100 {
                        withAnimation {
        
                        }
                    }
                }
    
         // View Modifier for returning this  TODO
        //animation(.interpolatingSpring(stiffness: 50, damping: 1))
}

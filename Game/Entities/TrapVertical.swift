//
//  TrapVertical.swift
//  Game
//
//  Created by Oscar Rossello on 17/05/2019.
//  Copyright © 2019 Oscar Rossello. All rights reserved.
//

import SpriteKit

class TrapVertical: Trap {
    
    override init(path: CGPath, position: CGPoint) {
        super.init(path: path, position: position)
        
        // Set name so we can check for collisions easier
        self.name = "trap_v"
        
        // Adjust Y since position.y is at floor level
        self.position.y += self.frame.height / 2 + CGFloat(range)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func getAnimation() -> SKAction {
        let rand = Float.random(in: 0 ... 1)
        let initialDelay = SKAction.wait(forDuration: TimeInterval(rand))
        let moveDown = SKAction.move(by: CGVector(dx: 0, dy: -range), duration: 0.05)
        let moveUp = SKAction.move(by: CGVector(dx: 0, dy: range), duration: 1)
        let delay = SKAction.wait(forDuration: 0.75)
        let sequence = SKAction.sequence([moveDown, delay, moveUp, delay])
        let loop = SKAction.repeatForever(sequence)
        return SKAction.sequence([initialDelay, loop])
    }
}

//
//  TrapHorizontal.swift
//  Game
//
//  Created by dmorenoar on 18/05/2019.
//  Copyright © 2019 Oscar Rossello. All rights reserved.
//

import SpriteKit

class TrapHorizontal: Trap {
    
    // 1 = RIGHT / -1 = LEFT
    let direction: Int
    
    init(path: CGPath, position: CGPoint, direction: Int) {
        // Make sure direction is always 1 / -1
        self.direction = direction / abs(direction)
        super.init(path: path, position: position)
        
        // Set name so we can check for collisions easier
        self.name = "trap_h"
        
        // Adjust X to make sure Trap doesn't clip a wall
        self.position.x += (self.frame.width / 2) * CGFloat(direction)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func getAnimation() -> SKAction {
        let moveFirst = SKAction.move(by: CGVector(dx: 140 * direction, dy: 0), duration: 0.05)
        let moveSecond = SKAction.move(by: CGVector(dx: -140 * direction, dy: 0), duration: 0.05)
        let delay = SKAction.wait(forDuration: 0.75)
        let sequence = SKAction.sequence([moveFirst, delay, moveSecond, delay])
        let loop = SKAction.repeatForever(sequence)
        return SKAction.sequence([loop])
    }
}

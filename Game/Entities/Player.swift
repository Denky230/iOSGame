//
//  Player.swift
//  Game
//
//  Created by Oscar Rossello on 01/04/2019.
//  Copyright © 2019 Oscar Rossello. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode {
    
    init(spriteNode: SKSpriteNode) {
        super.init(texture: spriteNode.texture, color: spriteNode.color, size: spriteNode.size)
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func move(x: CGFloat) {
        self.physicsBody?.velocity = CGVector(dx: x, dy: (self.physicsBody?.velocity.dy)!)
    }
    
    func jump() {
        self.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 12))
    }
}

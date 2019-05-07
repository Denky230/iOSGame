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
        
        // Set name so we can check for collisions easier
        name = "player"
        // Set Player starting pos to middle of screen
        position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        // Set physics body
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody!.linearDamping = 0
        physicsBody?.restitution  = 0
        physicsBody?.friction = 0
        // Set body collision
        physicsBody?.categoryBitMask = CollisionMasks.player.rawValue
        physicsBody?.collisionBitMask = CollisionMasks.floor.rawValue
        physicsBody?.contactTestBitMask = CollisionMasks.goal.rawValue | CollisionMasks.floor.rawValue
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func move(direction: CGFloat) {
        self.physicsBody?.velocity = CGVector(dx: 200 * direction, dy: (self.physicsBody?.velocity.dy)!)
    }
    
    var isGrounded = false
    func jump() {
        if isGrounded {
            isGrounded = false
            self.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 12))
        }
    }
}

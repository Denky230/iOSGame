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
        self.name = "player"
        // Set Player starting pos to middle of screen
        self.position = CGPoint.zero
        // Set physics body
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody!.linearDamping = 0
        self.physicsBody?.restitution  = 0
        self.physicsBody?.friction = 0
        // Set body collision
        self.physicsBody?.categoryBitMask = CollisionMasks.player.rawValue
        self.physicsBody?.collisionBitMask = CollisionMasks.floor.rawValue | CollisionMasks.trap.rawValue
        self.physicsBody?.contactTestBitMask = CollisionMasks.floor.rawValue | CollisionMasks.trap.rawValue
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

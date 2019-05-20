//
//  Trap.swift
//  Game
//
//  Created by dmorenoar on 07/05/2019.
//  Copyright © 2019 Oscar Rossello. All rights reserved.
//

import SpriteKit

class Trap: SKShapeNode {
    
    let RANGE = 100
    
    init(path: CGPath, position: CGPoint) {
        super.init()
        
        // Set name so we can check for collisions easier
        self.name = "trap"
        
        // Define polygon
        self.path = path
        self.position = position
        
        self.fillColor = .red
        
        // Add physics body so Player can collide with it
        self.physicsBody = SKPhysicsBody(polygonFrom: path)
        self.physicsBody?.categoryBitMask = CollisionMasks.trap.rawValue | CollisionMasks.floor.rawValue
        self.physicsBody?.collisionBitMask = CollisionMasks.player.rawValue | CollisionMasks.floor.rawValue
        self.physicsBody?.isDynamic = false
        
        // Run move Action
        run(getAnimation(), withKey: "move")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Override to set up animations with SKActions
    func getAnimation() -> SKAction {
        return SKAction()
    }
}

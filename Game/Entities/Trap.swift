//
//  Trap.swift
//  Game
//
//  Created by dmorenoar on 07/05/2019.
//  Copyright © 2019 Oscar Rossello. All rights reserved.
//

import SpriteKit

class Trap: SKShapeNode {
    
    private var state: Int = 1 {
        didSet {
            
        }
    }
    
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
        // Add tag so Player dies when colliding
        self.physicsBody?.categoryBitMask = CollisionMasks.trap.rawValue
        self.physicsBody?.collisionBitMask = CollisionMasks.player.rawValue | CollisionMasks.floor.rawValue
        // Make body static so it's not affected by gravity (or other phsx)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.mass = 100
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeState() {
        self.state *= -1
    }
}

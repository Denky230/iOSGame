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
            run(SKAction.move(by: CGVector(dx: 0, dy: -50), duration: 0.5))
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
        self.physicsBody?.categoryBitMask = CollisionMasks.trap.rawValue
        self.physicsBody?.collisionBitMask = CollisionMasks.player.rawValue | CollisionMasks.floor.rawValue
        // Set body dynamic values
        self.physicsBody?.isDynamic = false
        
        run(SKAction.move(by: CGVector(dx: 0, dy: -100), duration: 0.5))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeState() {
        self.state *= -1
    }
}

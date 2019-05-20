//
//  Trap.swift
//  Game
//
//  Created by dmorenoar on 07/05/2019.
//  Copyright © 2019 Oscar Rossello. All rights reserved.
//

import SpriteKit

class Trap: SKShapeNode {
    
    var range = 100
    
    init(path: CGPath, position: CGPoint) {
        super.init()
        
        // Define polygon
        self.path = path
        self.position = position
        
        self.fillColor = .red
        
        // Add physics body so Player can collide with it
        self.physicsBody = SKPhysicsBody(polygonFrom: path)
        self.physicsBody?.categoryBitMask = CollisionMasks.trap.rawValue
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
    // Override to set a new range
    func setRange(_ range: Int) {
        self.range = range
    }
}

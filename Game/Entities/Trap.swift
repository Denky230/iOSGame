//
//  Trap.swift
//  Game
//
//  Created by dmorenoar on 07/05/2019.
//  Copyright © 2019 Oscar Rossello. All rights reserved.
//

import SpriteKit

class Trap: SKShapeNode {
    
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
        self.physicsBody?.isDynamic = false
        
        // Run move Action
        run(getAnimation(), withKey: "move")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Set up animations with SKActions
    func getAnimation() -> SKAction {
        let rand = Float.random(in: 0 ... 1)
        let initialDelay = SKAction.wait(forDuration: TimeInterval(rand))
        let moveDown = SKAction.move(by: CGVector(dx: 0, dy: -100), duration: 0.05)
        let moveUp = SKAction.move(by: CGVector(dx: 0, dy: 100), duration: 1)
        let delay = SKAction.wait(forDuration: 0.75)
        let sequence = SKAction.sequence([moveDown, delay, moveUp, delay])
        let loop = SKAction.repeatForever(sequence)
        return SKAction.sequence([initialDelay, loop])
    }
}

//
//  GameScene.swift
//  Game
//
//  Created by Oscar Rossello on 18/03/2019.
//  Copyright © 2019 Oscar Rossello. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Character
    var player: Player!
    // Other stuff yet to name
    var goal = SKSpriteNode()
    // Environment
    var floor = SKSpriteNode()
    // UI Controls
    var jumpPad = SKSpriteNode()
    var leftPad = SKSpriteNode()
    var rightPad = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        // Handle our own physics
        self.physicsWorld.contactDelegate = self
        // Set game gravity
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -5)
        
        // Initialize game assets
        initPlayer()
        initOtherStuff()
        initEnvironment()
        initControls()
    }
    
    func initPlayer() {
        // Get node from scene
        let playerNode: SKSpriteNode = self.childNode(withName: "player") as! SKSpriteNode
        
        // Initialize Player from scene Player node
        player = Player(spriteNode: playerNode)
        
        // Remove Player node since we don't need it anymore
        self.removeChildren(in: [self.childNode(withName: "player")!])
        
        // Set Player starting pos to middle of screen
        player.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        // Set physics body
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody!.linearDamping = 0
        player.physicsBody?.restitution  = 0
        player.physicsBody?.friction = 0
        // Set body collision
        player.physicsBody?.categoryBitMask = CollisionMasks.player.rawValue
        player.physicsBody?.collisionBitMask = CollisionMasks.floor.rawValue
        player.physicsBody?.contactTestBitMask = CollisionMasks.goal.rawValue
        
        // Add Player to scene
        self.addChild(player)
    }
    func initOtherStuff() {
        // Get node from Scene
        goal = self.childNode(withName: "goal") as! SKSpriteNode
        // Set physics body
        goal.physicsBody = SKPhysicsBody(rectangleOf: goal.size)
        // Make body static so it's not affected by gravity (or other phsx)
        goal.physicsBody!.isDynamic = false
        // Set body collision
        goal.physicsBody?.categoryBitMask = CollisionMasks.goal.rawValue
    }
    func initEnvironment() {
        // Get node from Scene
        floor = self.childNode(withName: "floor") as! SKSpriteNode
        // Set physics body
        floor.physicsBody = SKPhysicsBody(rectangleOf: floor.size)
        // Make body static so it's not affected by gravity (or other phsx)
        floor.physicsBody!.isDynamic = false
        // Set body collision
        floor.physicsBody?.categoryBitMask = CollisionMasks.floor.rawValue    }
    func initControls() {
        // Get jump pad from scene
        jumpPad = self.childNode(withName: "jump") as! SKSpriteNode
        // Set jump pad physics body
        jumpPad.physicsBody = SKPhysicsBody(rectangleOf: jumpPad.size)
        // Make jump pad static so it's not affected by gravity (or other phsx)
        jumpPad.physicsBody!.isDynamic = false
        jumpPad.physicsBody?.categoryBitMask = CollisionMasks.UI.rawValue
        
        // Left pad
        leftPad = self.childNode(withName: "left") as! SKSpriteNode
        leftPad.physicsBody = SKPhysicsBody(rectangleOf: leftPad.size)
        leftPad.physicsBody!.isDynamic = false
        leftPad.physicsBody?.categoryBitMask = CollisionMasks.UI.rawValue
        // Right pad
        rightPad = self.childNode(withName: "right") as! SKSpriteNode
        rightPad.physicsBody = SKPhysicsBody(rectangleOf: rightPad.size)
        rightPad.physicsBody!.isDynamic = false
        rightPad.physicsBody?.categoryBitMask = CollisionMasks.UI.rawValue
    }
    
    var vel: CGFloat = 200
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Loop all touches
        for touch: UITouch in touches {
            // Get location of the touch in this scene
            let location = touch.location(in: self)
            let nodes = self.nodes(at: location)
            if !nodes.isEmpty {
                // Check if location matches any button
                switch (nodes[0]) {
                    case jumpPad: player.jump(); break
                    case leftPad: player.move(x: -vel); break
                    case rightPad: player.move(x: vel); break
                    default: break
                }
            }
        }
    }
    
    // Handle collisions here
    func didBegin(_ contact: SKPhysicsContact) {
        // Collisioning bodies
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        // Check for collision
        if bodyA.categoryBitMask == CollisionMasks.player.rawValue && bodyB.categoryBitMask == CollisionMasks.goal.rawValue || bodyA.categoryBitMask == CollisionMasks.goal.rawValue && bodyB.categoryBitMask == CollisionMasks.player.rawValue {
            
            print("Reached goal!")
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
//        print(player.physicsBody!.velocity)
    }
}

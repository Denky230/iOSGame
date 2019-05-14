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
    
    // Scene
    var scale: Float = 0
    let TOTAL_TILES: Int = 20
    // Character
    var player: Player!
    // Game camera
    let CAMERA_INNER_BOUNDS_PERCENT = 10
    var cam: SKCameraNode!
    // Game timer
    var gameTimerLbl = SKLabelNode(fontNamed: "ArialMT")
    var gameTimer = 10 {
        didSet {
            let mins = gameTimer / 60
            let secs = gameTimer % 60
            // Make sure text is hour formated (m:ss)
            gameTimerLbl.text = String(format: "%d:%02d", mins, secs)
        }
    }
    // UI Controls
    var jumpPad = SKSpriteNode()
    var leftPad = SKSpriteNode()
    var rightPad = SKSpriteNode()
    // Environment
    var floor = SKSpriteNode()
    // Other stuff yet to name
    var goal = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        // Handle our own physics
        self.physicsWorld.contactDelegate = self
        
        // Initialize game assets
        initPlayer()
        initCamera()
        initTimer()
        initOtherStuff()
        initEnvironment()
        initControls()
        initTraps()
        
        scale = Float((self.scene?.frame.width)! / CGFloat(TOTAL_TILES))
    }
    
    func initPlayer() {
        // Create Player SpriteNode
        let playerSpriteNode =
            SKSpriteNode(color: .cyan, size: CGSize(width: 30, height: 30))
        // Initialize Player from Player node
        player = Player(spriteNode: playerSpriteNode)
        // Add Player to scene
        self.addChild(player)
    }
    func initCamera() {
        cam = SKCameraNode()
        cam.zPosition = 1
        self.camera = cam
        self.addChild(cam)
    }
    func initTimer() {
        gameTimerLbl.fontSize = 40
        gameTimerLbl.fontColor = .white
        gameTimerLbl.position = CGPoint(
            x: -size.width / 2 + 50,
            y: size.height / 2 - 50
        )
        cam.addChild(gameTimerLbl)
        
        let wait = SKAction.wait(forDuration: 1)
        let block = SKAction.run({ [unowned self] in
            if self.gameTimer > 0 {
                self.gameTimer -= 1
            } else {
                self.removeAction(forKey: "gameTimer")
                self.gameOver(victory: false)
            }
        })
        let sequence = SKAction.sequence([wait, block])
        run(SKAction.repeatForever(sequence), withKey: "gameTimer")
    }
    func initOtherStuff() {
        // Get node from scene
        goal = self.childNode(withName: "goal") as! SKSpriteNode
        // Set physics body
        goal.physicsBody = SKPhysicsBody(rectangleOf: goal.size)
        // Make body static so it's not affected by gravity (or other phsx)
        goal.physicsBody!.isDynamic = false
        // Set body collision
        goal.physicsBody?.categoryBitMask = CollisionMasks.goal.rawValue
        goal.physicsBody?.collisionBitMask = 0
    }
    func initEnvironment() {
        // Get node from scene
        floor = self.childNode(withName: "floor") as! SKSpriteNode
        // Set physics body
        floor.physicsBody = SKPhysicsBody(rectangleOf: floor.size)
        // Make body static so it's not affected by gravity (or other phsx)
        floor.physicsBody!.isDynamic = false
        // Set body collision
        floor.physicsBody?.categoryBitMask = CollisionMasks.floor.rawValue        
    }
    func initControls() {
        jumpPad = SKSpriteNode(color: .yellow, size: CGSize(width: 80, height: 80))
        jumpPad.position = CGPoint(x: 280, y: -40)
        // Set jump pad physics body
        jumpPad.physicsBody = SKPhysicsBody(rectangleOf: jumpPad.size)
        // Make jump pad static so it's not affected by gravity (or other phsx)
        jumpPad.physicsBody!.isDynamic = false
        jumpPad.physicsBody?.categoryBitMask = CollisionMasks.UI.rawValue
        // Add jump pad to camera so it becomes part of the UI
        cam.addChild(jumpPad)
        // Left pad
        leftPad = SKSpriteNode(color: .green, size: CGSize(width: 50, height: 50))
        leftPad.position = CGPoint(x: -295  , y: -55)
        leftPad.physicsBody = SKPhysicsBody(rectangleOf: leftPad.size)
        leftPad.physicsBody!.isDynamic = false
        leftPad.physicsBody?.categoryBitMask = CollisionMasks.UI.rawValue
        cam.addChild(leftPad)
        // Right pad
        rightPad = SKSpriteNode(color: .green, size: CGSize(width: 50, height: 50))
        rightPad.position = CGPoint(x: -215, y: -55)
        rightPad.physicsBody = SKPhysicsBody(rectangleOf: rightPad.size)
        rightPad.physicsBody!.isDynamic = false
        rightPad.physicsBody?.categoryBitMask = CollisionMasks.UI.rawValue
        cam.addChild(rightPad)
    }
    func initTraps() {
        scene!.enumerateChildNodes(withName: "trap") {
            (node, stop) in
            
            self.drawRectangle(x: Int(node.position.x))
            self.removeChildren(in: [node])
        }
        
    }
    
    func drawRectangle(x: Int) {
        let rect = SKShapeNode(rectOf: CGSize(width: 80, height: 80))
        rect.position = CGPoint(x: x, y: 50)
        let box = Trap(path: rect.path!, position: rect.position)
        self.addChild(box)
    }
    func drawTriangle() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0.0, y: 50.0))
        path.addLine(to: CGPoint(x: 50.0, y: -36.6))
        path.addLine(to: CGPoint(x: -50.0, y: -36.6))
        path.addLine(to: CGPoint(x: 0.0, y: 50.0))
        let tri = SKShapeNode(path: path.cgPath)
        self.addChild(tri)
    }
    
    func gameOver(victory: Bool) {
        print( victory ? "Winwin" : "U ded" )
    }
    
    // Handle screen touches here
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
                    case leftPad: player.movePro(direction: -1); break
                    case rightPad: player.movePro(direction: 1); break
                    default: break
                }
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Stop Player X movement every frame
        player.removeAction(forKey: "move")
    }
    
    // Handle collisions here
    func didBegin(_ contact: SKPhysicsContact) {
        // Collisioning bodies
        guard var bodyA = contact.bodyA.node else { return }
        guard var bodyB = contact.bodyB.node else { return }
        
        // Make sure bodyA is the one with CollisionMask closer to 0
        if bodyA.physicsBody!.categoryBitMask >
            bodyB.physicsBody!.categoryBitMask {
            bodyA = contact.bodyB.node!
            bodyB = contact.bodyA.node!
        }
        
        let bA = bodyA.name!
        let bB = bodyB.name!
        
        // Check for collisions
        if bA == "player" && bB == "goal" {
            gameOver(victory: true)
        }
        else if bA == "player" && bB == "floor" {
            player.isGrounded = true
        }
        else if bA == "player" && bB == "trap" {
            // Check if Player hit lower part of Trap
            let diff = abs(bodyB.frame.minY - contact.contactPoint.y)
            if diff < 0.5 {
                gameOver(victory: false)
            }
        }
    }
    
    // Handle physics here
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        let sceneWidth = (self.scene?.frame.width)!
        let camInnerBoundsW = sceneWidth / CGFloat(100 / CAMERA_INNER_BOUNDS_PERCENT)
        let playerToCameraX = player.position.x - cam.position.x
        
        // Check if Player is out of camera inner bounds
        if abs(playerToCameraX) > camInnerBoundsW {
            // Update camera position
            let camInnerBoundCloserToPlayer = cam.position.x +
                (playerToCameraX > 0 ? camInnerBoundsW : -camInnerBoundsW)
            cam.position.x += player.position.x - camInnerBoundCloserToPlayer
        }
    }
}

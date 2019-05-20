//
//  GameScene.swift
//  Game
//
//  Created by Oscar Rossello on 18/03/2019.
//  Copyright © 2019 Oscar Rossello. All rights reserved.
//

import SpriteKit
import GameplayKit

var win = false
var gameTimerLbl = SKLabelNode(fontNamed: "ArialMT")

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Character
    var player: Player!
    // Game camera
    let CAMERA_INNER_BOUNDS_SCREEN_PERCENT = 20
    var cam: SKCameraNode!
    // Game timer
    let GAME_TIME_SECONDS = 30
    var gameTimer = 0 {
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
        gameTimer = GAME_TIME_SECONDS
        gameTimerLbl.fontSize = 40
        gameTimerLbl.fontColor = .red
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
        let goal = self.childNode(withName: "goal") as! SKSpriteNode
        // Set physics body
        goal.physicsBody = SKPhysicsBody(rectangleOf: goal.size)
        goal.physicsBody?.categoryBitMask = CollisionMasks.goal.rawValue
        goal.physicsBody?.collisionBitMask = 0
        // Make body static so it's not affected by gravity (or other phsx)
        goal.physicsBody!.isDynamic = false
        
        // Same for death collider
        let death = self.childNode(withName: "death") as! SKSpriteNode
        death.physicsBody = SKPhysicsBody(rectangleOf: death.size)
        death.physicsBody?.categoryBitMask = CollisionMasks.death.rawValue
        death.physicsBody?.collisionBitMask = 0
        death.physicsBody!.isDynamic = false
    }
    func initEnvironment() {
        scene!.enumerateChildNodes(withName: "floor") {
            (node, stop) in
            
            // For every "floor" node found in scene...
            // Set physics body
            let spriteNode: SKSpriteNode = node as! SKSpriteNode            
            node.physicsBody = SKPhysicsBody(rectangleOf: spriteNode.size)
            node.physicsBody?.categoryBitMask = CollisionMasks.floor.rawValue
            // Make body static so it's not affected by gravity (or other phsx)
            node.physicsBody!.isDynamic = false
        }
    }
    func initControls() {
        jumpPad = SKSpriteNode(color: .yellow, size: CGSize(width: 80, height: 80))
        jumpPad.position = CGPoint(x: 280, y: -40)
        // Set jump pad physics body
        jumpPad.physicsBody = SKPhysicsBody(rectangleOf: jumpPad.size)
        jumpPad.physicsBody?.categoryBitMask = CollisionMasks.UI.rawValue
        // Make jump pad static so it's not affected by gravity (or other phsx)
        jumpPad.physicsBody!.isDynamic = false
        // Add jump pad to camera so it becomes part of the UI
        cam.addChild(jumpPad)
        
        // Left pad
        leftPad = SKSpriteNode(color: .green, size: CGSize(width: 50, height: 50))
        leftPad.position = CGPoint(x: -295  , y: -55)
        leftPad.physicsBody = SKPhysicsBody(rectangleOf: leftPad.size)
        leftPad.physicsBody?.categoryBitMask = CollisionMasks.UI.rawValue
        leftPad.physicsBody!.isDynamic = false
        cam.addChild(leftPad)
        
        // Right pad
        rightPad = SKSpriteNode(color: .green, size: CGSize(width: 50, height: 50))
        rightPad.position = CGPoint(x: -215, y: -55)
        rightPad.physicsBody = SKPhysicsBody(rectangleOf: rightPad.size)
        rightPad.physicsBody?.categoryBitMask = CollisionMasks.UI.rawValue
        rightPad.physicsBody!.isDynamic = false
        cam.addChild(rightPad)
    }
    func initTraps() {
        // Draw vertical Traps
        scene!.enumerateChildNodes(withName: "trap_v") {
            (node, stop) in
            
            // For every "trap_v" node found in scene, instantiate a TrapVertical
            let rect = self.makeTrapRect(x: Int(node.position.x), y: Int(node.frame.minY))
            let vTrap = TrapVertical(path: rect.path!, position: rect.position)
            self.addChild(vTrap)
            self.removeChildren(in: [node])
        }
        
        // Draw horizontal Traps
        scene!.enumerateChildNodes(withName: "trap_h") {
            (node, stop) in
            
            // For every "trap" node found in scene, instantiate a TrapHorizontal
            let rect = self.makeTrapRect(x: Int(node.position.x), y: Int(node.frame.midY))
            let hTrap = TrapHorizontal(path: rect.path!, position: rect.position, direction: -1)
            self.addChild(hTrap)
            self.removeChildren(in: [node])
        }
    }
    
    func makeTrapRect(x: Int, y: Int) -> SKShapeNode {
        let size = 80
        let rect = SKShapeNode(rectOf: CGSize(width: size, height: size))
        rect.position = CGPoint(x: x, y: y)
        return rect
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
        // Set victory / defeat state
        win = victory
        
        // Send to GameOver screen
        let gameOverScene: GameOverScene = GameOverScene(size: self.size)
        gameOverScene.scaleMode = .aspectFill
        self.view?.presentScene(gameOverScene, transition: SKTransition.crossFade(withDuration: 1.0))
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
                    case leftPad: player.move(direction: -1); break
                    case rightPad: player.move(direction: 1); break
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
        
        // QoL variables
        guard let bA = CollisionMasks.init(rawValue: bodyA.physicsBody!.categoryBitMask) else { return }
        guard let bB = CollisionMasks.init(rawValue: bodyB.physicsBody!.categoryBitMask) else { return }
        
        // Check for collisions
        if bA == .player && bB == .goal {
            gameOver(victory: true)
        }
        else if bA == .player && bB == .trap {
            // Check if Player is inside Trap
            if player.frame.minX < bodyB.frame.maxX && player.frame.minX > bodyB.frame.minX || player.frame.maxX > bodyB.frame.minX && player.frame.maxX < bodyB.frame.maxX {
                
                // Check if Player hit lower part of Trap
                let diff = abs(bodyB.frame.minY - contact.contactPoint.y)
                if diff < 10 && diff > 0 {
                    gameOver(victory: false)
                }
            }
        }
        else if bA == .player && bB == .floor {
            // If Player is falling, reset jump
            if player.physicsBody!.velocity.dy > 0 {
                player.isGrounded = true
            }
        }
        else if bA == .player && bB == .death {
            gameOver(victory: false)
        }
        
        print(bA)
        print(" ")
        print(bB)
    }
    
    // Handle physics here
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        let sceneWidth = (self.scene?.frame.width)!
        let camInnerBoundsW = sceneWidth / CGFloat(100 / CAMERA_INNER_BOUNDS_SCREEN_PERCENT)
        let camInnerBoundsRadius = camInnerBoundsW / 2
        let playerToCameraX = player.position.x - cam.position.x
        
        // Check if Player is out of camera inner bounds
        if abs(playerToCameraX) > camInnerBoundsRadius {
            // Update camera position on X
            let camInnerBoundCloserToPlayer = cam.position.x +
                (playerToCameraX > 0 ? camInnerBoundsRadius : -camInnerBoundsRadius)
            cam.position.x += player.position.x - camInnerBoundCloserToPlayer
        }
        
        // Camera follows Player on Y
        let cameraOffsetY: CGFloat = 100
        cam.position.y = player.position.y + cameraOffsetY
    }
}

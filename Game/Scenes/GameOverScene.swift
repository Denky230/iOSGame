//
//  GameOverScene.swift
//  SpaceInvaders
//
//  Created by Carlos Butron on 24/04/2019.
//  Copyright © 2019 Stucom. All rights reserved.
//

import UIKit
import SpriteKit

class GameOverScene: SKScene {
    
    var contentCreated = false

    override func didMove(to view: SKView) {
        if !contentCreated {
            initContent()
            contentCreated = true
        }
    }
    
    func initContent() {
        backgroundColor = .black
        
        let scoreLabel = SKLabelNode(fontNamed: "Futura")
        scoreLabel.fontSize = 40
        scoreLabel.fontColor = .white
        scoreLabel.text = "Score - \(gameTimerLbl.text!)"
        scoreLabel.position = CGPoint(
            x: self.size.width / 2,
            y: self.size.height * 0.50
        )
        addChild(scoreLabel)
        
        let gameOverLabel = SKLabelNode(fontNamed: "Futura")
        gameOverLabel.fontSize = 60
        gameOverLabel.fontColor = .white
        gameOverLabel.text = "GAME OVER"
        gameOverLabel.position = CGPoint(
            x: self.size.width / 2,
            y: self.size.height * 2.0 / 3.0
        )
        addChild(gameOverLabel)
        
        let playAgainLabel = SKLabelNode(fontNamed: "Futura")
        playAgainLabel.fontSize = 22
        playAgainLabel.fontColor = .white
        playAgainLabel.text = "Tap to try again"
        playAgainLabel.position = CGPoint(
            x: self.size.width / 2,
            y: self.size.height * 0.20
        )
        addChild(playAgainLabel)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let scene = SKScene(fileNamed: "GameScene") {
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            // Present the scene
            view?.presentScene(scene)
        }
    }
}

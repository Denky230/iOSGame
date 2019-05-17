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
        
        // Screen title
        let titleLabel = SKLabelNode(fontNamed: "Futura")
        titleLabel.fontSize = 60
        titleLabel.fontColor = .white
        titleLabel.position = CGPoint(
            x: self.size.width / 2,
            y: self.size.height * 0.75
        )
        addChild(titleLabel)
        
        // Play again label
        let playAgainLabel = SKLabelNode(fontNamed: "Futura")
        playAgainLabel.fontSize = 22
        playAgainLabel.fontColor = .white
        playAgainLabel.text = "Tap to try again"
        playAgainLabel.position = CGPoint(
            x: self.size.width / 2,
            y: self.size.height * 0.20
        )
        addChild(playAgainLabel)
        
        // Check victory / defeat game state
        if win {
            titleLabel.text = "VICTORY!"
            
            // Score label
            let scoreLabel = SKLabelNode(fontNamed: "Futura")
            scoreLabel.fontSize = 40
            scoreLabel.fontColor = .white
            scoreLabel.text = "Score - \(gameTimerLbl.text!)"
            scoreLabel.position = CGPoint(
                x: self.size.width / 2,
                y: self.size.height * 0.50
            )
            addChild(scoreLabel)
            
        } else {
            titleLabel.text = "GAME OVER :("
        }
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

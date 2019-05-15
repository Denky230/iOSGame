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
    
    func initContent(){
        
        backgroundColor = .black
        
        let gameOverLabel = SKLabelNode(fontNamed: "Futura")
        gameOverLabel.fontSize = 40
        gameOverLabel.fontColor = .white
        gameOverLabel.text = "GAME OVER"
        gameOverLabel.position = CGPoint(x: self.size.width/2, y: 2.0/3.0*self.size.height)
        addChild(gameOverLabel)
        
        let playAgainLabel = SKLabelNode(fontNamed: "Futura")
        playAgainLabel.fontSize = 22
        playAgainLabel.fontColor = .white
        playAgainLabel.text = "Tap to play again"
        playAgainLabel.position = CGPoint(x: self.size.width/2, y: 1.0/3.0*self.size.height)
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

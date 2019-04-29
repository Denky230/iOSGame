//
//  Goal.swift
//  Game
//
//  Created by Oscar Rossello on 29/04/2019.
//  Copyright © 2019 Oscar Rossello. All rights reserved.
//

import SpriteKit

class Goal: SKSpriteNode {
    
    init(spriteNode: SKSpriteNode) {
        super.init(texture: spriteNode.texture, color: spriteNode.color, size: spriteNode.size)
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

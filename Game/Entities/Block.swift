//
//  Block.swift
//  Game
//
//  Created by Oscar Rossello on 07/05/2019.
//  Copyright © 2019 Oscar Rossello. All rights reserved.
//

import SpriteKit

class Block: Trap {
    
    override init(path: CGPath, position: CGPoint) {
        super.init(path: path, position: position)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

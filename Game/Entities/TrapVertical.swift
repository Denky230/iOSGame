//
//  TrapVertical.swift
//  Game
//
//  Created by Oscar Rossello on 17/05/2019.
//  Copyright © 2019 Oscar Rossello. All rights reserved.
//

import SpriteKit

class TrapVertical: Trap {
    
    override init(path: CGPath, position: CGPoint) {
        super.init(path: path, position: position)
        
        // Set name so we can check for collisions easier
        self.name = "trap_v"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

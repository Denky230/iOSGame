//
//  CollisionMasks.swift
//  Game
//
//  Created by Oscar Rossello on 26/03/2019.
//  Copyright © 2019 Oscar Rossello. All rights reserved.
//

enum CollisionMasks: UInt32 {
    
    case controls = 1
    case player = 2
    case floor = 4
    case trap = 8
}

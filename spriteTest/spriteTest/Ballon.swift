//
//  Ballon.swift
//  spriteTest
//
//  Created by Samieh Sadeghi on 2020-03-07.
//  Copyright © 2020 Samieh Sadeghi. All rights reserved.
//

import Foundation
import SpriteKit

class Ballon: SKNode {
    
    init(image:SKSpriteNode){
        super.init()
        self.setScale(0.3)
        
       
        
      //  self.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: image.name ?? "red"), size: CGSize(width: 10, height: 10))
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: max(10,
        10))
        
        self.physicsBody?.isDynamic = true
        self.addChild(image)
        
}
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

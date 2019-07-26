//
//  GameScene.swift
//  AdventureGame
//
//  Created by Gray on 7/25/19.
//  Copyright © 2019 Gray. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    fileprivate var storeNode: SKShapeNode?
    
    override func didMove(to view: SKView) {
        
        self.storeNode = self.childNode(withName: "store") as? SKShapeNode
        if let storeNode = self.storeNode {
            storeNode.strokeColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            storeNode.updateAvatar(image: #imageLiteral(resourceName: "avatar"))
            storeNode.updateName(name: "apple")
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {

        if let storeNode = self.storeNode?.copy() as? SKShapeNode {
            storeNode.position = pos
            self.addChild(storeNode)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

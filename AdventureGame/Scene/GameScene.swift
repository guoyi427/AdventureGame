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
    fileprivate var cameraNode: SKCameraNode?
    
    fileprivate var touchBeganPoint: CGPoint?
    
    
    override func didMove(to view: SKView) {
        
        cameraNode = SKCameraNode.init()
        if let camera = cameraNode {
            self.addChild(camera)
//            camera.position.x = self.size.width / 2
//            camera.position.y = self.size.height / 2
        }
        camera = cameraNode
        
//        self.backgroundColor = SKColor.white
//        self.size = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height * 2)
//        self.scaleMode = .resizeFill
        
        let storeNodeFromScene = self.childNode(withName: "store") as? SKShapeNode
        self.storeNode = storeNodeFromScene?.copy() as? SKShapeNode
//        storeNodeFromScene?.removeFromParent()
        
        if let storeNode = self.storeNode {
            storeNode.strokeColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            storeNode.updateAvatar(image: #imageLiteral(resourceName: "avatar"))
            storeNode.updateName(name: "apple")
            storeNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat.pi * 2, duration: 1)))
            storeNode.run(SKAction.sequence([SKAction.wait(forDuration: 1), SKAction.removeFromParent()]))
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {

        if let storeNode = self.storeNode?.copy() as? SKShapeNode {
            storeNode.position = pos
            self.addChild(storeNode)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let storeNode = self.storeNode?.copy() as? SKShapeNode {
            storeNode.position = pos
            self.addChild(storeNode)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
        
        if let touch = touches.first {
            let position = touch.location(in: self)
            touchBeganPoint = position
            if let camera = camera {
                camera.position.x = position.x
                camera.position.y = position.y
                print("postion = \(position) and camera postion = \(camera.position)")
            }
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
        if let touch = touches.first {
            let position = touch.location(in: self)
            if let camera = camera {
                camera.position.x = position.x - touchBeganPoint!.x
                camera.position.y = position.y - touchBeganPoint!.y
            }
        }
      
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

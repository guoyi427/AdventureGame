//
//  StoreNode.swift
//  AdventureGame
//
//  Created by Gray on 7/25/19.
//  Copyright © 2019 Gray. All rights reserved.
//

import SpriteKit

extension SKShapeNode {
    
    func updateAvatar(image: UIImage) {
        if let avatarNode = self.childNode(withName: "avatar") as? SKShapeNode {
            avatarNode.fillTexture = SKTexture(image: image)
            avatarNode.strokeColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        }
    }
    
    func updateName(name: String) {
        if let nameLabel = self.childNode(withName: "nameLabel") as? SKLabelNode {
            nameLabel.text = name
            nameLabel.fontColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        }
    }
}

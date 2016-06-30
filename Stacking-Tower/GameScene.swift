//
//  GameScene.swift
//  Stacking-Tower
//
//  Created by mitchell hudson on 6/29/16.
//  Copyright (c) 2016 mitchell hudson. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let stackFallRate:CGFloat = 0.5
    let pieceExitTime: NSTimeInterval = 0.2
    let startingStackCount: Int = 10
    
    var stack = [SKSpriteNode]()
    var hue: CGFloat = 0
    
    func addPiece() {
        hue += 0.1
        let color = UIColor(hue: hue % 1, saturation: 1, brightness: 1, alpha: 1)
        let pieceSize = CGSize(width: 100, height: 40)
        let piece = SKSpriteNode(color: color, size: pieceSize)
        
        addChild(piece)
        stack.append(piece)
        
        piece.position.x = view!.frame.size.width / 2
        piece.position.y = CGFloat(stack.count * 40)
        
    }
    
    
    func removePiece() {
        let piece = stack.removeFirst()
        let movePiece = SKAction.moveToX(-50, duration: pieceExitTime)
        let removePiece = SKAction.removeFromParent()
        piece.runAction(SKAction.sequence([movePiece, removePiece]))
    }
    
    
    override func didMoveToView(view: SKView) {
        
        
        // Make 10 pieces 
        for _ in 1...startingStackCount {
            addPiece()
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        removePiece()
        addPiece()
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        var n: CGFloat = 0
        for piece in stack {
            let y = (n * 40) + 40
            piece.position.y -= (piece.position.y - y) * stackFallRate
            
            n += 1
        }
    }
}

//
//  GameScene.swift
//  Stacking-Tower
//
//  Created by mitchell hudson on 6/29/16.
//  Copyright (c) 2016 mitchell hudson. All rights reserved.
//


// This is a simple example showing the mechanic of Timberman. 
// Pieces are removed from the stack by tapping the screen. 
// A piece flies off the left side when the tap is on the right of the screen, 
// and off the right when the tap is on the left.



import SpriteKit


// Use this to keep track of direction left or Right.

enum Direction {
    case Left, Right
}




class GameScene: SKScene {
    
    // These variables adjust the animation. Play with these values.
    
    let stackFallRate:CGFloat = 0.25
    let pieceExitTime: NSTimeInterval = 0.5
    let startingStackCount: Int = 10
    let pieceExitRation: CGFloat = 90
    let pieceWidth: CGFloat = 100
    let pieceHeight: CGFloat = 50
    
    
    // These variables run the program.
    
    var stack = [SKSpriteNode]()
    var hue: CGFloat = 0
    
    
    /** Add a new piece to the top of the stack */
    
    func addPiece() {
        hue += 0.1
        let color = UIColor(hue: hue % 1, saturation: 1, brightness: 1, alpha: 1)
        let pieceSize = CGSize(width: pieceWidth, height: pieceHeight)
        let piece = SKSpriteNode(color: color, size: pieceSize)
        
        addChild(piece)
        stack.append(piece)
        
        piece.position.x = view!.frame.size.width / 2
        piece.position.y = CGFloat(stack.count) * pieceHeight
        
    }
    
    
    /** 
     Removes a pieces from the stack. Supply the direction the piece will be
     removed from.
    */
    
    func removePiece(direction: Direction) {
        // Find the distance the piece needs to move. This is hald the screen plus half the piece width
        let distance = view!.frame.width / 2 + pieceWidth / 2
        var targetX = distance
        // Set the rotation value the piece will turn to. The value above is in degrees
        // convert to radians here.
        var targetR = pieceExitRation * CGFloat(M_PI) / 180
        if direction == .Left {
            targetX += distance // send the piece to the left and rotate CCW
        } else {
            targetX -= distance // Send the piece to te right and rotate CW
            targetR = -targetR
        }
        
        // Remove the piece from the stack.
        let piece = stack.removeFirst()
        
        // Build an action here that will move, rotate and remove the piece.
        let movePiece = SKAction.moveToX(targetX, duration: pieceExitTime)
        let rotatePiece = SKAction.rotateByAngle(targetR, duration: pieceExitTime)
        // Group move and rotate so they happen at the same time.
        let moveAndRotate = SKAction.group([movePiece, rotatePiece])
        let removePiece = SKAction.removeFromParent()
        // Create a sequence to remove the piece after the move and rotate.
        piece.runAction(SKAction.sequence([moveAndRotate, removePiece]))
    }
    
    
    
    /** Did Move to view */
    
    override func didMoveToView(view: SKView) {
        // Make 10 pieces 
        for _ in 1...startingStackCount {
            addPiece()
        }
    }
    
    
    /** Handle touch events */
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        if let touch = touches.first {
            let location = touch.locationInNode(self)
            if location.x > view!.frame.size.width / 2 {
                // Tap was on the right
                removePiece(.Right)
            } else {
                // Tap was on the left
                removePiece(.Left)
            }
            
            // Add a new piece
            addPiece()
        }
    }
    
    
    /** Update */
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        // To keep the pieces moving down loop through the stack each update 
        // and move each piece down. 
        var n: CGFloat = 0
        for piece in stack {
            let y = (n * pieceHeight) + pieceHeight
            piece.position.y -= (piece.position.y - y) * stackFallRate
            
            n += 1
        }
    }
}

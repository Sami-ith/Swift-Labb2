//
//  MainScene.swift
//  spriteTest
//
//  Created by Samieh Sadeghi on 2020-03-11.
//  Copyright © 2020 Samieh Sadeghi. All rights reserved.
//
import AVFoundation
import SpriteKit
import CoreData
/*
 First scene include: logo,high score label and play button
 high score will set from core data and user can start to play game by click on Play button
 */
class MainScene: SKScene {
    var scoreLbl:SKLabelNode!
    var highScore:Int=0
    
   var backgroundMusic: SKAudioNode!
    let logo=SKSpriteNode(imageNamed: "logo")
    override func didMove(to view: SKView) {
      
      initialize()
        
        
    }
    /*
    Initialize function
    Include: play music and set logo and play button as a spritenodes, fetch data from core data and set high score label
    */
    func initialize() {
        backgroundColor = .white
        
        setMusic()
        fetchMaxID()
        setScore()
        
        logo.setScale(0.5)
        logo.position = CGPoint(x:0,y:UIScreen.main.bounds.height/2-200)
        self.addChild(logo)
    
        let play=SKSpriteNode(imageNamed: "play")
        play.setScale(0.2)
        play.name="play"
        play.position=CGPoint(x:0,y:scoreLbl.frame.minY-200)
        self.addChild(play)
       
        let rotate = SKAction.rotate(byAngle: -1, duration: 0.5)
        let repeatRotation = SKAction.repeatForever(rotate)
        play.run(repeatRotation)
    }
    
    func setScore(){
        
        scoreLbl = SKLabelNode(fontNamed: "Chalkduster")
        scoreLbl.text = "High Score:\(highScore)"
          
        scoreLbl.fontSize = 30
        scoreLbl.fontColor=UIColor.black
        scoreLbl.position=CGPoint(x:0,y:0)
        self.addChild(scoreLbl)
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches{
            let touchLocation = touch.location(in: self)
            let targetNode :SKNode?=atPoint(touchLocation)
            if (targetNode?.name) != nil && targetNode?.name=="play"
            {
                setButtonSound()
                let view = self.view
                let gamePlay=GameScene(fileNamed: "GameScene")
                gamePlay?.size=(view?.bounds.size)!
                gamePlay?.scaleMode = .aspectFill
                 self.view?.presentScene(gamePlay!,transition:.doorsOpenVertical(withDuration: 2))
            }//if
    }//for
}
    
    func setMusic(){
    run (SKAction.playSoundFileNamed("start.mp3",waitForCompletion: true))
    
}
    func setButtonSound()
    {
       run (SKAction.playSoundFileNamed("buttonSound.mp3",waitForCompletion: true))
    }
    
    //Array of scores will sorted decending and first elemnt will pick up as high score
    func fetchMaxID() {
    let appDelegate=UIApplication.shared.delegate as! AppDelegate
     let context=appDelegate.persistentContainer.viewContext
    // let entity=NSEntityDescription.entity(forEntityName: "Game", in: context)
    
     let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Game")
    
    fetchRequest.fetchLimit = 1
    let sortDescriptor = NSSortDescriptor(key: "score", ascending: false)
    fetchRequest.sortDescriptors = [sortDescriptor]
    do {
        let results = try context.fetch(fetchRequest) as! [Game]
        if (results.count > 0) {
            for result in results {
                
                highScore=Int(result.score)
            }
        } else {
            print("No score")
        }
    } catch let error as NSError {
        // failure
        print("Fetch failed: \(error.localizedDescription)")
    }

        }
}
    
    






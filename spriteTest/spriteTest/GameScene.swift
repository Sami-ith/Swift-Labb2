//
//  GameScene.swift
//  spriteTest
//
//  Created by Samieh Sadeghi on 2020-03-07.
//  Copyright © 2020 Samieh Sadeghi. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreData
/*
 Several balloons by random colors and a label will show at the same time.
 The label has color and text(color name), the user should click on balloons that are the same color as the label text(not the color of text).
 */

class GameScene: SKScene {
    
  
    var backgroundMusic: SKAudioNode!
    var scoreLbl:SKLabelNode!
    var myLabel = SKLabelNode()
    var musicOn:Bool?=true
    var background = SKSpriteNode()
    var score:Int=0
    var highScore:Int!
    var musicIcon:SKSpriteNode!
    var musicIconImg:String!
    let array = ["red", "blue", "green", "black","gray","yellow"]
   
    override func didMove(to view: SKView) {
   
        self.isUserInteractionEnabled=true
        
       score=0
       setBackground()
       fetchData()
       setIcons()
       setMusic()
       setScore()
        
        
       run(SKAction.repeatForever(
        SKAction.sequence([
            SKAction.run(spawnBallon),SKAction.wait(forDuration: 1), SKAction.run(createText),SKAction.wait(forDuration: 2),])
       ))
        
        
    }
    //Set sky image for background and move it
    func setBackground(){
     

        for i in 0 ... 2 {
            let background = SKSpriteNode(imageNamed: "background")
            
            background.zPosition = -30
            
            background.size=self.size
            background.position = CGPoint(x:CGFloat(i)*background.size.width,y:0)
            addChild(background)
        
            let moveLeft = SKAction.moveBy(x: -background.size.width, y: 0, duration: 20)
            let moveReset = SKAction.moveBy(x: background.size.width, y: 0, duration: 0)
        let moveLoop = SKAction.sequence([moveLeft, moveReset])
        let moveForever = SKAction.repeatForever(moveLoop)

        background.run(moveForever)
        }
        
    }
 /*
     Creates an array of positions to spawn balloons.
     balloons will create as a Balloon class that has an image as parameter.
     */
    func spawnBallon(){
        let posArr = setPosition()
        for pos in posArr {
            physicsWorld.gravity=CGVector(dx: 0,dy: -0.5)
            let randomColor=array.randomElement()!
            
            let b=SKSpriteNode(imageNamed: randomColor)
            b.name=randomColor
            let ballon = Ballon(image:b )
            ballon.position=pos
            ballon.zPosition = -1
            self.addChild(ballon)
            
        }
    
    }
    //A function to create an array of positions based on UIscreen bounds.
    func setPosition()->[CGPoint]{
        let yPos=UIScreen.main.bounds.maxY
        let xPos=UIScreen.main.bounds.minX
        
        var posArr = [CGPoint]()
        for i in -2...2 {
            
            posArr.append(CGPoint(x: CGFloat((xPos+50)*CGFloat(i)), y: yPos ))
        }
        
        return posArr
        
    }
   /*
     During the game we need to have random color for label and balloons, this function will return color(UIcolor) based on color name(string).
     */
    func setColor(str:String)->UIColor{
        switch str {
        case "red":
            return UIColor.red
        case "green":
            return UIColor.green
        case "blue":
            return UIColor.blue
        case "yellow":
            return UIColor.yellow
        case "gray":
            return UIColor.gray
        default:
            return UIColor.black
        }
    }
    /*
     For every session, score starts from 0 and will update and this function set Scores label properties.
     */
    func setScore(){
        scoreLbl = SKLabelNode(fontNamed: "Chalkduster")
        scoreLbl.text = "Score:\(score)"
        scoreLbl.zPosition = 0
        scoreLbl.fontSize = 50
        scoreLbl.fontColor=UIColor.black
        scoreLbl.position=CGPoint(x:UIScreen.main.bounds.minX,y:-(UIScreen.main.bounds.height/2 - 100.0))
        self.addChild(scoreLbl)
        
    }
    
    func updateScore(){
        scoreLbl.text = "Score:\(score)"
    }
//Creates a SKLabelNode and all properties will set such as random color and text,position and action.
    func createText()
    {
        myLabel = SKLabelNode(fontNamed: "Chalkduster")
        myLabel.text = array.randomElement()
        myLabel.fontSize = 50
        myLabel.zPosition = -1
        myLabel.fontColor=setColor(str: array.randomElement() ?? "black")
        myLabel.position = CGPoint(x:0, y:0)
        self.addChild(myLabel)
        myLabel.run(.fadeOut(withDuration: 2))
        }
   /* Sets icons(back and sound) in bottom of scenes.
     Sound icon status(on/off) reads from Core Data and based on a boolean value.
 */
    func setIcons(){
        musicIcon=SKSpriteNode(imageNamed: "musicOn")
        if musicOn! {
          musicIcon.texture=SKTexture(imageNamed:"musicOn")
            
            }else
        {
            musicIcon.texture=SKTexture(imageNamed: "musicOff")
            
        }
        
        musicIcon.name="musicIcon"
        musicIcon.size=CGSize(width: 30, height: 30)
        let (width, height) = (UIScreen.main.bounds.width,UIScreen.main.bounds.height)
        musicIcon.position = CGPoint(x:width,y:-height)
        musicIcon.position = CGPoint(x: UIScreen.main.bounds.width/2 - 50 , y: -UIScreen.main.bounds.height/2 + 50.0)
        musicIcon.setScale(1)
        addChild(musicIcon)
        //backIcon
        let backIcon=SKSpriteNode(imageNamed: "backIcon")
        backIcon.size=CGSize(width: 30, height: 30)
        backIcon.name="backIcon"
        backIcon.position = CGPoint(x:width,y:-height)
        backIcon.position = CGPoint(x: -UIScreen.main.bounds.width/2 + 50 , y: -UIScreen.main.bounds.height/2 + 50.0)
        backIcon.setScale(1)
        addChild(backIcon)
    }
  //Controls user touch between nodes and icons.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches{
            let touchLocation = touch.location(in: self)
            let targetNode :SKNode?=atPoint(touchLocation)
            
            if (targetNode?.name) != nil
            {
                //The user clicks on the correct node and the node will disappear.
                switch targetNode?.name {
                case myLabel.text:
                    do {
                        self.touchMusic()
                        self.score+=1
                        explosion(b: targetNode as! SKSpriteNode,location: touchLocation)
                        self.updateScore()
                        }
                
                case "reload":
                    do {
                       setButtonSound()
                        let view = self.view
                        let gamePlay=GameScene(fileNamed: "GameScene")
                        gamePlay?.size=(view?.bounds.size)!
                        gamePlay?.scaleMode = .aspectFill
                         self.view?.presentScene(gamePlay!,transition:.doorsOpenVertical(withDuration: 2))
                    }
                case "backIcon":
                    do {
                        setButtonSound()
                        self.saveData()
                        let view = self.view
                        let gamePlay=MainScene(fileNamed: "MainScene")
                        gamePlay?.size=(view?.bounds.size)!
                        gamePlay?.scaleMode = .aspectFill
                         self.view?.presentScene(gamePlay!,transition:.doorsOpenVertical(withDuration: 2))
                    }
                case "musicIcon":
                    
                    do {
                        setButtonSound()
                        if musicOn!{
                            musicOn=false
                            musicIcon.run(SKAction.animate(with: [SKTexture(imageNamed: "musicOff")], timePerFrame: 1))
                        }else
                        {
                            musicOn=true
                            musicIcon.run(SKAction.animate(with: [SKTexture(imageNamed: "musicOn")], timePerFrame: 1))
                        }
                        setMusic()
                        //setIcons()
                        
                    }
                default:
                    //If user choose wrong node the game will stop and Reload image as a SKspritenode will add to scene.
                    do {
                        
                        self.isPaused=true
                        let gameOver=SKSpriteNode(imageNamed: "gameOver")
                        gameOver.setScale(0.4)
                        gameOver.zPosition=0
                        self.addChild(gameOver)
                        gameOver.run(SKAction.repeatForever(SKAction.fadeOut(withDuration: 1)))
                        self.saveData()
                        
                        
                        
                        let reloadNode=(SKSpriteNode(imageNamed: "reload"))
                        reloadNode.name="reload"
                        reloadNode.zPosition=0
                        reloadNode.setScale(0.2)
                        reloadNode.position=(CGPoint(x: gameOver.frame.midX, y:gameOver.frame.origin.y-100))
                        self.addChild(reloadNode)
                        
                        
                        
                    }
                    
                }
                
            }//main if
            
        }//for
    }
    // remove ballon from scene by using of SKEmitterNode
    func explosion(b: SKSpriteNode,location : CGPoint){
        let emitter = SKEmitterNode(fileNamed: "explode")
        emitter?.particleTexture = SKTexture(imageNamed: b.name ?? "red")
        emitter?.position = location
        addChild(emitter ?? SKEmitterNode())
        b.removeFromParent()
    
        
    }
    // Add music to scene as a SKAudioNode.
    func setBackgroundMusic(){
        if let musicURL = Bundle.main.url(forResource: "backgroundMusic", withExtension: "mp3") {
            backgroundMusic = SKAudioNode(url: musicURL)
            addChild(backgroundMusic)
        }//if
  
        }
    /*
     Based on status of games sound (user can click on music icon) background music will play or stop.
     */
    func setMusic(){
        switch musicOn {
        case true:
            setBackgroundMusic()
 
        case false:
            if (backgroundMusic != nil){
                stop()
                }
        default:
            setBackgroundMusic()
        }
      }
    
    func stop(){
        backgroundMusic.removeFromParent()
        
    }
    
    func touchMusic(){
        run (SKAction.playSoundFileNamed("BalloonPopping.mp3",waitForCompletion: true))
    }
    
    func setButtonSound()
    {
       run (SKAction.playSoundFileNamed("buttonSound.mp3",waitForCompletion: true))
    }
    // Saves data by using of Coredata.
    func saveData(){
        let appDelegate=UIApplication.shared.delegate as! AppDelegate
        let context=appDelegate.persistentContainer.viewContext
        let entity=NSEntityDescription.entity(forEntityName: "Game", in: context)
        let game=NSManagedObject(entity: entity!, insertInto: context)
        game.setValue(score, forKey: "score")
        game.setValue(musicOn, forKey: "musicOn")
        
        
        do {
            try context.save()
        } catch
        {
            print("error")
        }
    }
   // Reads data from Coredata.
    func fetchData(){
     let appDelegate=UIApplication.shared.delegate as! AppDelegate
     let context=appDelegate.persistentContainer.viewContext
    // let entity=NSEntityDescription.entity(forEntityName: "Game", in: context)
    
     let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Game")
        
         request.returnsObjectsAsFaults = false
         do {
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] {
                //score=(data.value(forKey: "score") as! Int)
                musicOn=(data.value(forKey: "musicOn") as! Bool)
           }
            
            
         } catch {
             
             print("Failed")
         }//catch
         
     }
    // Fetch high score
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
    


        
    
    

    
    
    
   


//
//  ViewController.swift
//  Tic-tac-toe
//
//  Created by Spencer Smith on 3/11/16.
//  Copyright © 2016 Spencer Smith. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var playerIndicator: UIView!
    @IBOutlet var scoreLabel: [UILabel]!
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet var dimensions: [NSLayoutConstraint]!
    
    var data = [0, 0, 0, 0, 0, 0, 0, 0, 0]
    var player = 1
    var startingPlayer = 1
    
    let animationDuration = 0.2
    
    let color1 = UIColor(red:1.00, green:0.84, blue:0.00, alpha:1.00)
    let color2 = UIColor(red:0.80, green:0.36, blue:0.36, alpha:1.00)
    let colorGray = UIColor.groupTableViewBackgroundColor()
    
    var score = [0, 0]
    var winners = [0, 0, 0]
    
    var haveWinner = false
    var haveTie = false
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let screenSize: CGRect = UIScreen.mainScreen().bounds
//        let screenWidth = screenSize.width
//        let screenHeight = screenSize.height
//        
//        print(screenWidth)
//        print(screenHeight)
        
        for dim in dimensions{
            dim.constant = 20
        }
        
        
        // Setting button values (which match data[index])
        for index in 0 ... 8{
            buttons[index].frame = CGRectMake(20, 20, 20, 20)
            buttons[index].tag = index
        }
        
        // Starts color as color1
        playerIndicator.backgroundColor = color1
        
        // Gives the score lables the corresponding font color
        scoreLabel[0].textColor = color1;
        scoreLabel[1].textColor = color2;
        
        // Sets the score text to be zero zero
        scoreLabel[0].text = String(score[0])
        scoreLabel[1].text = String(score[1])
        
//        resetButton.contentEdgeInsets = UIEdgeInsetsMake(20,20,20,20)
        resetButton.imageEdgeInsets.top = 50
        resetButton.imageEdgeInsets.left = 50
    }
    
    
    @IBAction func clicked(sender: UIButton) {
        
        if(haveWinner || haveTie){
            return // Disables buttons after tie or win
        }
        
        // Ignores already filled in buttons
        if(data[sender.tag] != 0){
            return
        }
        
        // Marks data in spot in data with current player
        data[sender.tag] = player
        
        updateButtons()
        
        haveWinner = checkForWin()
        haveTie = checkForTie()
        
        // End computations if we don't have a winner or tie
        if(!haveWinner && !haveTie){
            changePlayer()
            return
        }
        
        if(haveWinner){// Increments the score for the winner
            score[player - 1] += 1
            scoreLabel[player - 1].text = String(score[player - 1])
            
            
            for i in 0..<buttons.count{
                if(!winners.contains(i) && data[i] != 0){
                    dimButton(buttons[i])
                }
            }
        }
            
        // Grays out the player indicator (tie and/or win)
        UIView.animateWithDuration(animationDuration, animations: {
            self.playerIndicator.backgroundColor = self.colorGray
        })
        
    }
    
    
    @IBAction func rematch(sender: AnyObject? = nil) {
        switch(startingPlayer){
        case 1:
            changePlayerTo(2)
        default:
            changePlayerTo(1)
        }
        
        haveWinner = false
        haveTie = false
        
        for index in 0 ... 8{
            data[index] = 0
        }
        updateButtons()
    }
    
    @IBAction func resetClicked(sender: UIButton) {
        
        // create the alert
        let alert = UIAlertController(title: "", message: "Clear Score?", preferredStyle: UIAlertControllerStyle.Alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {
            alert in
            self.score = [0, 0]
            self.scoreLabel[0].text = String(self.score[0])
            self.scoreLabel[1].text = String(self.score[1])
            self.rematch();
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        // show the alert
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func changePlayer(){
        
        UIView.animateWithDuration(animationDuration, animations: {
            if(self.player == 1){
                self.player = 2
                self.playerIndicator.backgroundColor = self.color2
                return
            }
            self.player = 1
            self.playerIndicator.backgroundColor = self.color1
        })
    }
    
    func changePlayerTo(num: Int){
        UIView.animateWithDuration(animationDuration, animations: {
            if(num == 1){
                self.player = 1
                self.playerIndicator.backgroundColor = self.color1
                self.startingPlayer = 1
                return
            }
            if(num == 2){
                self.player = 2
                self.playerIndicator.backgroundColor = self.color2
                self.startingPlayer = 2
            }
        })
    }
    
    func dimButton(button: UIButton){
        UIView.animateWithDuration(animationDuration, animations: {
            button.alpha = 0.25
        })
    }
    
    func updateButtons(){
        for index in 0 ... 8{
            
            UIView.animateWithDuration(animationDuration, animations: {
                self.buttons[index].alpha = 1
                
                switch(self.data[index]){
                case 1:
                    self.buttons[index].backgroundColor = self.color1
                case 2:
                    self.buttons[index].backgroundColor = self.color2
                default:
                    self.buttons[index].backgroundColor = self.colorGray
                }
            })
        }
    }
    
    
    func checkForWin() -> Bool{
        return checkVertical() || checkHorizontal() || checkDiagonal()
    }
    
    func checkForTie() -> Bool{
        for i in data{
            if(i == 0){
                return false
            }
        }
        return true
    }
    
    func checkVertical() -> Bool{
        
        for i in 0...2{
            let a = i       // Top left
            let b = a + 3   // Middle left
            let c = b + 3   // Bottom left
            
            if(equal(data[a], two: data[b], three: data[c])){
                winners = [a, b, c]
                return true
            }
        }
        return false
    }
    
    func checkHorizontal() -> Bool{
        
        for i in 0...2{
            let a = i * 3   // Top left
            let b = a + 1   // Top middle
            let c = b + 1   // Top right
            
            if(equal(data[a], two: data[b], three: data[c])){
                winners = [a, b, c]
                return true
            }
        }
        return false
    }
    
    func checkDiagonal() -> Bool{
        
        if(equal(data[0], two: data[4], three: data[8])){
            winners = [0, 4, 8]
            return true
        }
        
        if(equal(data[2], two: data[4], three: data[6])){
            winners = [2, 4, 6]
            return true;
        }
        
        return false
    }
    
    func equal(one: Int, two: Int, three: Int) -> Bool{
        return one == two && two == three && one != 0
    }
   
}


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
    
    var data = [0, 0, 0, 0, 0, 0, 0, 0, 0]
    var player = 1
    
    let animationDuration = 0.2
    
    let color1 = UIColor(red:1.00, green:0.84, blue:0.00, alpha:1.00)
    let color2 = UIColor(red:0.80, green:0.36, blue:0.36, alpha:1.00)
    let colorGray = UIColor.groupTableViewBackgroundColor()
    
    var score = [0, 0]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting button values (which match data[index])
        for index in 0 ... 8{
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
        resetButton.contentEdgeInsets.top = 50
        resetButton.contentEdgeInsets.left = 50
    }
    
    
    @IBAction func clicked(sender: UIButton) {
        
        if(checkForWin() || checkForTie()){
            return // Disables buttons after tie or win
        }
        
        // Ignores already filled in buttons
        if(data[sender.tag] != 0){
            return
        }
        
        // Marks data in spot in data with current player
        data[sender.tag] = player
        
        updateButtons()
        
        let won = checkForWin()
        let tie = checkForTie()
        
        // Let's do some stuff for wins and ties
        if(won || tie){
            
            if(won){// Increments the score for the winner
                score[player - 1] += 1
                scoreLabel[player - 1].text = String(score[player - 1])
            }
            
            // Grays out the player indicator (tie and/or win)
            UIView.animateWithDuration(animationDuration, animations: {
                self.playerIndicator.backgroundColor = self.colorGray
            })
            return
        }
        
        changePlayer()
    }
    
    
    @IBAction func rematch(sender: AnyObject? = nil) {
        changePlayer()
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
    
    func updateButtons(){
        for index in 0 ... 8{
            
            UIView.animateWithDuration(animationDuration, animations: {
                
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
        for i in 0 ... 2{
            if(data[i] != 0 && data[i] == data[i + 3] && data[i + 3]  == data[i + 6]){
                return true;
            }
        }
        return false
    }
    
    func checkHorizontal() -> Bool{
        var i = 0
        while i <= 6 {
            if(data[i] != 0 && data[i] == data[i + 1] && data[i + 1]  == data[i + 2]){
                return true;
            }
            i += 3
        }
        return false
    }
    
    func checkDiagonal() -> Bool{
        if(data[0] != 0 && data[0] == data[4] && data[4]  == data[8]){
            return true;
        }
        
        if(data[2] != 0 && data[2] == data[4] && data[4]  == data[6]){
            return true;
        }
        
        return false
    }
   
}


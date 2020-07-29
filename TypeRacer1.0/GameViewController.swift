//
//  GameViewController.swift
//  TypeRacer1.0
//
//  Created by Utsav Shinghal on 21/12/2019.
//  Copyright © 2019 Utsav Shinghal. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit


class GameViewController: UIViewController {

    @IBOutlet weak var progressView:UIProgressView?
    @IBOutlet weak var text:UILabel!
    @IBOutlet weak var inputField:UITextField?
    @IBOutlet weak var timeLabel:UILabel?
    @IBOutlet weak var wordCounter: UILabel?
    @IBOutlet weak var restartButton: UIButton?
    @IBOutlet weak var highScore: UILabel?
    
    var pinkCounter = 0
    var timer: Timer?
    var seconds = 60
    let progress = Progress(totalUnitCount: 10)
    var high_score = 0
    
    func updateTimeLabel() {
        let min = (seconds / 60) % 60
        let sec = seconds % 60
        
        timeLabel?.text = String(format: "%02d", min) + ":" + String(format: "%02d", sec)
    }
    
//    func updateProgress() {
//        progressView?.progress += 1
//    }
    
    func updateWordCounter() {
        wordCounter?.text = String(pinkCounter)
        pinkCounter += 1
        
    }
    
    func randomWord() {
        text.text = String.randomWord()
    }
    
    func updateHighScore() {
        if pinkCounter >= high_score {
            high_score = pinkCounter
            highScore?.text = String(high_score)
        }
    }

    @IBAction func restartGame(_ sender: Any) {
        timer?.invalidate()
        timer = nil
        timeLabel?.textColor = UIColor.white
        seconds = 60
        updateTimeLabel()
        randomWord()
        pinkCounter = 0
        updateHighScore()
        updateWordCounter()
        inputField?.text = ""
        
    }
    
    
    @IBAction func inputFieldDidChange()
    {
        guard let strText = text.text, let inputText = inputField?.text
        else {
            return
        }
        
        guard inputText.count == strText.count else {
            return
        }

        var isCorrect = true
        let input = inputText
        let string = strText
        if input != string {
            isCorrect = false
        }
        
        if isCorrect{
            updateHighScore()
            updateWordCounter()
            randomWord()
            inputField?.text = ""
            

        }
        else{
            
        }
        
        
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                
                if self.seconds == 0 {
                    self.finishGame()
                } else if self.seconds <= 60 {
                    self.seconds -= 1
                    self.updateTimeLabel()
                    if self.seconds <= 10 && self.seconds % 2 == 0 {
                        self.timeLabel?.textColor = UIColor.red
                    }
                    if self.seconds <= 10 && self.seconds % 2 == 1 {
                        self.timeLabel?.textColor = UIColor.white
                    }
                    if self.seconds == 0{
                        self.timeLabel?.textColor = UIColor.white
                    }
                }
                }
            }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateHighScore()
        updateWordCounter()
        randomWord()
        updateTimeLabel()
        
        
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func finishGame()
    {
        timer?.invalidate()
        timer = nil
        let alert = UIAlertController(title:
            "Time's Up!", message: "Your time is up! You got \(pinkCounter-1) Words Per Minute. Awesome!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK, start new game", style:.default, handler:nil))
        self.present(alert, animated:true, completion:nil)
        
        progressView?.progress = 0.0
        seconds = 60
        updateTimeLabel()
        randomWord()
        pinkCounter = 0
        updateHighScore()
        updateWordCounter()
        
        
    }
}

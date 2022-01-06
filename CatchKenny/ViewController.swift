//
//  ViewController.swift
//  CatchKenny
//
//  Created by user210109 Onurcan Kurt on 1/4/22.
//

import UIKit

class ViewController: UIViewController {
    
    var kennyTimer = Timer()
    var timer = Timer()
    
    var counter = 0
    var width = 0.0
    var height = 0.0
    var score = 0
    var highscore = 0
    
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var kennyImage: UIImageView!
    @IBOutlet weak var highscoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        width = view.frame.size.width
        height = view.frame.size.height
        
        highscore = UserDefaults.standard.integer(forKey: "highscore")
        highscoreLabel.text = "Highscore: \(String(describing: highscore))"
        
        kennyImage.image = UIImage(named: "Kenny")
        kennyImage.frame = CGRect(x: width-width/5, y: height/3.5, width: width/5, height: height/8)
        
        kennyImage.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        kennyImage.addGestureRecognizer(gestureRecognizer)
        
        view.addSubview(kennyImage)
        
        counter = 10
    
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFunction), userInfo: nil, repeats: true)
        kennyTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(moveKenny), userInfo: nil, repeats: true)
    }
    
    @objc func timerFunction(){
        countdownLabel.text = "Time: \(counter)"
        counter -= 1
        
        if counter < 0{
            timer.invalidate()
            countdownLabel.text = "Time is over"
            if(score > highscore){
                UserDefaults.standard.set(score, forKey: "highscore")
                highscoreLabel.text = "Highscore: \(score)"
            }
            AlertFunc()
        }
    }
    
    @objc func moveKenny(){
        if(counter > 0){
            kennyImage.isHidden = false
        }
        //x left_limit:0,  x right_limit:   width-width/5
        //y top_limit:250, y bottom_limit:  height - 240
        let randomX = Double.random(in: 0...width-width/5)
        let randomY = Double.random(in: 250...height-240)
        
        kennyImage.frame = CGRect(x: randomX, y: randomY, width: width/5, height: height/8)
        if counter < 0{
            kennyTimer.invalidate()
            kennyImage.isHidden = true
        }
    }
    
    @objc func increaseScore(){
        score += 1
        scoreLabel.text = "Score: \(score)"
    }
    
    func AlertFunc(){
        let alert = UIAlertController(title: "Time's Up", message: "Do you want to play again?", preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Exit", style: UIAlertAction.Style.default) { UIAlertAction in
            exit(0)
        }
        let replayButton = UIAlertAction(title: "Replay", style: UIAlertAction.Style.default) { [self] UIAlertAction in
            self.score = 0
            self.counter = 10
            self.scoreLabel.text = "Score: \(self.score)"
            self.countdownLabel.text = "Time: \(self.counter)"
            
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFunction), userInfo: nil, repeats: true)
            kennyTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(moveKenny), userInfo: nil, repeats: true)
        }
        alert.addAction(okButton)
        alert.addAction(replayButton)
        self.present(alert, animated: true, completion: nil)
    }
}


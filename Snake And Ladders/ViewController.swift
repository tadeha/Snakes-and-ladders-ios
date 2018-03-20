//
//  ViewController.swift
//  Snake And Ladders
//
//  Created by Tadeh Alexani on 9/5/1396 AP.
//  Copyright © 1396 Tadeh Alexani. All rights reserved.
//

// 1 - List Object
// 2 - Queue for players sort

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {
    
    // Define Variables
    
    var isGamePlaying: Bool = true
    
    @IBOutlet weak var redPlayer: UIImageView!
    @IBOutlet weak var redPlayerLabel: UILabel!
    
    @IBOutlet weak var isPlayerTwoUser: UISwitch!
    
    @IBOutlet weak var bluePlayerLabel: UILabel!
    @IBOutlet weak var bluePlayer: UIImageView!
    
    var audioPlayer: AVAudioPlayer?
    
    //var boardList = 100
    var boardList = LinkedList<Int>()
    var playerOnePosition = 1
    var playerOneMoves = 0
    var playerTwoPosition = 1
    var playerTwoMoves = 0
    var currentDice = 0
    var isPlayerOneTurn: Bool = true
    
    // A function to check if user reached to a snake or ladder
    
    func snakesOrLadderPosition(position: Int,player: UIImageView) -> Int {
        var newposition = position
        
        switch position {
        case 3:
            newposition = 51
            UIView.animate(withDuration: 0.75, delay: 1, options: .curveLinear, animations: {
                player.center.x -= 37.5 * 2
                player.center.y -= 37.5 * 5
            }, completion: nil)
        case 6:
            newposition = 27
            UIView.animate(withDuration: 0.75, delay: 1, options: .curveLinear, animations: {
                player.center.y -= 37.5 * 2
                player.center.x += 37.5
            }, completion: nil)
        case 20:
            newposition = 70
            UIView.animate(withDuration: 0.75, delay: 1, options: .curveLinear, animations: {
                player.center.y -= 37.5 * 5
            }, completion: nil)
        case 25:
            newposition = 5
            UIView.animate(withDuration: 0.75, delay: 1, options: .curveLinear, animations: {
                player.center.y += 37.5 * 2
            }, completion: nil)
        case 34:
            newposition = 1
            UIView.animate(withDuration: 0.75, delay: 1, options: .curveLinear, animations: {
                player.center.y += 37.5 * 3
                player.center.x -= 37.5 * 3
            }, completion: nil)
        case 36:
            newposition = 55
            UIView.animate(withDuration: 0.75, delay: 1, options: .curveLinear, animations: {
                player.center.x -= 37.5
                player.center.y -= 37.5 * 2
            }, completion: nil)
        case 47:
            newposition = 19
            UIView.animate(withDuration: 0.75, delay: 1, options: .curveLinear, animations: {
                player.center.y += 37.5 * 3
                player.center.x += 37.5 * 2
            }, completion: nil)
        case 63:
            newposition = 95
            UIView.animate(withDuration: 0.75, delay: 1, options: .curveLinear, animations: {
                player.center.x += 37.5 * 2
                player.center.y -= 37.5 * 3
            }, completion: nil)
        case 65:
            newposition = 52
            UIView.animate(withDuration: 0.75, delay: 1, options: .curveLinear, animations: {
                player.center.y += 37.5 * 1
                player.center.x -= 37.5 * 3
            }, completion: nil)
        case 68:
            newposition = 98
            UIView.animate(withDuration: 0.75, delay: 1, options: .curveLinear, animations: {
                player.center.y -= 37.5 * 3
            }, completion: nil)
        case 87:
            newposition = 57
            UIView.animate(withDuration: 0.75, delay: 1, options: .curveLinear, animations: {
                player.center.y += 37.5 * 3
            }, completion: nil)
        case 91:
            newposition = 61
            UIView.animate(withDuration: 0.75, delay: 1, options: .curveLinear, animations: {
                player.center.y += 37.5 * 3
            }, completion: nil)
        case 99:
            newposition = 69
            UIView.animate(withDuration: 0.75, delay: 1, options: .curveLinear, animations: {
                player.center.y += 37.5 * 3
            }, completion: nil)
        default:
            newposition = position
        }
        
        return newposition
    }
    
    // A function to create a random number and a random dice number
    
    func randomeInt(min: Int, max: Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
    
    func dice() -> Int {
        let dice = randomeInt(min: 1, max: 6)
        return dice
    }
    
    // If user tapped on roll dice btn
    
    @IBAction func diceRollBtnTapped(_ sender: Any) {
        
        if let player = audioPlayer {
            player.play()
        }
        
        if isPlayerOneTurn {
            
            redPlayerLabel.textColor = .black
            bluePlayerLabel.textColor = .red
            
            isPlayerOneTurn = false
            currentDice = dice()
            
            print("player one dice : \(currentDice)")
            
            if (boardList.count - playerOnePosition) >= currentDice {
                playerOneMoves += 1
                
                var i = 0
                
                while i < currentDice
                {
                    if (playerOnePosition % 10) != 0 {
                        UIView.animate(withDuration: 0.75, delay: 0, options: .curveLinear, animations: {
                            self.redPlayer.center.x += 37.5
                        }, completion: nil)
                    } else {
                        UIView.animate(withDuration: 0.75, delay: 0, options: .curveLinear, animations: {
                            self.redPlayer.center.x -= 37.5 * 10
                            self.redPlayer.center.y -= 37.5
                            self.redPlayer.center.x += 37.5
                        }, completion: nil)
                    }
                    
                    playerOnePosition += 1
                    
                    i += 1
                    
                }
                
                
                //Check if reached to Snakes or Ladders
                if boardList.node(at: playerOnePosition - 1).value < boardList.count {
                    playerOnePosition = snakesOrLadderPosition(position: boardList.node(at: playerOnePosition).value - 1, player: redPlayer)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    if !self.isPlayerTwoUser.isOn {
                        self.playerToMoves()
                    }
                })
                
            }
            
        } else {
            
            playerToMoves()
            
        }
        
        // If user reached to the end
        
        if (boardList.node(at: playerOnePosition - 1).value == boardList.count) {
            isGamePlaying = false
            
            let alert = UIAlertController(title: "The End", message: "بازیکن \(redPlayerLabel.text!) برنده شد با \(playerOneMoves) حرکت", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
            
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
            
        } else if (boardList.node(at: playerTwoPosition - 1).value == boardList.count) {
            
            isGamePlaying = false
            
            let alert = UIAlertController(title: "The End", message:"بازیکن \(bluePlayerLabel.text!) برنده شد با \(playerTwoMoves) حرکت", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
            
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    // A function to move the player 2
    
    func playerToMoves() {
        
        redPlayerLabel.textColor = .red
        bluePlayerLabel.textColor = .black
        
        isPlayerOneTurn = true
        currentDice = dice()
        
        print("player two dice : \(currentDice)")
        print("=====")
        
        if (boardList.count - playerTwoPosition) >= currentDice {
            
            playerTwoMoves += 1
            
            var i = 0
            
            while i < currentDice
            {
                if (playerTwoPosition % 10) != 0 {
                    UIView.animate(withDuration: 0.75, delay: 0, options: .curveLinear, animations: {
                        self.bluePlayer.center.x += 37.5
                    }, completion: nil)
                } else {
                    UIView.animate(withDuration: 0.75, delay: 0, options: .curveLinear, animations: {
                        self.bluePlayer.center.x -= 37.5 * 10
                        self.bluePlayer.center.y -= 37.5
                        self.bluePlayer.center.x += 37.5
                    }, completion: nil)
                }
                
                playerTwoPosition += 1
                
                i += 1
                
            }

            if boardList.node(at: playerTwoPosition - 1).value < boardList.count {
                playerTwoPosition = snakesOrLadderPosition(position: boardList.node(at: playerTwoPosition).value - 1, player: bluePlayer)
            }
        }
        
    }
    
    // Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 1...100 {
            boardList.append(i)
        }
        
        print(boardList.count)
        
        let url = URL.init(fileURLWithPath: Bundle.main.path(
            forResource: "diceroll",
            ofType: "wav")!)
        
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
        } catch let error as NSError {
            print("audioPlayer error \(error.localizedDescription)")
        }
        
        redPlayerLabel.textColor = .red
        bluePlayerLabel.textColor = .black
        
    }

    // If user tapped on Player 2 Switch
    
    @IBAction func isPlayerTwoUserTapped(_ sender: Any) {
        if isPlayerTwoUser.isOn {
            let alertController = UIAlertController(title: "Name", message: "Enter your name:", preferredStyle: .alert)
            
            let confirmAction = UIAlertAction(title: "Done", style: .default) { (_) in
                if let field = alertController.textFields?[0] {
                    self.bluePlayerLabel.text = field.text
                } else {
                    self.bluePlayerLabel.text = "Computer"
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
            
            alertController.addTextField { (textField) in
                textField.placeholder = "Enter your name:"
            }
            
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            self.bluePlayerLabel.text = "Computer"
            
        }
    }
    
    
    // Present the first alert
    
    override func viewDidAppear(_ animated: Bool) {
        presentAlert()
    }
    
    func presentAlert() {
        let alertController = UIAlertController(title: "Name", message: "Enter your name:", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Done", style: .default) { (_) in
            if let field = alertController.textFields?[0] {
                self.redPlayerLabel.text = field.text
                self.redPlayerLabel.textColor = .red
            } else {
                self.redPlayerLabel.text = "NO NAME"
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.redPlayerLabel.text = "NO NAME"
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter your name:"
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }

}


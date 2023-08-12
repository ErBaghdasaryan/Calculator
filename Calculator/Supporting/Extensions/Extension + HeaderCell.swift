//
//  Extension + HeaderCell.swift
//  Calculator
//
//  Created by Er Baghdasaryan on 09.08.23.
//

import UIKit

extension CalculatorHeadorCell {
    
    func addSwipeGestureRecognizers() {
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft(_:)))
        swipeLeftGesture.direction = .left
        self.addGestureRecognizer(swipeLeftGesture)
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight(_:)))
        swipeRightGesture.direction = .right
        self.addGestureRecognizer(swipeRightGesture)
        
        self.isUserInteractionEnabled = true // Enable user interaction
    }
    
    @objc func handleSwipeLeft(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            self.label.text?.removeLast()
        }
    }
        
    @objc func handleSwipeRight(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            self.label.text?.removeLast()
        }
    }
}

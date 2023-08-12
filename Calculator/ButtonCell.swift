//
//  ButtonCell.swift
//  Calculator
//
//  Created by Er Baghdasaryan on 07.08.23.
//

import UIKit

class ButtonCell: UICollectionViewCell {
    
    static let identifier = "ButtonCell"
    
    private(set) var calculatorButton: CalculatorButton!
    
    private var titleLable: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 40, weight: .regular)
        label.text = "Error"
        return label
    }()
    
    public func config(with calculatorButton: CalculatorButton) {
        self.calculatorButton = calculatorButton
        self.titleLable.text = calculatorButton.title
        self.backgroundColor = calculatorButton.color
        
        switch calculatorButton {
        case .allClear, .plusMinus, .percentage:
            self.titleLable.textColor = .black
        default:
            self.titleLable.textColor = .white
        }
        self.setupUI()
    }
    
    public func operationTapped() {
        self.titleLable.textColor = .orange
        self.backgroundColor = .white  
    }
    
    private func setupUI() {
        self.addSubview(titleLable)
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        
        switch self.calculatorButton {
        case let .number(int) where int == 0:
            
            self.layer.cornerRadius = 36
            let extraSpace = self.frame.width-self.frame.height
            
            NSLayoutConstraint.activate([
                self.titleLable.heightAnchor.constraint(equalToConstant: self.frame.height),
                self.titleLable.widthAnchor.constraint(equalToConstant:  self.frame.height),
                self.titleLable.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                self.titleLable.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                self.titleLable.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -extraSpace)
                
            ])
            
        default:
            self.layer.cornerRadius = self.frame.size.width/2
            
            NSLayoutConstraint.activate([
                self.titleLable.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                self.titleLable.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                self.titleLable.widthAnchor.constraint(equalTo: self.widthAnchor),
                self.titleLable.heightAnchor.constraint(equalTo: self.heightAnchor)
            ])
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        self.titleLable.removeFromSuperview()
    }
    
    
}

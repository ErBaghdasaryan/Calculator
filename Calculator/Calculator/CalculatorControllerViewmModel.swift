//
//  CalculatorControllerViewmModel.swift
//  Calculator
//
//  Created by Er Baghdasaryan on 07.08.23.
//

import UIKit

enum CurrentNumber {
    case firstNumber, secondNumber
}

class CalculatorControllerViewModel {
    
    var updateViews: (() -> Void)?
    
    let calcButtonCells: [CalculatorButton] = [
        .allClear, .plusMinus, .percentage, .divide,
        .number(7), .number(8), .number(9), .multiply,
        .number(4), .number(5), .number(6), .subtract,
        .number(1), .number(2), .number(3), .add,
        .number(0), .decimal, .equals
    ]
    
    private(set) lazy var calcHeaderLabel: String = self.firstNumber ?? "0"
    private(set) var currentNumber: CurrentNumber = .firstNumber
    
    private(set) var firstNumber: String? = nil {
        didSet {
            self.calcHeaderLabel = self.firstNumber?.description ?? "0"
        }
    }
    
    private(set) var secondNumber: String? = nil {
        didSet {
            self.calcHeaderLabel = self.secondNumber?.description ?? "0"
        }
    }
    private(set) var operation: CalculatorOperation? = nil
    
    private(set) var prevNumber: String? = nil
    private(set) var prevOperation: CalculatorOperation? = nil
    
    private(set) var firstNumberIsDecimal: Bool = false
    private(set) var secondNumberIsDecimal: Bool = false
    
    var eitherNumberIsDecimal: Bool {
        return firstNumberIsDecimal || secondNumberIsDecimal
    }
}

extension CalculatorControllerViewModel {
    
    public func didSelectButton(with calculatorButton: CalculatorButton) {
        switch calculatorButton {
            
        case .allClear:
            self.AllClearTapped()
        case .plusMinus:
            self.plusMinusTapped()
        case .percentage:
            self.percentageButtonTapped()
        case .divide:
            self.OperationTapped(with: .divide)
        case .multiply:
            self.OperationTapped(with: .multiply)
        case .subtract:
            self.OperationTapped(with: .subtract)
        case .add:
            self.OperationTapped(with: .add)
        case .equals:
            self.equalsButtonTapped()
        case .number(let number):
            self.didSelectNumber(with: number)
        case .decimal:
            self.decimalButtonTapped()
        }
        
        self.updateViews?()
    }
    
    private func AllClearTapped() {
        self.calcHeaderLabel = "0"
        self.currentNumber = .firstNumber
        self.firstNumber = nil
        self.secondNumber = nil
        self.operation = nil
        self.firstNumberIsDecimal = false
        self.secondNumberIsDecimal = false
        self.prevNumber = nil
        self.prevOperation = nil
    }
    
    private func didSelectNumber(with number: Int) {
        if self.currentNumber == .firstNumber {
            if var firstNumber = self.firstNumber {
                firstNumber.append(number.description)
                self.firstNumber = firstNumber
                self.prevNumber = firstNumber
                
            }else {
                self.firstNumber = number.description
                self.prevNumber = number.description
            }
        }else {
            if var secondNumber = self.secondNumber {
                
                secondNumber.append(number.description)
                self.secondNumber = secondNumber
                self.prevNumber = secondNumber
            }else {
                self.secondNumber = number.description
                self.prevNumber = number.description
            }
        }
    }
}

extension CalculatorControllerViewModel {
    
    private func decimalButtonTapped() {
        if self.currentNumber == .firstNumber {
            
            self.firstNumberIsDecimal = true
            if let firstNumber = self.firstNumber, !firstNumber.contains(".") {
                self.firstNumber = firstNumber.appending(".")
            }else if self.firstNumber == nil {
                self.firstNumber = "0."
            }
        }else if self.currentNumber == .secondNumber {
            self.secondNumberIsDecimal = true
            if let secondNumber = self.secondNumber, !secondNumber.contains(".") {
                self.secondNumber = secondNumber.appending(".")
            }else if self.secondNumber == nil {
                self.secondNumber = "0."
            }
        }
    }
    
    private func percentageButtonTapped() {
        if self.currentNumber == .firstNumber, var number = self.firstNumber?.toDouble {
            
            number /= 100
            if number.isInteger {
                self.firstNumber = number.toInt?.description
            }else {
                self.firstNumber = number.description
                self.firstNumberIsDecimal = true
            }
        }
        else if self.currentNumber == .secondNumber, var number = self.secondNumber?.toDouble {
            number /= 100
            if number.isInteger {
                self.secondNumber = number.toInt?.description
            }else {
                self.secondNumber = number.description
                self.secondNumberIsDecimal = true
            }
        }
    }
    
    private func plusMinusTapped() {
        if self.currentNumber == .firstNumber, var number = self.firstNumber {
            if number.contains("-") {
                number.removeFirst()
            }else {
                number.insert("-", at: number.startIndex)
            }
            
            self.firstNumber = number
            self.prevNumber = number
        }
        else if self.currentNumber == .secondNumber, var number = self.secondNumber {
            if number.contains("-") {
                number.removeFirst()
            }else {
                number.insert("-", at: number.startIndex)
            }
            
            self.secondNumber = number
            self.prevNumber = number
        }
    }
    
    private func equalsButtonTapped() {
        if let operation = self.operation,
           let firstNumber = self.firstNumber?.toDouble,
           let secondNumber = self.secondNumber?.toDouble {
            
            let result = self.operationResult(operation, firstNumber, secondNumber)
            let resultString = self.eitherNumberIsDecimal ? result.description : result.toInt?.description
            
            self.secondNumber = nil
            self.prevOperation = operation
            self.operation = nil
            self.firstNumber = resultString
            self.currentNumber = .firstNumber
        }
        else if let prevOperation = self.prevOperation,
                let firstNumber = self.firstNumber?.toDouble,
                let prevNumber = self.prevNumber?.toDouble {
            
            let result = self.operationResult(prevOperation, firstNumber, prevNumber)
            let resultString = self.eitherNumberIsDecimal ? result.description : result.toInt?.description
            
            self.firstNumber = resultString
        }
    }
    
    private func OperationTapped(with operation: CalculatorOperation) {
        if self.currentNumber == .firstNumber {
            self.operation = operation
            self.currentNumber = .secondNumber
        }else if self.currentNumber == .secondNumber {
            if let prevOperation = self.operation,
               let firstNumber = self.firstNumber?.toDouble,
               let secondNumber = self.secondNumber?.toDouble {
                
                let result = self.operationResult(prevOperation, firstNumber, secondNumber)
                let resultString = self.eitherNumberIsDecimal ? result.description : result.toInt?.description

                
                self.secondNumber = nil
                self.firstNumber = resultString
                self.currentNumber = .secondNumber
                self.operation = operation
            }else {
                self.operation = operation
            }
        }
    }
    
    private func operationResult(_ operation: CalculatorOperation,
                                 _ firstNumber: Double?,
                                 _ secondNumber: Double?) -> Double {
        
        guard let firstNumber = firstNumber,
              let secondNumber = secondNumber else { return 0}
        
        switch operation {
        case .add:
            return (firstNumber + secondNumber)
        case .multiply:
            return (firstNumber * secondNumber)
        case .divide:
            return (firstNumber / secondNumber)
        case .subtract:
            return (firstNumber - secondNumber)
        }
    }
}

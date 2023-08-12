//
//  CalculatorOperation.swift
//  Calculator
//
//  Created by Er Baghdasaryan on 08.08.23.
//

import UIKit

enum CalculatorOperation {
    case add
    case multiply
    case divide
    case subtract
    
    var title: String {
        switch self {
        case .add:
            return "+"
        case .multiply:
            return "x"
        case .divide:
            return "÷"
        case .subtract:
            return "-"
        }
    }
}

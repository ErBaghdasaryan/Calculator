//
//  Extensions.swift
//  Calculator
//
//  Created by Er Baghdasaryan on 08.08.23.
//

import UIKit

extension FloatingPoint {
    var isInteger: Bool { return rounded() == self }
}

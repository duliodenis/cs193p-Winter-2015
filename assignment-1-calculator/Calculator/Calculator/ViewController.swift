//
//  ViewController.swift
//  Calculator
//
//  Created by Dulio Denis on 1/26/15.
//  Copyright (c) 2015 ddApps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    
    var operandStack = Array<Double>()
    var operationStack = Array<Double>()
    
    var userIsInTheMiddleOfTypingANumber = false
    var decimalUsed = false

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        println("digit = \(digit)")
        
        if userIsInTheMiddleOfTypingANumber {
            if digit == "." && decimalUsed == true {
                return
            } else if digit == "." && decimalUsed == false {
                decimalUsed = true
            }
            display.text = display.text! + digit
        } else {
            userIsInTheMiddleOfTypingANumber = true
            
            if digit == "." {
                decimalUsed = true
                display.text = "0."
            } else {
                display.text = digit
            }
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        
        switch operation {
        case "×": performOperation { $0 * $1 }
        case "÷": performOperation { $1 / $0 }
        case "+": performOperation { $0 + $1 }
        case "−": performOperation { $1 - $0 }
        case "√": performOperation { sqrt($0) }
        case "sin": performOperation { sin($0) }
        case "cos": performOperation { cos($0) }
        case "∏": displayValue = M_PI
        default: break
        }
    }
    
    func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    func performOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        decimalUsed = false
        operandStack.append(displayValue)
        println("operandStack = \(operandStack)")
        
        history.text = ""
        for element in operandStack {
            history.text = history.text! + "\(element), "
        }
    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
            decimalUsed = false
        }
    }
}


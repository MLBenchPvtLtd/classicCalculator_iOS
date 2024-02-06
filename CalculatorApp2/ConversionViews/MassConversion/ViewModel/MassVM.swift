//
//  MassVM.swift
//  CalculatorApp2
//
//  Created by ML Bench  on 01/02/2024.
//

import Foundation

class MassVM: ObservableObject{
    
    @Published var firstNum = "0"
    @Published var secondNum = "0"
    
    @Published var dropDownHeadingFirst = "Gram g"
    @Published var dropDownHeadingSecond = "Kilogram kg"
    
    @Published var isTextFocused = 0 // 0 for first text, 1 for second text
    @Published var userInput = ""
}


extension MassVM{
    
    func performConversion() {
        guard let inputValue = Double(firstNum) else {
            return
        }
        
        let convertedValue = convertMass(value: inputValue, from: dropDownHeadingFirst, to: dropDownHeadingSecond)
        secondNum = "\(convertedValue)"
    }

    func performReverseConversion() {
        guard let inputValue = Double(secondNum) else {
            return
        }
        
        let convertedValue = convertMass(value: inputValue, from: dropDownHeadingSecond, to: dropDownHeadingFirst)
        firstNum = "\(convertedValue)"
    }

    func convertMass(value: Double, from unit1: String, to unit2: String) -> Double {
        let conversionFactors: [String: Double] = [
            "Tonne t": 1_000_000,
            "Kilogram kg": 1_000,
            "Gram g": 1,
            "Miligram mg": 0.001,
            "Microgram μg": 0.000001,
            "Quintal q": 100_000,
            "Pound lb": 453.592,
            "Ounce oz": 28.3495,
            "Carat ct": 0.2,
            "Grain gr": 0.0647989,
            "Long ton l.t": 1_016_050,
            "Short ton sh.t": 907_185
            
            // Add more units and their conversion factors as needed
        ]
        
        guard let factor1 = conversionFactors[unit1], let factor2 = conversionFactors[unit2] else {
            return value
        }
        
        let convertedValue = (value * factor1) / factor2
        
        return convertedValue
    }

    func buttonPressed(button: String) {
        switch button {
        case "=":
            // Handle the equal button separately if needed
            break
        case "AC":
            // Clear the focused text field and its corresponding variable
            if isTextFocused == 0 {
                firstNum = "0"
            } else {
                secondNum = "0"
            }
            userInput = ""
        case "⌫":
            // Remove the last character
            userInput = String(userInput.dropLast())
            // If the userInput becomes empty, set the corresponding variable to "0"
            if userInput.isEmpty {
                if isTextFocused == 0 {
                    firstNum = "0"
                } else {
                    secondNum = "0"
                }
            } else {
                // Update the appropriate text field based on focus
                if isTextFocused == 0 {
                    firstNum = userInput
                } else {
                    secondNum = userInput
                }
            }
            
        case ".":
            // Check if the userInput already contains a decimal point
            if !userInput.contains(".") {
                // Append the decimal point only if it's not already present
                userInput += button
                // Update the appropriate text field based on focus
                if isTextFocused == 0 {
                    firstNum = userInput
                } else {
                    secondNum = userInput
                }
            }
        default:
            // Append the pressed button to the userInput
            userInput += button
            // Limit the input to 10 digits
            if userInput.count > 15 {
                userInput = String(userInput.prefix(15))
            }
            if isTextFocused == 0 {
                firstNum = userInput
            } else {
                secondNum = userInput
            }
            
        }
    }
    
    func formatNumber(_ number: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 6 // Adjust as needed
        return numberFormatter.string(from: NSNumber(value: number)) ?? ""
    }
}

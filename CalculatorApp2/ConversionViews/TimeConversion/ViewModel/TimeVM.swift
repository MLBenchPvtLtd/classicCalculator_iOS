//
//  TimeVm.swift
//  CalculatorApp2
//
//  Created by ML Bench  on 31/01/2024.
//

import Foundation


class TimeVm: ObservableObject {
    
    @Published var firstNum = "0"
    @Published var secondNum = "0"
    
    @Published var dropDownHeadingFirst = "minute min"
    @Published var dropDownHeadingSecond = "Second s"
    
    @Published var isTextFocused = 0
    @Published var userInput = ""
    
}


extension TimeVm{
    
    func convertTime(value: Double, from sourceUnit: String, to targetUnit: String) -> String {
        // Conversion factors for different time units to seconds
        let conversionFactors: [String: Double] = [
            "Year y": 365 * 24 * 60 * 60,
            "weak wk": 7 * 24 * 60 * 60,
            "Day d": 24 * 60 * 60,
            "hour h": 60 * 60,
            "minute min": 60,
            "Second s": 1,
            "Milisecond ms": 0.001,
            "Mircosecond µs": 1e-6,
            "Picosecond ps": 1e-12
        ]
        
        // Convert the value to seconds as the base unit
        let valueInSeconds = value * conversionFactors[sourceUnit]!
        
        // Convert from seconds to the target unit
        let convertedValue = valueInSeconds / conversionFactors[targetUnit]!
        
        // Determine the number of decimal places based on the converted value
        let decimalPlaces: Int
        if convertedValue == floor(convertedValue) {
            // If the converted value is an integer, display 0 decimal places
            decimalPlaces = 0
        } else {
            // Otherwise, display up to 6 decimal places
            decimalPlaces = min(6, max(0, 6 - Int(log10(convertedValue))))
        }
        
        // Format the result to a string with the determined number of decimal places
        return String(format: "%.\(decimalPlaces)f", convertedValue)
    }
    
    func updateConversions() {
        if let value = Double(firstNum) {
            let convertedValue = convertTime(value: value, from: dropDownHeadingFirst, to: dropDownHeadingSecond)
            secondNum = convertedValue
        }
    }
    
    func buttonPressed(button: String) {
        switch button {
        case "=":
            // Handle the equal button separately if needed
            break
        case "AC":
            // Clear the focused text field and its corresponding variable
            firstNum = "0"
            secondNum = "0"
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

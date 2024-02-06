//
//  DataVM.swift
//  CalculatorApp2
//
//  Created by ML Bench  on 01/02/2024.
//

import Foundation

class DataVM: ObservableObject{
    
    @Published var firstNum = "0"
    @Published var secondNum = "0"
    
    @Published var dropDownHeadingFirst = "Megabyte MB"
    @Published var dropDownHeadingSecond = "Kilobyte KB"

    @Published var userInput = ""
    @Published var isTextFocused = 0 // 0 for first text, 1 for second text
    let dropDownOptions = [
        "Byte B",
        "Kilobyte KB",
        "Megabyte MB",
        "Gigabyte GB",
        "Terabyte TB",
        "Pentabyte PB",
    ]
    
}

extension DataVM{
    
    func updateConversion() {
        guard let input = Double(userInput) else {
            return
        }
        
        let fromMultiplier = pow(1024, Double(dropDownOptions.firstIndex(of: isTextFocused == 0 ? dropDownHeadingFirst : dropDownHeadingSecond) ?? 0))
        let toMultiplier = pow(1024, Double(dropDownOptions.firstIndex(of: isTextFocused == 0 ? dropDownHeadingSecond : dropDownHeadingFirst) ?? 0))
        
        let convertedValue = (input * fromMultiplier) / toMultiplier
        
        if isTextFocused == 0 {
            secondNum = String(convertedValue)
        } else {
            firstNum = String(convertedValue)
        }
    }
    
    func buttonPressed(button: String) {
        switch button {
        case "=":
            // Handle the equal button separately if needed
            break
            
        case "AC":
            firstNum = "0"
            secondNum = "0"
            userInput = ""
            
        case "⌫":
            // Remove the last character
            userInput = String(userInput.dropLast())
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
            
            if !userInput.contains(".") {
                userInput += button
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
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 15 // Adjust as needed
        
        if abs(number) < 1.0 {
            numberFormatter.numberStyle = .decimal
        }
        
        return numberFormatter.string(from: NSNumber(value: number)) ?? ""
    }
}

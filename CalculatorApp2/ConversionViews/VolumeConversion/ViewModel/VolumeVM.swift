//
//  VolumeVM.swift
//  CalculatorApp2
//
//  Created by ML Bench  on 01/02/2024.
//

import Foundation


class VolumeVM: ObservableObject{
    
    @Published var firstNum = "0"
    @Published var secondNum = "0"
    
    @Published var dropDownHeadingFirst = "Cubic meter m³"
    @Published var dropDownHeadingSecond = "Cubic decimeter dm³"
    
    @Published var isTextFocused = 0 
    @Published var userInput = ""
}


extension VolumeVM{
    
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
    
    func convertVolume(value: Double, from sourceUnit: String, to targetUnit: String) -> String {
        // Conversion factors for different volume units to cubic meters (m³)
        let conversionFactors: [String: Double] = [
            "Cubic meter m³": 1.0,
            "Cubic decimeter dm³": 0.001,
            "Cubic centimeter cm³": 0.000001,
            "Cubic milimeter mm³": 1e-9,
            "Hectoliter hl": 0.1,
            "Liter l": 0.001,
            "Deciliter dl": 0.0001,
            "Centiliter cl": 0.00001,
            "Mililiter ml": 0.000001,
            "Cubic Foot ft³": 0.0283168,
            "Cubic inch in³": 0.0000163871,
            "Cubic yard yd³": 0.764554857984,
            "Acre-foot af³": 1233.48
        ]
        
        // Check if the targetUnit exists in the conversionFactors dictionary
        guard let targetFactor = conversionFactors[targetUnit] else {
            return "Invalid target unit"
        }
        
        // Convert the value to cubic meters as the base unit
        let valueInCubicMeters = value * conversionFactors[sourceUnit]!
        
        // Convert from cubic meters to the target unit
        let convertedValue = valueInCubicMeters / targetFactor
        
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
            let convertedValue = convertVolume(value: value, from: dropDownHeadingFirst, to: dropDownHeadingSecond)
            secondNum = convertedValue
        }
    }
}

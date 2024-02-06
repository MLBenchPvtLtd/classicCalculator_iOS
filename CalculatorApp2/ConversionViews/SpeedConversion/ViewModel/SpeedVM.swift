//
//  SpeedVm.swift
//  CalculatorApp2
//
//  Created by ML Bench  on 31/01/2024.
//

import Foundation

class SpeedVM: ObservableObject{
    
    @Published var firstNum = "0"
    @Published var secondNum = "0"
    
    @Published var dropDownHeadingFirst = "Kilometer per hour km/h"
    @Published var dropDownHeadingSecond = "Kilometer per second km/s"
    
    @Published var isTextFocused = 0
    @Published var userInput = ""
}


extension SpeedVM{
    
    func convertToMeterPerSecond(value: Double, from unit: String) -> Double {
        switch unit {
        case "Lightspeed c":
            // Lightspeed to meters per second conversion
            return value * 299792458
        case "Mach Ma":
            // Mach to meters per second conversion (speed of sound at sea level)
            return value * 343
        case "Meter per second m/s":
            return value
        case "Kilometer per hour km/h":
            // Kilometer per hour to meters per second conversion
            return value / 3.6
        case "Kilometer per second km/s":
            // Kilometer per second to meters per second conversion
            return value * 1000
        case "Knot kn":
            // Knot to meters per second conversion
            return value * 0.514444
        case "Mile per hour mph":
            // Mile per hour to meters per second conversion
            return value * 0.44704
        case "Foot per second fps":
            // Foot per second to meters per second conversion
            return value * 0.3048
        case "Inch per second ips":
            // Inch per second to meters per second conversion
            return value * 0.0254
        default:
            return 0
        }
    }
    
    func convertFromMeterPerSecond(value: Double, to unit: String) -> Double {
        switch unit {
        case "Lightspeed c":
            return value / 299792458
        case "Mach Ma":
            return value / 343
        case "Meter per second m/s":
            return value
        case "Kilometer per hour km/h":
            return value * 3.6
        case "Kilometer per second km/s":
            return value / 1000
        case "Knot kn":
            return value / 0.514444
        case "Mile per hour mph":
            return value / 0.44704
        case "Foot per second fps":
            return value / 0.3048
        case "Inch per second ips":
            return value / 0.0254
        default:
            return 0
        }
    }
    
    func performConversion() {
        guard let value = Double(firstNum) else {
            // Handle invalid input
            return
        }
        
        let convertedValue = convertToMeterPerSecond(value: value, from: dropDownHeadingFirst)
        
        // Convert back to the selected unit for display in the second text field
        secondNum = String(convertFromMeterPerSecond(value: convertedValue, to: dropDownHeadingSecond))
    }
    
    func updateConversion() {
        guard let value = Double(firstNum) else {
            // Handle invalid input
            return
        }
        
        let convertedValue = convertToMeterPerSecond(value: value, from: dropDownHeadingFirst)
        
        // Convert to the selected unit for display in the second text field
        secondNum = String(convertFromMeterPerSecond(value: convertedValue, to: dropDownHeadingSecond))
    }
    
    func performConversionForSecondNum() {
        guard let value = Double(secondNum) else {
            // Handle invali1d input
            return
        }
        
        let convertedValue = convertToMeterPerSecond(value: value, from: dropDownHeadingSecond)
        
        // Convert back to the selected unit for display in the first text field
        firstNum = String(convertFromMeterPerSecond(value: convertedValue, to: dropDownHeadingFirst))
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
            
            //        case ".":
            //            // Check if the userInput already contains a decimal point
            //            if !userInput.contains(".") {
            //                // Append the decimal point only if it's not already present
            //                userInput += button
            //                // Update the appropriate text field based on focus
            //                if isTextFocused == 0 {
            //                    firstNum = userInput
            //                } else {
            //                    secondNum = userInput
            //                }
            //            }
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
        numberFormatter.maximumFractionDigits = 20 // Adjust as needed
        
        if abs(number) < 1.0 {
            numberFormatter.numberStyle = .decimal
        }
        
        return numberFormatter.string(from: NSNumber(value: number)) ?? ""
    }
}

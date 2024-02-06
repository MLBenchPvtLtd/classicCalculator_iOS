//
//  AreaVM.swift
//  CalculatorApp2
//
//  Created by ML Bench  on 01/02/2024.
//

import Foundation

class AreaVM: ObservableObject{
    
    @Published var firstNum = "0"
    @Published var secondNum = "0"
    
    @Published var dropDownHeadingFirst = "Square Kilometre km²"
    @Published var dropDownHeadingSecond = "Hectare ha"
    
    @Published var isTextFocused = 0 // 0 for first text, 1 for second text
    
    @Published var area: Double?
    @Published var userInput = ""
}


extension AreaVM{
    
    func updateConversion() {
        let value = (Double(firstNum) ?? 0)
        let convertedValue = AreaConverter.convert(value, fromUnit: dropDownHeadingFirst, toUnit: dropDownHeadingSecond)
        secondNum = "\(convertedValue)"
    }
    
    func buttonPressed(button: String) {
        switch button {
        case "=":
            // Handle the equal button separately if needed
            break
        case "AC":
            firstNum = "0"
            secondNum = "0"
            userInput = "0"
            
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
                firstNum = (userInput)
            } else {
                secondNum = (userInput)
            }
        }
    }
    
//    func formatNumber(_ number: Double) -> String {
//        let numberFormatter = NumberFormatter()
//        numberFormatter.numberStyle = .decimal
//        numberFormatter.maximumFractionDigits = 6 // Adjust as needed
//        return numberFormatter.string(from: NSNumber(value: number)) ?? ""
//    }
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
    
    struct AreaConverter {
        static func convert(_ value: Double, fromUnit unit1: String, toUnit unit2: String) -> Double {
            // Convert from unit1 to square meters
            let valueInSquareMeters = value * conversionFactor(unit: unit1)
            
            // Convert from square meters to unit2
            let result = valueInSquareMeters / conversionFactor(unit: unit2)
            
            return result
        }
        
        static func conversionFactor(unit: String) -> Double {
            switch unit {
            case "Square Kilometre km²": return 1_000_000.0
            case "Hectare ha": return 10_000.0
            case "Arc a": return 100.0
            case "Square metre m²": return 1.0
            case "Square decimetre dm²": return 0.01
            case "Square centimetre cm²": return 0.0001
            case "Square millimetre mm²": return 0.000001
            case "Square micron μm²": return 1e-12
            case "Acre ac": return 4046.86
            case "Square yard yd²": return 0.836127
            case "Square inch in²": return 0.00064516
                //        case "Square milli milli²": return 1e-12
                //        case "Square rod rd²": return 25.2929
                //        case "Square chi chi²": return 0.25
                //        case "Square cun cun²": return 0.0001
                //        case "Square kilometer gongli²": return 1_000_000.0
                //        case "Qing qing": return 100.0
                //        case "Mu mu": return 666.667
                // Add more cases for other units
            default: return 1.0
            }
        }
    }
}



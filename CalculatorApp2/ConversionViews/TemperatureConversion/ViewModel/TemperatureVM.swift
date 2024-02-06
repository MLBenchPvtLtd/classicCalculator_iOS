//
//  TemperatureVM.swift
//  CalculatorApp2
//
//  Created by ML Bench  on 25/01/2024.
//

import Foundation

class TemperatureVM : ObservableObject {
    
    @Published var firstNum = "0"
    @Published var secondNum = "0"
    
    @Published var userInput = ""
    
    @Published var dropDownHeadingFirst = "Kelvin K"
    @Published var dropDownHeadingSecond = "Rankine °R"
    
    @Published var isTextFocused = 0 // 0 for first text, 1 for second text
}

extension TemperatureVM {
    
    func buttonPressed(button: String) {
        switch button {
        case "=":
            // Handle the equal button separately if needed
            break
        case "AC":
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
        case ".":
               // Check if the userInput already contains a decimal point
               if !userInput.contains(".") {
                   // Append the decimal point only if it's not already present
                   if userInput.isEmpty {
                       userInput = "0" + button
                   } else {
                       userInput += button
                   }
                   // Update the appropriate text field based on focus
                   if isTextFocused == 0 {
                       firstNum = userInput
                   } else {
                       secondNum = userInput
                   }
               }
        default:
            // Append the pressed button to the userInput
            if userInput == "0" || userInput.isEmpty {
                // If the userInput is "0" or empty, replace it with the new input
                userInput = button
            } else {
                userInput += button
            }
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
    
    func convertCelsius(value: Double, toUnit: String) -> String {
        let convertedValue: Double
        switch toUnit {
        case "Celsius °C":
            convertedValue = value
        case "Fahrenheit °F":
            convertedValue = (value * 9/5) + 32
        case "Kelvin K":
            convertedValue = value + 273.15
        case "Rankine °R":
            convertedValue = (value + 273.15) * 9/5
        case "Réaumur °Ré":
            convertedValue = value * 4/5
        default:
            return "0.0"
        }
        
        let formattedResult = String(convertedValue)
        return formattedResult
    }
    
    func convertFahrenheit(value: Double, toUnit: String) -> String {
        let convertedValue: Double
        switch toUnit {
        case "Celsius °C":
            convertedValue = (value - 32) * 5/9
        case "Fahrenheit °F":
            convertedValue = value
        case "Kelvin K":
            convertedValue = (value + 459.67) * 5/9
        case "Rankine °R":
            convertedValue = value + 459.67
        case "Réaumur °Ré":
            convertedValue = (value - 32) * 4/9
        default:
            return "0.0"
        }
        
        let formattedResult = String(convertedValue)
        return formattedResult
    }
    
    func convertKelvin(value: Double, toUnit: String) -> String {
        let convertedValue: Double
        switch toUnit {
        case "Celsius °C":
            convertedValue = value - 273.15
        case "Fahrenheit °F":
            convertedValue = (value * 9/5) - 459.67
        case "Kelvin K":
            convertedValue = value
        case "Rankine °R":
            convertedValue = value * 9/5
        case "Réaumur °Ré":
            convertedValue = (value - 273.15) * 4/5
        default:
            return "0.0"
        }
        
        let formattedResult = String(convertedValue)
        return formattedResult
    }
    
    func convertRankine(value: Double, toUnit: String) -> String {
        let convertedValue: Double
        switch toUnit {
        case "Celsius °C":
            convertedValue = (value - 491.67) * 5/9
        case "Fahrenheit °F":
            convertedValue = value - 459.67
        case "Kelvin K":
            convertedValue = value * 5/9
        case "Rankine °R":
            convertedValue = value
        case "Réaumur °Ré":
            convertedValue = (value - 491.67) * 4/9
        default:
            return "0.0"
        }
        
        let formattedResult = String(convertedValue)
        return formattedResult
    }
    
    func convertReaumur(value: Double, toUnit: String) -> String {
        let convertedValue: Double
        switch toUnit {
        case "Celsius °C":
            convertedValue = value * 5/4
        case "Fahrenheit °F":
            convertedValue = (value * 9/4) + 32
        case "Kelvin K":
            convertedValue = (value * 5/4) + 273.15
        case "Rankine °R":
            convertedValue = (value * 9/4) + 491.67
        case "Réaumur °Ré":
            convertedValue = value
        default:
            return "0.0"
        }
        
        let formattedResult = String(convertedValue)
        return formattedResult
    }
    
    func calculateConversion() {
        guard let value = Double(firstNum) else {
            secondNum = "Invalid Input"
            return
        }
        
        switch dropDownHeadingFirst {
        case "Celsius °C":
            secondNum = convertCelsius(value: value, toUnit: dropDownHeadingSecond)
        case "Fahrenheit °F":
            secondNum = convertFahrenheit(value: value, toUnit: dropDownHeadingSecond)
        case "Kelvin K":
            secondNum = convertKelvin(value: value, toUnit: dropDownHeadingSecond)
        case "Rankine °R":
            secondNum = convertRankine(value: value, toUnit: dropDownHeadingSecond)
        case "Réaumur °Ré":
            secondNum = convertReaumur(value: value, toUnit: dropDownHeadingSecond)
        default:
            break
        }
    }
    
    func calculateReverseConversion() {
        guard let value = Double(secondNum) else {
            firstNum = "Invalid Input"
            return
        }
        
        switch dropDownHeadingSecond {
        case "Celsius °C":
            firstNum = convertCelsius(value: value, toUnit: dropDownHeadingFirst)
        case "Fahrenheit °F":
            firstNum = convertFahrenheit(value: value, toUnit: dropDownHeadingFirst)
//        case "Kelvin K":
//            firstNum = convertKelvin(value: value, toUnit: dropDownHeadingFirst)
        case "Rankine °R":
            firstNum = convertRankine(value: value, toUnit: dropDownHeadingFirst)
        case "Réaumur °Ré":
            firstNum = convertReaumur(value: value, toUnit: dropDownHeadingFirst)
        default:
            break
        }
    }
}

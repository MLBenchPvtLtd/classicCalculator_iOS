//
//  NumericVM.swift
//  CalculatorApp2
//
//  Created by ML Bench  on 31/01/2024.
//

import Foundation
import SwiftUI

class NumericVM: ObservableObject {
    
    @Published var firstNum = "0"
    @Published var secondNum = "0"
    
    @Published var dropDownHeadingFirst = "Hexadecimal HEX"
    @Published var dropDownHeadingSecond = "Binary BIN"
    
    @Published var isTextFocused = 0
    @Published var userInput = ""
}

extension NumericVM{
    
   
    func convertValues() {
        
        // Convert the value in the focused text field to other numeral systems
        if isTextFocused == 0 {
            if dropDownHeadingFirst == "Hexadecimal HEX" {
                if dropDownHeadingSecond == "Binary BIN" {
                    secondNum = decimalToBinary(hexadecimalToDecimal(firstNum))
                } else if dropDownHeadingSecond == "Decimal DEC" {
                    secondNum = "\(hexadecimalToDecimal(firstNum))"
                } else if dropDownHeadingSecond == "Octal OCT" {
                    secondNum = decimalToOctal(hexadecimalToDecimal(firstNum))
                } else if dropDownHeadingSecond == "Hexadecimal HEX" {
                    // Display the same as typed
                    secondNum = firstNum
                }
            } else if dropDownHeadingFirst == "Decimal DEC" {
                // Handle Decimal to other conversions similarly
                if dropDownHeadingFirst == "Decimal DEC" {
                    if dropDownHeadingSecond == "Binary BIN" {
                        secondNum = decimalToBinary(Double(firstNum) ?? 0)
                    } else if dropDownHeadingSecond == "Hexadecimal HEX" {
                        secondNum = decimalToHexadecimal(Double(firstNum) ?? 0)
                    } else if dropDownHeadingSecond == "Octal OCT" {
                        secondNum = decimalToOctal(Double(firstNum) ?? 0)
                    } else if dropDownHeadingSecond == "Decimal DEC" {
                        // Display the same as typed
                        secondNum = firstNum
                    }
                }
                
            } else if dropDownHeadingFirst == "Octal OCT" {
                // Handle Octal to other conversions similarly
                if dropDownHeadingFirst == "Octal OCT" {
                    if dropDownHeadingSecond == "Binary BIN" {
                        secondNum = decimalToBinary(octalToDecimal(firstNum))
                    } else if dropDownHeadingSecond == "Decimal DEC" {
                        secondNum = "\(octalToDecimal(firstNum))"
                    } else if dropDownHeadingSecond == "Hexadecimal HEX" {
                        secondNum = decimalToHexadecimal(octalToDecimal(firstNum))
                    } else if dropDownHeadingSecond == "Octal OCT" {
                        // Display the same as typed
                        secondNum = firstNum
                    }
                }
                
            } else {
                // Handle other cases or provide a default behavior
                convertAndSetValues(inputValue: firstNum, outputTextField: $secondNum, from: dropDownHeadingFirst, to: dropDownHeadingSecond)
            }
        } else {
            if dropDownHeadingSecond == "Hexadecimal HEX" {
                if dropDownHeadingFirst == "Binary BIN" {
                    firstNum = decimalToBinary(hexadecimalToDecimal(secondNum))
                } else if dropDownHeadingFirst == "Decimal DEC" {
                    firstNum = "\(hexadecimalToDecimal(secondNum))"
                } else if dropDownHeadingFirst == "Octal OCT" {
                    firstNum = decimalToOctal(hexadecimalToDecimal(secondNum))
                } else if dropDownHeadingFirst == "Hexadecimal HEX" {
                    // Display the same as typed
                    firstNum = secondNum
                }
            } else if dropDownHeadingSecond == "Decimal DEC" {
                
                if dropDownHeadingSecond == "Decimal DEC" {
                    if dropDownHeadingFirst == "Binary BIN" {
                        firstNum = decimalToBinary(Double(secondNum) ?? 0)
                    } else if dropDownHeadingFirst == "Hexadecimal HEX" {
                        firstNum = decimalToHexadecimal(Double(secondNum) ?? 0)
                    } else if dropDownHeadingFirst == "Octal OCT" {
                        firstNum = decimalToOctal(Double(secondNum) ?? 0)
                    } else if dropDownHeadingFirst == "Decimal DEC" {
                        // Display the same as typed
                        firstNum = secondNum
                    }
                }
            } else if dropDownHeadingSecond == "Octal OCT" {
                // Handle other conversions similarly
                if dropDownHeadingFirst == "Binary BIN" {
                    firstNum = decimalToBinary(octalToDecimal(secondNum))
                } else if dropDownHeadingFirst == "Decimal DEC" {
                    firstNum = "\(octalToDecimal(secondNum))"
                } else if dropDownHeadingFirst == "Hexadecimal HEX" {
                    firstNum = decimalToHexadecimal(octalToDecimal(secondNum))
                } else if dropDownHeadingFirst == "Octal OCT" {
                    // Display the same as typed
                    firstNum = secondNum
                }
            } else {
                // Handle other cases or provide a default behavior
                convertAndSetValues(inputValue: secondNum, outputTextField: $firstNum, from: dropDownHeadingSecond, to: dropDownHeadingFirst)
            }
        }
        
    }
    // Function to perform actual conversions
    func convertAndSetValues(inputValue: String, outputTextField: Published<String>.Publisher, from fromSystem: String, to toSystem: String) {
        guard let decimalValue = Double(inputValue) else {
            return
        }
        
        var convertedValue: Double = 0
        
        switch fromSystem {
        case "Binary BIN":
            convertedValue = binaryToDecimal(inputValue)
        case "Octal OCT":
            convertedValue = octalToDecimal(inputValue)
        case "Decimal DEC":
            convertedValue = decimalValue
        case "Hexadecimal HEX":
            convertedValue = hexadecimalToDecimal(inputValue)
        default:
            break
        }
        
        switch toSystem {
        case "Binary BIN":
            self.secondNum = decimalToBinary(convertedValue)
        case "Octal OCT":
            self.secondNum = decimalToOctal(convertedValue)
        case "Decimal DEC":
            self.secondNum = "\(convertedValue)"
        case "Hexadecimal HEX":
            self.secondNum = decimalToHexadecimal(convertedValue)
        default:
            break
        }
    }
    
    // Conversion functions
    func binaryToDecimal(_ binary: String) -> Double {
        guard let decimalValue = Int(binary, radix: 2) else {
            return 0
        }
        return Double(decimalValue)
    }
    
    func octalToDecimal(_ octal: String) -> Double {
        guard let decimalValue = Int(octal, radix: 8) else {
            return 0
        }
        return Double(decimalValue)
    }
    
    func hexadecimalToDecimal(_ hexadecimal: String) -> Double {
        guard let decimalValue = Int(hexadecimal, radix: 16) else {
            return 0
        }
        return Double(decimalValue)
    }
    
    func decimalToBinary(_ decimal: Double) -> String {
        let integerValue = Int(decimal)
        return String(integerValue, radix: 2)
    }
    
    func decimalToOctal(_ decimal: Double) -> String {
        let integerValue = Int(decimal)
        return String(integerValue, radix: 8)
    }
    
    func decimalToHexadecimal(_ decimal: Double) -> String {
        let integerValue = Int(decimal)
        return String(integerValue, radix: 16)
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
        case "A", "B", "C", "D", "E", "F":
            // Convert hex character to decimal and update the appropriate text field based on focus
            userInput += button
            if isTextFocused == 0 {
                firstNum = userInput
            } else {
                secondNum = userInput
            }
            convertValues()
        default:
            // Append the pressed button to the userInput
            userInput += button
            // Update the appropriate text field based on focus
            if isTextFocused == 0 {
                firstNum = userInput
            } else {
                secondNum = userInput
            }
        }
    }
}

//
//  LengthVM.swift
//  CalculatorApp2
//
//  Created by ML Bench  on 01/02/2024.
//

import Foundation

class LengthVM: ObservableObject{
    
    @Published var firstNum = "0"
    @Published var secondNum = "0"
    
    @Published var dropDownHeadingFirst = "Kilometer km"
    @Published var dropDownHeadingSecond = "Meter m"

    @Published var isTextFocused = 0 // 0 for first text, 1 for second text
    @Published var userInput = ""
}


extension LengthVM{
    
    func convertLength(value: Double, fromUnit: String, toUnit: String) -> Double {
           let conversionFactors: [String: Double] = [
               "Kilometer km": 1_000,
               "Meter m": 1,
               "Decimeter dm": 0.1,
               "Centimeter cm": 0.01,
               "Milimeter mm": 0.001,
               "Micrometer μm": 1e-6,
               "Nanometer nm": 1e-9,
               "Picometer pm": 1e-12,
               "Mile mi": 1_609.34,
               "Yard yd": 0.9144,
               "Foot ft": 0.3048,
               "Inch in": 0.0254
               
//               "Nautical mile nmi": 1_852,
//               "Furlong fur": 201.168,
//               "Fathom ftm": 1.8288,
//               "Gongli gongli": 0.5,
//               "Chi chi": 0.3333,
//               "Cun cun": 0.0333,
//               "Fen fen": 0.00333,
//               "Lil lil": 0.00033,
//               "Hao hao": 0.000033,
//               "Parsec pc": 3.086e+13,
//               "Lunar distance ld": 384_400_000,
//               "Astronomical unit": 149_597_870.7,
//               "Light year ly": 9.461e+15,
               // Add more units as needed
           ]

        guard let fromFactor = conversionFactors[fromUnit],
                  let toFactor = conversionFactors[toUnit] else {
                return 0
            }

            let convertedValue = value * (fromFactor / toFactor)

            // Round the result to a reasonable number of decimal places
//            let decimalPlaces = 5 // Adjust this value based on your requirements
//            let multiplier = pow(10.0, Double(decimalPlaces))
//            let roundedValue = round(convertedValue * multiplier) / multiplier

            return convertedValue
       }
    
    func updateConvertedValues() {
        guard let firstValue = Double(firstNum), let secondValue = Double(secondNum) else {
            // Handle error or edge case when the input is not a valid number
            return
        }

        let convertedValueFromFirst = convertLength(value: firstValue, fromUnit: dropDownHeadingFirst, toUnit: dropDownHeadingSecond)

        // Check if the values are different before updating
        if convertedValueFromFirst != secondValue {
            secondNum = String(convertedValueFromFirst)
        }

        let convertedValueFromSecond = convertLength(value: secondValue, fromUnit: dropDownHeadingSecond, toUnit: dropDownHeadingFirst)

        // Check if the values are different before updating
        if convertedValueFromSecond != firstValue {
            firstNum = String(convertedValueFromSecond)
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
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 20 // Adjust as needed
        
        if abs(number) < 1.0 {
            numberFormatter.numberStyle = .decimal
        }
        
        return numberFormatter.string(from: NSNumber(value: number)) ?? ""
    }
    
}

//
//  DiscoundVM.swift
//  CalculatorApp2
//
//  Created by ML Bench  on 01/02/2024.
//

import Foundation


class DiscountVM: ObservableObject{
    
    @Published var firstNum = ""
    @Published var secondNum = ""
    
    @Published var finalPrice = "0"
    @Published var savings = "0"
    
    @Published var isTextFocused = 0
    
}



extension DiscountVM{
    
    func buttonPressed(button: String) {
        let digitLimitFirstNum = 15
        let digitLimitSecondNum = 2
        
        switch button {
        case "=":
            // calculateFinalPriceAndSavings()
            break
        case "AC":
          
            if isTextFocused == 0 {
                firstNum = ""
            } else {
                secondNum = ""
            }
            finalPrice = "0"
            savings = "0"
        case "⌫":
            // Remove the last character
            if isTextFocused == 0 {
                if !firstNum.isEmpty {
                    firstNum.removeLast()
                }
            } else {
                if !secondNum.isEmpty {
                    secondNum.removeLast()
                }
            }
            updateTextInput()
            //        case ".":
            //            // Append the decimal point only if it's not already present and the digit limit is not reached
            //            if isTextFocused == 0 && !firstNum.contains(".") && firstNum.count < digitLimitFirstNum {
            //                firstNum += button
            //            } else if isTextFocused == 1 && !secondNum.contains(".") && secondNum.count < digitLimitSecondNum {
            //                secondNum += button
            //            }
            //            updateTextInput()
        case ".":
            // Check if the digit limit is reached and the next pressed digit is a decimal point
            if isTextFocused == 0 && !firstNum.contains(".") && firstNum.count < digitLimitFirstNum {
                firstNum += button  // Add the decimal point
            } else if isTextFocused == 1 && !secondNum.contains(".") && secondNum.count == digitLimitSecondNum {
                secondNum += "."  // Add the decimal point
            } else if isTextFocused == 1 && !secondNum.contains(".") && secondNum.count < digitLimitSecondNum {
                // Append the decimal point only if it's not already present and the digit limit is not reached
                secondNum += button
            }
            updateTextInput()

        // Add this case for numeric button presses after the decimal point is added
        case _ where isTextFocused == 1 && secondNum.contains(".") && secondNum.components(separatedBy: ".").last?.count ?? 0 < 2:
            // Append the pressed numeric button after the decimal point
            secondNum += button
            updateTextInput()
            calculateFinalPriceAndSavings()
        default:
            // Append the pressed button to the appropriate input if the digit limit is not reached
            if isTextFocused == 0 && firstNum.count < digitLimitFirstNum {
                firstNum += button
            } else if isTextFocused == 1 && secondNum.count < digitLimitSecondNum {
                secondNum += button
            }
            updateTextInput()
            calculateFinalPriceAndSavings()
        }
    }
    
    func updateTextInput() {
        if isTextFocused == 0 {
            finalPrice = "0"
        } else {
            savings = "0"
        }
    }
    
    func calculateFinalPriceAndSavings() {
        guard let originalPriceValue = Double(firstNum),
              let discountedPercentValue = Double(secondNum) else {
            return
        }
        
        let discountAmount = originalPriceValue * (discountedPercentValue / 100)
        let finalPriceValue = originalPriceValue - discountAmount
        let savingsValue = discountAmount
        
        finalPrice = String(format: "%.2f", finalPriceValue)
        savings = String(format: "%.2f", savingsValue)
    }
    
    func formatNumberWithCommas(_ numberString: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        
        if let number = Double(numberString) {
            return formatter.string(from: NSNumber(value: number)) ?? "0"
        } else {
            return "0"
        }
    }
}

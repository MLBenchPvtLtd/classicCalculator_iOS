//
//  bmiVM.swift
//  CalculatorApp2
//
//  Created by ML Bench  on 01/02/2024.
//

import Foundation


class bmiVM: ObservableObject{
    
    @Published var firstNum = "0"
    @Published var secondNum = "0"
    @Published var userInput = ""
    
    @Published var dropDownHeadingFirst = "Kilograms"
    @Published var dropDownHeadingSecond = "Feet"
    @Published var isTextFocused = 0 // 0 for first text, 1 for second text
    @Published var bmiResult: Double = 0
    @Published var bmiCategory = ""
    @Published var showError = false
    @Published var showingAlert = false
    
}

extension bmiVM{
    
    func calculateBMI() {
        let weight = Double(firstNum) ?? 0
        let height = Double(secondNum) ?? 0
        
        if weight == 0 || height == 0 {
            showError = true
            
            // Hide the error message after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.showError = false
            }
            
            return
        }
        
        // Additional edge cases for weight and height units
        switch (dropDownHeadingFirst, dropDownHeadingSecond) {
        case ("Kilograms", "Centimeters"):
            //      if weight < 30 || height < 76 {
            if (weight >= 30 && height < 76) || (weight < 30 && height >= 76) {
                showError = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.showError = false
                }
                break
            }
            let heightInMeters = height / 100.0
            bmiResult = weight / (heightInMeters * heightInMeters)
        case ("Kilograms", "Meters"):
            //   if weight < 30 || height < 0.8 {
            if (weight >= 30 && height < 0.8) || (weight < 30 && height >= 0.8) {
                showError = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.showError = false
                }
                break
            }
            bmiResult = weight / (height * height)
        case ("Kilograms", "Feet"):
            if (weight >= 30 && height < 2.5) || (weight < 30 && height >= 2.5) {
                showError = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.showError = false
                }
                break
            }
            let heightInMeters = height * 0.3048
            bmiResult = weight / (heightInMeters * heightInMeters)
            
        case ("Kilograms", "Inches"):
            //   if weight < 30 || height < 30 {
            if (weight >= 30 && height < 30) || (weight < 30 && height >= 30) {
                showError = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.showError = false
                }
                break
            }
            let heightInMeters = height * 0.0254
            bmiResult = weight / (heightInMeters * heightInMeters)
        case ("Pounds", "Centimeters"):
            // if weight < 66 || height < 76 {
            if (weight >= 66 && height < 76) || (weight < 66 && height >= 76) {
                showError = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.showError = false
                }
                break
            }
            // Calculate BMI for Pounds and Centimeters
            let weightInKg = weight * 0.453592
            let heightInMeters = height / 100.0
            bmiResult = weightInKg / (heightInMeters * heightInMeters)
        case ("Pounds", "Meters"):
            //  if weight < 66 || height < 0.8 {
            if (weight >= 66 && height < 0.8) || (weight < 66 && height >= 0.8) {
                showError = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.showError = false
                }
                break
            }
            // Calculate BMI for Pounds and Meters
            let weightInKg = weight * 0.453592
            bmiResult = weightInKg / (height * height)
        case ("Pounds", "Feet"):
            //   if weight < 66 || height < 2.5 {
            if (weight >= 66 && height < 2.5) || (weight < 66 && height >= 2.5) {
                showError = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.showError = false
                }
                break
            }
            // Calculate BMI for Pounds and Feet
            let weightInKg = weight * 0.453592
            let heightInInches = height * 12.0
            bmiResult = weightInKg / (heightInInches * heightInInches)
        case ("Pounds", "Inches"):
            //  if weight < 66 || height < 30 {
            if (weight >= 66 && height < 30) || (weight < 66 && height >= 30) {
                showError = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.showError = false
                }
                break
            }
            // Calculate BMI for Pounds and Inches
            let weightInKg = weight * 0.453592
            let heightInMeters = height * 0.0254
            bmiResult = weightInKg / (heightInMeters * heightInMeters)
        default:
            bmiResult = 0
        }
        
        determineBMICategory()
        if !showError {
            showingAlert = true
        }
    }
    
    func determineBMICategory() {
        if bmiResult < 18.5 {
            bmiCategory = "Underweight"
        } else if bmiResult >= 18.5 && bmiResult < 25.0 {
            bmiCategory = "Normal"
        } else {
            bmiCategory = "Overweight"
        }
    }
    var alertMessage: String {
        if bmiResult == 0 {
            return "Enter valid parameters."
        } else if bmiCategory.isEmpty {
            return "Unable to determine BMI category."
        }
        return "\(String(format: "%.2f", bmiResult)).\nBMI Category: \(bmiCategory)"
    }
    
    func buttonPressed(button: String) {
        switch button {
        case "=":
            // Handle the equal button separately if needed
            calculateBMI()
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
            if userInput.count > 3 {
                userInput = String(userInput.prefix(3))
            }
            if isTextFocused == 0 {
                firstNum = userInput
            } else {
                secondNum = userInput
            }
        }
    }
    
}

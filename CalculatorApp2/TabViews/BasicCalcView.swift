//
//  BasicCalcView.swift
//  CalculatorApp2
//
//  Created by ML Bench  on 01/01/2024.
//

import SwiftUI

struct BasicCalcView: View {
    let grid = [
        ["AC", "+/-", "%", "÷"],
        ["7", "8", "9", "X"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["0", ".", "="],
    ]

    @State private var history: [(calculation: String, timestamp: Date)] = []

    let operators = ["÷", "+", "%", "X"]

    @State var userInput = ""
    @State var result = ""
    @State var remainingDigits = 9
    @State private var decimalCount = 0
    @State var isResultError = false

    var body: some View {
        VStack {
            loadView()
        }
        .padding()
    }
}

extension BasicCalcView {
    func loadView() -> some View {
        VStack(spacing: 10) {
            header()
            Spacer()
            frameDisplay()
            Spacer()
            buttonDisplay()
        }
    }
}

extension BasicCalcView {
    func header() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("CLASSIC")
                        .font(.custom(CustomFonts.euro.rawValue, size: 25))
                        .kerning(1)
                    Spacer()
                    ForEach(0..<4) { _ in
                        createRoundedRectangle()
                    }
                }

                Text("CALCULATOR")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
        }
    }

    func createRoundedRectangle() -> some View {
        RoundedRectangle(cornerRadius: 1)
            .inset(by: 0.5)
            .stroke(Color.black, lineWidth: 1)
            .frame(width: 20, height: 19)
    }

    func frameDisplay() -> some View {
        ZStack {
            Image("frame")
                .resizable()
                .frame(width: UIScreen.main.bounds.width - 30)
                .scaledToFill()


            VStack(alignment: .trailing) {

                NavigationLink(destination: CalculationHistory(history: $history)) {

                    Image(systemName: "timer")
                        .foregroundColor(.black)
                        .font(.system(size: 14))
                        .padding(5)
                }
                Spacer()


                HStack {

                    Spacer()
                    //Text(userInput)
                    Text(formatNumberString(userInput))
                        .foregroundColor(Color.gray)
                        .font(.system(size: 30, weight: .heavy))
                        .lineLimit(3)
                        .minimumScaleFactor(0.5)

                }

                HStack {
                    Spacer()
                    if result.contains(".") {
                        Text(result.isEmpty ? "0" : result)
                            .foregroundColor(Color.black)
                            .font(.system(size: 40, weight: .heavy))
                            .font(.custom(CustomFonts.euro.rawValue, size: 40))
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                    } else {
                        Text(formatNumberString(result.isEmpty ? "0" : result))
                            .foregroundColor(Color.black)
                            .font(.system(size: 40, weight: .heavy))
                            .font(.custom(CustomFonts.euro.rawValue, size: 40))
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                    }
                }

            }
            .padding(.horizontal)
            .padding(.vertical)
        }
    }

    func buttonDisplay() -> some View {
        VStack(spacing: 15) {
            ForEach(grid, id: \.self) { row in
                HStack(spacing: 18) {
                    ForEach(row, id: \.self) { cell in
                        Button(action: {
                            buttonPressed(cell: cell)
                        }, label: {
                            Text(cell)
                                .foregroundColor(buttonColor(cell: cell))
                                .font(.custom(CustomFonts.raj.rawValue, size: 44))
                                .frame(width: buttonWidth(cell: cell), height: buttonHeight())
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.black, lineWidth: 1.5)
                                )
                        })
                    }
                }
            }
        }
    }

}

extension BasicCalcView {

    func buttonPressed(cell: String) {

        guard !isResultError else {
            // If the result is an error, do nothing until AC is pressed
            if cell == "AC" {
                isResultError = false
                userInput = ""
                result = ""
                remainingDigits = 9

            }
            return
        }

        switch cell {
        case "AC":
            userInput = ""
            result = ""
            remainingDigits = 9
            decimalCount = 0
        case "+/-":
            if !result.isEmpty {
                result = toggleSign(result)
                userInput = result
            } else {
                userInput = toggleSign(userInput)
                result = userInput
            }
        case "=":
            if result == "Error" {
                isResultError = true
                return
            }

            // Check if the last character is a minus sign and remove it
            if !userInput.isEmpty, let last = userInput.last, last == "-" {
                userInput.removeLast()
            }
            // Check if the last character is a decimal point without a following digit
            if userInput.hasSuffix(".") {
                return // Do nothing, as the expression is incomplete
            }

            result = calculateResults()

            // Handle the case where the result is an error
            if result == "Error" {
                isResultError = true
                remainingDigits = 9
            } else {
                remainingDigits = 0
            }
            if result != "Error" {
                let timestamp = Date()
                updateHistory(newCalculation: "\(userInput) = \(result)", timestamp: timestamp)
            }
            saveHistory()
        case "%":
            applyPercentage()
            result = formatResult(value: NSNumber(value: Double(userInput) ?? 0))
            // remainingDigits = 9
        case "-":
            addMinus()
            remainingDigits = 9
            decimalCount = 0

        case "X", "÷", "+":
            decimalCount = 0
            if userInput.hasSuffix(".") {
                // Remove the trailing decimal point
                userInput.removeLast()
            }
            if !userInput.isEmpty {
                if !result.isEmpty {
                    userInput = result
                }
                addOperator(cell: cell)
                remainingDigits = 9
            }
        default:
        
            if remainingDigits > 0 {
                if cell == "." {
                    // Check if the decimal count is already 0 before allowing another decimal
                    if decimalCount == 0 {
                        userInput += cell
                        remainingDigits -= 1
                        decimalCount += 1
                    }
                } else {
                    userInput += cell
                    remainingDigits -= 1
                }
            }

        }
    }

    // To Save & Update History
    func updateHistory(newCalculation: String, timestamp: Date) {
        history.append((newCalculation, timestamp))
    }

    func saveHistory() {
        do {
            // Save history to UserDefaults
            let encodedData = try JSONEncoder().encode(history.map(HistoryEntry.init))
            UserDefaults.standard.set(encodedData, forKey: "calculationHistory")
            // print("History saved successfully.")
        } catch {
            print("Error saving history: \(error)")
        }
    }

    func addOperator(cell: String) {
        // Check if userInput is not empty
        if !userInput.isEmpty {
            // Get the last character of userInput
            let last = String(userInput.last!)

            // Check if the last character is an operator or a minus sign
            if operators.contains(last) || last == "-" {
                // Remove the last character to avoid consecutive operators
                userInput.removeLast()
            }
        }
        // Add the new operator to userInput
        userInput += cell
    }


    func addMinus() {
        if userInput.hasSuffix(".") {
            // Remove the trailing decimal point
            userInput.removeLast()
        }
        if !result.isEmpty {
            userInput = result
        }

        if !userInput.isEmpty {
            let last = String(userInput.last!)
            if operators.contains(last) {
                userInput.removeLast()
                userInput += "-"
            } else if last == "-" {
                // If the last character is already a minus, remove it
                userInput.removeLast()
            } else {
                userInput += "-"
            }
        } else {
            // If userInput is empty, add a minus at the beginning
            userInput += "-"
        }

    }

    func toggleSign(_ input: String) -> String {
        if !input.isEmpty {
            if input.first != "-" {
                return "-" + input
            } else {
                return String(input.dropFirst())
            }
        }
        return input
    }

    func applyPercentage() {
        if let value = Decimal(string: result), let percentage = Decimal(string: "0.01") {
            let result = value * percentage
            userInput = String(describing: result)
        }
    }

    func calculateResults() -> String {
        var input = userInput

        // Handle the case where userInput is empty
        guard !input.isEmpty else {
            return "0" // or return an appropriate default value
        }
        // Check if the last character is an operator and remove it
        if let last = input.last, operators.contains(String(last)) {
            input.removeLast()
        }
        input = input.replacingOccurrences(of: "X", with: "*")

        if !input.contains(".") {
            // If there is no decimal point, replace ÷ with .0/
            input = input.replacingOccurrences(of: "÷", with: ".0/")
        } else {
            // If there is a decimal point, replace ÷ with /
            input = input.replacingOccurrences(of: "÷", with: "/")
        }

        // Check for division by zero
    //    if input.contains("/0") {
    //        return "Error"
    //    }

        let expression = NSExpression(format: input)

        if let resultValue = expression.expressionValue(with: nil, context: nil) as? NSNumber {
            let resultString = formatResult(value: resultValue)

            // Check for positive infinity
            if resultString == "+∞" {
                return "Error"
            }

            return resultString
        } else {
            return "Error"
        }
    }


    func formatResult(value: NSNumber) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 9

        let absValue = abs(value.doubleValue)

        if absValue >= 1e12 {
            // If the absolute value is too large or too small, display in scientific notation
            numberFormatter.numberStyle = .scientific
        } else {
            // If the value is a whole number, don't display decimal places
            if value.doubleValue.truncatingRemainder(dividingBy: 1) == 0 {
                numberFormatter.maximumFractionDigits = 0
            }
            // Otherwise, display as a regular number
            numberFormatter.numberStyle = .none
        }

        let formattedString = numberFormatter.string(from: value) ?? "Error"
        return formattedString
    }


    func formatNumberString(_ input: String) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal

        var formattedComponents: [String] = []
        let operators = CharacterSet.decimalDigits.inverted
        var currentNumericPart = ""

        for char in input {
            if String(char).rangeOfCharacter(from: operators) != nil {
                // The current character is not a digit, treat as an operator
                if let number = Double(currentNumericPart) {
                    // If the currentNumericPart is a valid number, format it
                    let formattedString = numberFormatter.string(from: NSNumber(value: number)) ?? currentNumericPart
                    formattedComponents.append(formattedString)
                } else {
                    // If the currentNumericPart is not a valid number, keep it as is
                    formattedComponents.append(currentNumericPart)
                }
                // Reset the currentNumericPart and append the operator
                currentNumericPart = ""
                formattedComponents.append(String(char))
            } else {
                // The current character is a digit, append it to the currentNumericPart
                currentNumericPart.append(char)
            }
        }

        // Process the last numeric part after the loop
        if let number = Double(currentNumericPart) {
            let formattedString = numberFormatter.string(from: NSNumber(value: number)) ?? currentNumericPart
            formattedComponents.append(formattedString)
        } else {
            formattedComponents.append(currentNumericPart)
        }
        let formattedString = formattedComponents.joined()
        return formattedString
    }

}

extension BasicCalcView {
    func buttonWidth(cell: String) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let spacing: CGFloat = 12

        if cell == "0" {
            return ((screenWidth - (4 * spacing)) / 4) * 2
        } else {
            return (screenWidth - (5 * spacing)) / 4.4
        }
    }

    func buttonHeight() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let spacing: CGFloat = 12
        return (screenWidth - (5 * spacing)) / 5.6
    }

    func buttonColor(cell: String) -> Color {
        let acBackButtonColor = Color(red: 0.51, green: 0.74, blue: 0.79)
        let operatorButtonColor = Color(red: 0.87, green: 0.68, blue: 0.38)

        if cell == "AC" || cell == "+/-" || cell == "%" {
            return acBackButtonColor
        }

        if operators.contains(cell) || cell == "=" || cell == "+" || cell == "-" || cell == "x" || cell == "÷" {
            return operatorButtonColor
        }

        return (Color("digit"))
    }
}

#Preview {
    BasicCalcView()
}


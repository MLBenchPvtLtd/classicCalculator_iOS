//
//  CurrencyConversionView.swift
//  CalculatorApp2
//
//  Created by ML Bench  on 02/01/2024.
//

import SwiftUI
import Alamofire

struct CurrencyConversionView: View {
    @State private var firstNum = "0"
    @State private var secondNum = "0"
    
    @State private var dropDownHeadingFirst = "Select Currency"
    @State private var dropDownHeadingSecond = "Select Currency"
    
    @State private var isTextFocused = 0 
    @State private var selectedConversionRate: Double?
    
    @State var userInput = ""
    @State var currencyList = [String]()
    
    @StateObject private var currencyVM = CurrencyVM()
    
    var body: some View {
        VStack {
            
            loadView()
        }
        .padding()
        .navigationBarTitle("Currency")
   

    }
    
    
}

extension CurrencyConversionView{
    
    func loadView() -> some View{
        VStack (alignment: . leading, spacing: 50){
            
            HStack {
                Menu {
                    ForEach(currencyList.sorted(), id: \.self) { currencyCode in
                        let currencyName = currencyVM.currencyName(for: currencyCode)
                        Button(action: {
                            dropDownHeadingFirst = "\(currencyName) (\(currencyCode))"
                            if let conversionRate = currencyVM.currency.conversionRates[currencyCode] {
                                selectedConversionRate = conversionRate
                            }
                        }) {
                            Text("\(currencyName) (\(currencyCode))")
                        }
                    }
                }
            label: {
                Text(dropDownHeadingFirst)
                Image(systemName: "arrowtriangle.down.fill")
                    .resizable()
                    .frame(width: 9, height: 6)
            }
            .onAppear {
                currencyVM.apiRequest(url: "https://v6.exchangerate-api.com/v6/15bf24d063d498e7b1039038/latest/USD")

                // Set default selected currency to AED to PKR
                let defaultCurrencyCode = "AED"
                let defaultCurrencyName = currencyVM.currencyName(for: defaultCurrencyCode)
                dropDownHeadingFirst = "\(defaultCurrencyName) (\(defaultCurrencyCode))"
                
                if let conversionRate = currencyVM.currency.conversionRates[defaultCurrencyCode] {
                    selectedConversionRate = conversionRate
                }
            }
            .onReceive(currencyVM.$currency) { updatedCurrency in
                currencyList = updatedCurrency.conversionRates.keys.map { $0 }
            }
                
            .onChange(of: dropDownHeadingFirst) { newValue in
                
                convertValues()
            }
                
                
                Spacer()
                
                VStack(alignment: .trailing){
                    
                    Text(firstNum)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(isTextFocused == 0 ? Color(red: 0.51, green: 0.74, blue: 0.79) : .black)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .onTapGesture {
                            if isTextFocused == 1 {
                                userInput = ""
                            }
                            self.isTextFocused = 0
                        }
                        .onChange(of: firstNum) { newValue in
                            
                            convertValues()
                        }
                    
                    
                    Text(dropDownHeadingFirst)
                        .font(.system(size: 11, weight: .medium))
                    
                }
                
            }
            .font(.system(size: 15, weight: .bold))
            .foregroundColor(.gray)
            
            HStack {
                Menu {
                    ForEach(currencyList.sorted(), id: \.self) { currencyCode in
                        let currencyName = currencyVM.currencyName(for: currencyCode)
                        Button(action: {
                            dropDownHeadingSecond = "\(currencyName) (\(currencyCode))"
                            if let conversionRate = currencyVM.currency.conversionRates[currencyCode] {
                                selectedConversionRate = conversionRate
                            }
                        }) {
                            Text("\(currencyName) (\(currencyCode))")
                        }
                    }
                }
            label:
                {
                    Text(dropDownHeadingSecond)
                    Image(systemName: "arrowtriangle.down.fill")
                        .resizable()
                        .frame(width: 9, height: 6)
                }
                .onChange(of: dropDownHeadingSecond) { newValue in
                    convertValues()
                }
                
                
                Spacer()
                
                VStack(alignment: .trailing){
                    
                    Text(secondNum)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(isTextFocused == 1 ? Color(red: 0.51, green: 0.74, blue: 0.79) : .black)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .onTapGesture {
                            if isTextFocused == 0 {
                                userInput = ""
                            }
                            self.isTextFocused = 1
                        }
                      
                        .onChange(of: secondNum) { newValue in
                            reverseConvertValues()
                        }
                    
                    Text(dropDownHeadingSecond)
                        .font(.system(size: 11, weight: .medium))
                    
                }
            }
            .font(.system(size: 15, weight: .bold))
            .foregroundColor(.gray)
            
            Spacer()
            NumericButtonView(userInput: isTextFocused == 0 ? $firstNum : $secondNum) { button in
                buttonPressed(button: button)
            }
            
        }
    }
    
    func convertValues() {
        // Check if there's a selected currency and a conversion rate
        if let selectedConversionRate = selectedConversionRate {
            // Convert the firstNum to a Double
            if let amountToConvert = Double(firstNum) {
                // Perform the currency conversion
                let convertedAmount = amountToConvert * selectedConversionRate
                // Update the secondNum with the converted amount
                secondNum = String(format: "%.2f", convertedAmount)
            }
        }
    }
    
    func reverseConvertValues() {
        // Check if there's a selected currency and a conversion rate
        if let selectedConversionRate = selectedConversionRate {
            // Convert the secondNum to a Double
            if let amountToConvert = Double(secondNum) {
                // Perform the reverse currency conversion
                let convertedAmount = amountToConvert / selectedConversionRate
                // Update the firstNum with the converted amount
                firstNum = String(format: "%.2f", convertedAmount)
            }
        }
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

#Preview {
    CurrencyConversionView()
}


//
//  NumericalConversionView.swift
//  CalculatorApp2
//
//  Created by ML Bench  on 02/01/2024.
//

import SwiftUI

struct NumericConversionView: View {
    
    let dropDownOptions = [
        "Binary BIN",
        "Octal OCT",
        "Decimal DEC",
        "Hexadecimal HEX"
        
    ]
    @StateObject private var vm = NumericVM()
    
    var body: some View {
        VStack {
            
            loadView()
        }
        .padding()
        .navigationBarTitle("Numeral")
    }
    
    
}

extension NumericConversionView{
    
    var currentNumeralSystem: String {
        return vm.isTextFocused == 0 ? vm.dropDownHeadingFirst : vm.dropDownHeadingSecond
    }
    
    func loadView() -> some View{
        VStack (alignment: . leading, spacing: 50){
            
            HStack {
                Menu {
                    ForEach(dropDownOptions, id: \.self) { unit in
                        Button(action: {
                            vm.dropDownHeadingFirst = unit
                        }) {
                            Text(unit)
                        }
                    }
                }
            label: {
                Text(vm.dropDownHeadingFirst)
                Image(systemName: "arrowtriangle.down.fill")
                    .resizable()
                    .frame(width: 9, height: 6)
            }
            .onChange(of: vm.dropDownHeadingFirst) { newValue in
                
                vm.firstNum = "0"
                vm.secondNum = "0"
                vm.userInput = ""
                vm.convertValues()
            }
                
                
                Spacer()
                
                VStack(alignment: .trailing){
                    
                    Text(vm.firstNum)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(vm.isTextFocused == 0 ? Color(red: 0.51, green: 0.74, blue: 0.79) : .black)
                        .lineLimit(2)
                        .minimumScaleFactor(0.5)
                        .onTapGesture {
                            if vm.isTextFocused == 1 {
                                vm.userInput = ""
                            }
                            self.vm.isTextFocused = 0
                        }
                        .onChange(of: vm.firstNum) { newValue in
                            
                            vm.convertValues()
                        }
                    
                    
                    Text(vm.dropDownHeadingFirst)
                        .font(.system(size: 11, weight: .medium))
                    
                }
                
            }
            .font(.system(size: 15, weight: .bold))
            .foregroundColor(.gray)
            
            HStack {
                Menu{
                    ForEach(dropDownOptions, id: \.self) { unit in
                        Button(action: {
                            vm.dropDownHeadingSecond = unit
                        }) {
                            Text(unit)
                        }
                    }
                }
            label:{
                Text(vm.dropDownHeadingSecond)
                Image(systemName: "arrowtriangle.down.fill")
                    .resizable()
                    .frame(width: 9, height: 6)
            }
            .onChange(of: vm.dropDownHeadingSecond) { newValue in
                
                vm.firstNum = "0"
                vm.secondNum = "0"
                vm.userInput = ""
                vm.convertValues()
            }
                
                
                Spacer()
                
                VStack(alignment: .trailing){
                    
                    Text(vm.secondNum)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(vm.isTextFocused == 1 ? Color(red: 0.51, green: 0.74, blue: 0.79) : .black)
                        .lineLimit(2)
                        .minimumScaleFactor(0.5)
                        .onTapGesture {
                            if vm.isTextFocused == 0 {
                                vm.userInput = ""
                            }
                            self.vm.isTextFocused = 1
                        }
                        .onChange(of: vm.secondNum) { newValue in
                            
                            vm.convertValues()
                        }
                    
                    Text(vm.dropDownHeadingSecond)
                        .font(.system(size: 11, weight: .medium))
                    
                }
            }
            .font(.system(size: 15, weight: .bold))
            .foregroundColor(.gray)
            
            Spacer()
            
            NumericButtonView2(userInput: vm.isTextFocused == 0 ? $vm.firstNum : $vm.secondNum,
                               onButtonPress: { button in vm.buttonPressed(button: button) },
                               isBinaryConversion: true,
                               numeralSystem: currentNumeralSystem)
            
            
        }
    }
}

#Preview {
    NumericConversionView()
}

struct NumericButtonView2: View {
    let numbers: [[String]] = [
        ["AC","⌫", "F", "E"],
        ["7", "8", "9", "D"],
        ["4", "5", "6", "C"],
        ["1", "2", "3", "B"],
        ["0", ".", "=", "A"]
    ]
    
    @Binding var userInput: String
    var onButtonPress: (String) -> Void
    var isBinaryConversion: Bool
    var numeralSystem: String
    
    var body: some View {
        HStack {
            VStack(spacing: 15) {
                ForEach(numbers, id: \.self) { row in
                    HStack(spacing: 18) {
                        ForEach(row, id: \.self) { number in
                            Button(action: {
                                onButtonPress(number)
                            }, label: {
                                if number == "⌫" {
                                    Image(systemName: "delete.backward")
                                        .font(.system(size: 35)) // Increase the size here
                                        .foregroundColor(Color(red: 0.87, green: 0.68, blue: 0.38))
                                } else {
                                    Text(number)
                                        .foregroundColor(buttonTextColor(for: number))
                                        .font(.custom(CustomFonts.raj.rawValue, size: 44))
                                }
                            })
                            .frame(width: buttonWidth(), height: buttonHeight())
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 1.5)
                            )
                            .disabled(isDisabled(for: number))
                            .opacity(isDisabled(for: number) ? 0.3 : 1.0)
                        }
                    }
                }
            }
            
            Spacer()
            
        }
    }
    
    
    
    func buttonWidth() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let spacing: CGFloat = 12
        return (screenWidth - (5 * spacing)) / 4.4
    }
    
    func buttonHeight(isDoubleHeight: Bool = false) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let spacing: CGFloat = 12
        let baseHeight = (screenWidth - (5 * spacing)) / 5.6
        return isDoubleHeight ? baseHeight * 2.3 : baseHeight
    }
    
    
    
    func isDisabled(for number: String) -> Bool {
        
        if ["AC", "⌫", ".", "="].contains(number) {
            return false
        }
        
        switch numeralSystem {
        case "Binary BIN":
            return isBinaryDisabled(for: number)
        case "Octal OCT":
            return !["0", "1", "2", "3", "4", "5", "6", "7"].contains(number)
        case "Decimal DEC":
            return !["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"].contains(number)
        case "Hexadecimal HEX":
            return isHexadecimalDisabled(for: number)
        default:
            return false
        }
    }
    
    func isBinaryDisabled(for number: String) -> Bool {
        return numeralSystem == "Binary BIN" && !["0", "1"].contains(number)
    }
    
    func isHexadecimalDisabled(for number: String) -> Bool {
        let validHexCharacters = Set("0123456789ABCDEF")
        return numeralSystem == "Hexadecimal HEX" && !validHexCharacters.contains(number)
    }
    
    
    func buttonTextColor(for number: String) -> Color {
        if ["AC", "⌫"].contains(number) {
            return  Color(red: 0.87, green: 0.68, blue: 0.38)
            
        } else if ["A", "B", "C", "D", "E", "F"].contains(number) {
            return Color(red: 0.51, green: 0.74, blue: 0.79)
            
        } else {
            return Color.black
        }
    }
    
}

//
//  NumericButtonView.swift
//  CalculatorApp2
//
//  Created by ML Bench  on 04/01/2024.
//

import SwiftUI

struct NumericButtonView: View {
    let numbers: [[String]] = [
        ["7", "8", "9"],
        ["4", "5", "6"],
        ["1", "2", "3"],
        ["0", ".", "="]
    ]
    
    @Binding var userInput: String
    var onButtonPress: (String) -> Void
    
    var body: some View {
        HStack {
            VStack(spacing: 15) {
                ForEach(numbers, id: \.self) { row in
                    HStack(spacing: 18) {
                        ForEach(row, id: \.self) { number in
                            Button(action: {
                                onButtonPress(number)
                            }, label: {
                                Text(number)
                                    .foregroundColor(.black)
                                    .font(.custom(CustomFonts.raj.rawValue, size: 44))
                                    .frame(width: buttonWidth(), height: buttonHeight())
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.black, lineWidth: 1.5)
                                    )
                            })
                        }
                    }
                }
            }
            
            Spacer()
            
            VStack(spacing: 15) {
                Button(action: {
                    onButtonPress("AC")
                }, label: {
                    Text("AC")
                        .foregroundColor(Color(red: 0.87, green: 0.68, blue: 0.38))
                        .font(.custom(CustomFonts.raj.rawValue, size: 44))
                        .frame(width: buttonWidth(), height: buttonHeight(isDoubleHeight: true))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1.5)
                        )
                })
                
                Button(action: {
                    onButtonPress("⌫")
                }, label: {
                   // Image(systemName: "delete.backward")
                    Text("⌫")
                        .font(.system(size: 40))
                        .foregroundColor(Color(red: 0.87, green: 0.68, blue: 0.38))
                        .font(.custom(CustomFonts.raj.rawValue, size: 44))
                        .frame(width: buttonWidth(), height: buttonHeight(isDoubleHeight: true))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1.5)
                        )
                })
            }
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
}


#Preview {
    NumericButtonView(userInput: .constant(""), onButtonPress: { _ in })
}



//
//  DiscountConversionView.swift
//  CalculatorApp2
//
//  Created by ML Bench  on 01/01/2024.
//

import SwiftUI

struct DiscountConversionView: View {
   
    @StateObject private var vm = DiscountVM()
    
    var body: some View {
        VStack {
            loadView()
        }
        .padding()
        .navigationBarTitle("Discount")
    }
    
    func loadView() -> some View {
        VStack {
            VStack(spacing: 20) {
                HStack {
                    Text("Original Price")
                        .font(.system(size: 16, weight: .bold))
                    Spacer()
                    Text(vm.formatNumberWithCommas(vm.firstNum.isEmpty ? "0" : vm.firstNum))
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(vm.isTextFocused == 0 ? Color(red: 0.51, green: 0.74, blue: 0.79) : .black)
                        .onTapGesture {
                            vm.isTextFocused = 0
                        }
                }
                .foregroundColor(vm.isTextFocused == 0 ? Color(red: 0.51, green: 0.74, blue: 0.79) : .black)
                
                HStack {
                    Text("Discount (% off)")
                        .font(.system(size: 16, weight: .bold))
                    Spacer()
                    Text(vm.secondNum.isEmpty ? "0" : vm.secondNum)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(vm.isTextFocused == 1 ? Color(red: 0.51, green: 0.74, blue: 0.79) : .black)
                        .onTapGesture {
                            vm.isTextFocused = 1
                        }
                }.foregroundColor(vm.isTextFocused == 1 ? Color(red: 0.51, green: 0.74, blue: 0.79) : .black)
                
                HStack {
                    Text("Final Price")
                        .font(.system(size: 16, weight: .bold))
                    Spacer()
                    Text(vm.finalPrice)
                        .font(.system(size: 20, weight: .bold))
                }
                
                HStack {
                    Text("You save: ")
                        .font(.system(size: 16, weight: .bold))
                    // Spacer()
                    Text(vm.savings)
                        .font(.system(size: 20, weight: .bold))
                }
                .foregroundColor(.gray)
            }
            
            Spacer()
            
            NumericButtonView(userInput: vm.isTextFocused == 0 ? $vm.firstNum : $vm.secondNum) { button in
                vm.buttonPressed(button: button)
            }
        }
    }
    
}


#Preview {
    DiscountConversionView()
}

//
//  AreaConversionView.swift
//  CalculatorApp2
//
//  Created by ML Bench  on 01/01/2024.
//

import SwiftUI

struct AreaConversionView: View {
   
    
    let dropDownOptions = [
        "Square Kilometre km²",
        "Hectare ha",
        "Arc a",
        "Square metre m²",
        "Square decimetre dm²",
        "Square centimetre cm²",
        "Square millimetre mm²",
        "Square micron μm²",
        "Acre ac",
        "Square yard yd²",
        "Square inch in²"
        
        //        "Square milli milli²",
        //        "Square rod rd²",
        //        "Square chi chi²",
        //        "Square cun cun²",
        //        "Square kilometer gongli²",
        //        "Qing qing",
        //        "Mu mu"
    ]
    @StateObject private var vm = AreaVM()

    var body: some View {
        VStack {
            loadView()
        }
        .padding()
        .navigationBarTitle("Area")
    }
    
    func loadView() -> some View {
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
                HStack {
                    Text(vm.dropDownHeadingFirst)
                    Image(systemName: "arrowtriangle.down.fill")
                        .resizable()
                        .frame(width: 9, height: 6)
                }
            }
            .onChange(of: vm.dropDownHeadingFirst) { _ in
                vm.updateConversion()
            }
                
                Spacer()
                
                VStack(alignment: .trailing){
                    
                    Text(vm.formatNumber(Double(vm.firstNum) ?? 0))
                   // Text(firstNum)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(vm.isTextFocused == 0 ? Color(red: 0.51, green: 0.74, blue: 0.79) : .black)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .onTapGesture {
                            if vm.isTextFocused == 1 {
                                vm.userInput = ""
                            }
                            self.vm.isTextFocused = 0
                        }
                    
                        .onChange(of: vm.firstNum) { _ in
                            vm.updateConversion()
                        }
                    
                    Text(vm.dropDownHeadingFirst)
                        .font(.system(size: 11, weight: .medium))
                    
                }
            }
            .font(.system(size: 15, weight: .bold))
            .foregroundColor(.gray)
            
            HStack {
                Menu {
                    ForEach(dropDownOptions, id: \.self) { unit in
                        Button(action: {
                            vm.dropDownHeadingSecond = unit
                        }) {
                            Text(unit)
                        }
                    }
                }
            label: {
                HStack {
                    Text(vm.dropDownHeadingSecond)
                    Image(systemName: "arrowtriangle.down.fill")
                        .resizable()
                        .frame(width: 9, height: 6)
                }
            }
            .onChange(of: vm.dropDownHeadingSecond) { _ in
                vm.updateConversion()
            }
                
                Spacer()
                
                VStack(alignment: .trailing){
                    
                    Text(vm.formatNumber(Double(vm.secondNum) ?? 0))
                   // Text(secondNum)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(vm.isTextFocused == 1 ? Color(red: 0.51, green: 0.74, blue: 0.79) : .black)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .onTapGesture {
                            if vm.isTextFocused == 0 {
                                vm.userInput = ""
                            }
                            self.vm.isTextFocused = 1
                        }
                        .onChange(of: vm.secondNum) { _ in
                            let value = (Double(vm.secondNum) ?? 0)
                            let convertedValue = AreaVM.AreaConverter.convert(value, fromUnit: vm.dropDownHeadingSecond, toUnit: vm.dropDownHeadingFirst)
                            vm.firstNum = "\(convertedValue)"
                        }
                    
                    Text(vm.dropDownHeadingSecond)
                        .font(.system(size: 11, weight: .medium))
                    
                }
            }
            .font(.system(size: 15, weight: .bold))
            .foregroundColor(.gray)
            
            Spacer()
            
            NumericButtonView(userInput: vm.isTextFocused == 0 ? $vm.firstNum : $vm.secondNum) { button in
                vm.buttonPressed(button: button)
            }
            
        }
    }
    
  

    
}

#Preview
{
    AreaConversionView()
}



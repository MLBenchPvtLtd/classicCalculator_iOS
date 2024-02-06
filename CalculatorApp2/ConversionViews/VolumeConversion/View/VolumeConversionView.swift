//
//  VolumeConversionView.swift
//  CalculatorApp2
//
//  Created by ML Bench  on 01/01/2024.
//

import SwiftUI

struct VolumeConversionView: View {
    
    let dropDownOptions = [
        "Cubic meter m³",
        "Cubic decimeter dm³",
        "Cubic centimeter cm³",
        "Cubic milimeter mm³",
        "Hectoliter hl",
        "Liter l",
        "Deciliter dl",
        "Centiliter cl",
        "Mililiter ml",
        "Cubic Foot ft³",
        "Cubic inch in³",
        "Cubic yard yd³",
        "Acre-foot af³"
    ]
    @StateObject private var vm = VolumeVM()
    
    var body: some View {
        VStack {
            
            loadView()
        }
        .padding()
        .navigationBarTitle("Volume")
    }
}


extension VolumeConversionView{
    
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
            label:{
                Text(vm.dropDownHeadingFirst)
                Image(systemName: "arrowtriangle.down.fill")
                    .resizable()
                    .frame(width: 9, height: 6)
            }
            .onChange(of: vm.dropDownHeadingFirst) { newValue in
                vm.updateConversions()
            }
                
                
                Spacer()
                
                VStack(alignment: .trailing){
                    
                    Text(vm.formatNumber(Double(vm.firstNum) ?? 0))
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
                        .onChange(of: vm.firstNum) { newValue in
                            if vm.isTextFocused == 0 {
                                if let value = Double(newValue) {
                                    let convertedValue = vm.convertVolume(value: value, from: vm.dropDownHeadingFirst, to: vm.dropDownHeadingSecond)
                                    vm.secondNum = convertedValue
                                }
                            }
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
            label:{
                Text(vm.dropDownHeadingSecond)
                Image(systemName: "arrowtriangle.down.fill")
                    .resizable()
                    .frame(width: 9, height: 6)
            }
                
            .onChange(of: vm.dropDownHeadingSecond) { newValue in
                vm.updateConversions()
            }
                
                
                Spacer()
                
                VStack(alignment: .trailing){
                    
                    Text(vm.formatNumber(Double(vm.secondNum) ?? 0))
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
                        .onChange(of: vm.secondNum) { newValue in
                            if vm.isTextFocused == 1 {
                                if let value = Double(newValue) {
                                    let convertedValue = vm.convertVolume(value: value, from: vm.dropDownHeadingSecond, to: vm.dropDownHeadingFirst)
                                    vm.firstNum = convertedValue
                                }
                            }
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

#Preview {
    VolumeConversionView()
}

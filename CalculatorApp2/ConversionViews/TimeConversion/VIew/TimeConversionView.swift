//
//  TimeConversionVIew.swift
//  CalculatorApp2
//
//  Created by ML Bench  on 01/01/2024.
//

import SwiftUI

struct TimeConversionView: View {
    
    let dropDownOptions = [
        "Year y",
        "weak wk",
        "Day d",
        "hour h",
        "minute min",
        "Second s",
        "Milisecond ms",
        "Mircosecond µs",
        "Picosecond ps"
    ]
    
    @StateObject private var vm = TimeVm()
    
    
    var body: some View {
        VStack {
            
            loadView()
        }
        .padding()
        .navigationBarTitle("Time")
    }
}

extension TimeConversionView{
    
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
            label:
                {
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
                                    let convertedValue = vm.convertTime(value: value, from: vm.dropDownHeadingFirst, to: vm.dropDownHeadingSecond)
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
                                    let convertedValue = vm.convertTime(value: value, from: vm.dropDownHeadingSecond, to: vm.dropDownHeadingFirst)
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
    TimeConversionView()
}

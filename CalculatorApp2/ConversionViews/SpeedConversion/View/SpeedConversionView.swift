//
//  SpeedConversionVIew.swift
//  CalculatorApp2
//
//  Created by ML Bench  on 01/01/2024.
//

import SwiftUI

struct SpeedConversionView: View {
    
    
    
    let dropDownOptions = [
        "Lightspeed c",
        "Mach Ma",
        "Meter per second m/s",
        "Kilometer per hour km/h",
        "Kilometer per second km/s",
        "Knot kn",
        "Mile per hour mph",
        "Foot per second fps",
        "Inch per second ips"
    ]
   
    @StateObject private var vm = SpeedVM()
    
    var body: some View {
        VStack {
            
            loadView()
        }
        .padding()
        .navigationBarTitle("Speed")
    }
    
    
}

extension SpeedConversionView{
    
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
                .onChange(of: vm.dropDownHeadingFirst) { _ in
                    vm.updateConversion()
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
                        .onChange(of: vm.firstNum) { _ in
                            vm.performConversion()
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
            label:
                {
                    Text(vm.dropDownHeadingSecond)
                    Image(systemName: "arrowtriangle.down.fill")
                        .resizable()
                        .frame(width: 9, height: 6)
                }
                .onChange(of: vm.dropDownHeadingSecond) { _ in
                    vm.updateConversion()
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
                        .onChange(of: vm.secondNum) { _ in
                            vm.performConversionForSecondNum()
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
    SpeedConversionView()
}

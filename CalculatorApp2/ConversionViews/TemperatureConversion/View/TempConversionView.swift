//
//  TempConversionView.swift
//  CalculatorApp2
//
//  Created by ML Bench  on 01/01/2024.
//

import SwiftUI

struct TempConversionView: View {
    
    
    let dropDownOptions = [
        "Celsius °C",
        "Fahrenheit °F",
        "Kelvin K",
        "Rankine °R",
        "Réaumur °Ré"
    ]
    
    @StateObject private var vm = TemperatureVM()
    
    var body: some View {
        VStack {
            loadView()
        }
        .padding()
        .navigationBarTitle("Temperature")
    }
    
    func loadView() -> some View {
        VStack (alignment: .leading, spacing: 50) {
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
                    vm.calculateConversion()
                }
                
                
                Spacer()
                
                VStack(alignment: .trailing){
                    Text(formatNumber(Double(vm.firstNum) ?? 0))
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
                            vm.calculateConversion()
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
                .onChange(of: vm.dropDownHeadingSecond) { newValue in
                    vm.calculateConversion()
                }
                
                
                Spacer()
                
                VStack(alignment: .trailing){
                    Text(formatNumber(Double(vm.secondNum) ?? 0))
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
                            //calculateConversion()
                            vm.calculateReverseConversion()
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
    
 func formatNumber(_ number: Double) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    numberFormatter.minimumFractionDigits = 0
    numberFormatter.maximumFractionDigits = 10 // Adjust as needed
    
    if abs(number) < 1.0 {
        numberFormatter.numberStyle = .decimal
    }
    
    return numberFormatter.string(from: NSNumber(value: number)) ?? ""
}
    

}

#Preview {
    TempConversionView()
}

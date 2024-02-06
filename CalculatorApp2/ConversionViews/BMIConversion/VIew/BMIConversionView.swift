//
//  BMIConversionView.swift
//  CalculatorApp2
//
//  Created by ML Bench  on 01/01/2024.
//

import SwiftUI

struct BMIConversionView: View {
    
    let dropDownOptionsFirst = [
        "Kilograms",
        "Pounds"
    ]
  
    let dropDownOptionsSecond = [
        "Centimeters",
        "Meters",
        "Feet",
        "Inches"
    ]
    
    @StateObject private var vm = bmiVM()
    
    var body: some View {
        VStack {
            
            loadView()
        }
        .padding()
        .navigationBarTitle("BMI")
        .alert(isPresented: $vm.showingAlert) {
            Alert(title: Text("BMI Result"), message: Text(vm.alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    
}

extension BMIConversionView{
    
    func loadView() -> some View{
        VStack (alignment: . center, spacing: 50){
            
            HStack {
                
                Menu {
                    ForEach(dropDownOptionsFirst, id: \.self) { unit in
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
                
                Spacer()
                
                VStack(alignment: .trailing){
                    
                    Text(vm.firstNum)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(vm.isTextFocused == 0 ? Color(red: 0.51, green: 0.74, blue: 0.79) : .black)
                        .onTapGesture {
                            if vm.isTextFocused == 1 {
                                vm.userInput = ""
                            }
                            self.vm.isTextFocused = 0
                        }
                    
                    
                    Text(vm.dropDownHeadingFirst)
                        .font(.system(size: 11, weight: .medium))
                    
                }
            }
            .font(.system(size: 15, weight: .bold))
            .foregroundColor(.gray)
            
            HStack {
                Menu {
                    ForEach(dropDownOptionsSecond, id: \.self) { unit in
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
                
                Spacer()
                
                VStack(alignment: .trailing){
                    
                    Text(vm.secondNum)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(vm.isTextFocused == 1 ? Color(red: 0.51, green: 0.74, blue: 0.79) : .black)
                        .onTapGesture {
                            if vm.isTextFocused == 0 {
                                vm.userInput = ""
                            }
                            self.vm.isTextFocused = 1
                        }
                    
                    Text(vm.dropDownHeadingSecond)
                        .font(.system(size: 11, weight: .medium))
                    
                }
            }
            .font(.system(size: 15, weight: .bold))
            .foregroundColor(.gray)
            
            
            Button(action: {
                vm.calculateBMI()
            }) {
                GenericButtonText(text: "Calculate BMI")
            }
            
            Spacer()
            
            if vm.showError {
                Text("Enter valid parameters.")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.red)
            }
            
            NumericButtonView(userInput: vm.isTextFocused == 0 ? $vm.firstNum : $vm.secondNum) { button in
                vm.buttonPressed(button: button)
            }
            
        }
    }
    
}

#Preview {
    BMIConversionView()
}

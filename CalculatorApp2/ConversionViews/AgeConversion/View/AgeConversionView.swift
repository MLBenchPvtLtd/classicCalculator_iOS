
//  AgeConversionView.swift
//  CalculatorApp2
//
//  Created by ML Bench  on 01/01/2024.


import SwiftUI

struct AgeConversionView: View {
    
    @StateObject private var vm = AgeVM()
    
    
    var body: some View {
        VStack {
            loadView()
        }
        .padding()
        .navigationBarTitle("Age")
        .onAppear()
        {
            vm.calculateAge()
        }
        
    }
}

extension AgeConversionView {
    
    func loadView() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            
            HStack {
                Text("Date of Birth:")
                // .foregroundColor(.gray)
                    .font(.system(size: 15, weight: .bold))
                Spacer()
                
                HStack {
                    
                    Button(action: {
                        vm.isDatePickerPresentedDOB.toggle()
                        vm.isTextFocused = 0
                    }) {
                        HStack{
                            Text(vm.dateFormatter.string(from: vm.startDateDOB))
                            Image(systemName: "arrowtriangle.down.fill")
                                .resizable()
                                .frame(width: 9, height: 6)
                        }
                    }
                    .sheet(isPresented: $vm.isDatePickerPresentedDOB) {
                        DatePickerBottomSheetView(birthdate: $vm.startDateDOB, isDatePickerPresented: $vm.isDatePickerPresentedDOB) {
                            // Callback closure to calculate age
                            vm.calculateAge()
                        }
                        .presentationDetents([.height(450)])
                    }
                }
            }
            .foregroundColor(vm.isTextFocused == 0 ? Color(red: 0.51, green: 0.74, blue: 0.79) : .gray)
            
            
            
            HStack {
                Text("Today:")
                // .foregroundColor(.gray)
                    .font(.system(size: 15, weight: .bold))
                Spacer()
                
                HStack {
                    
                    Button(action: {
                        vm.isDatePickerPresentedCD.toggle()
                        vm.isTextFocused = 1
                    }) {
                        HStack{
                            Text(vm.dateFormatter.string(from: vm.endDateCD))
                            Image(systemName: "arrowtriangle.down.fill")
                                .resizable()
                                .frame(width: 9, height: 6)
                        }
                    }
                    .sheet(isPresented: $vm.isDatePickerPresentedCD) {
                        DatePickerBottomSheetView(birthdate: $vm.endDateCD, isDatePickerPresented: $vm.isDatePickerPresentedCD) {
                            // Callback closure to calculate age
                            vm.calculateAge()
                        }
                        .presentationDetents([.height(450)])
                    }
                }
            }
            .foregroundColor(vm.isTextFocused == 1 ? Color(red: 0.51, green: 0.74, blue: 0.79) : .gray)
            
            if vm.showError {
                Text("Date of birth must be earlier than today's date")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.red)
            }
            
            
            
            //------------------AGE SECTION-------------------//
            
            
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray, lineWidth: 1)
                .frame(height: 300)
                .overlay(
                    VStack{
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Age")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 24, weight: .bold))
                                
                                HStack {
                                    Text("\(vm.age[0])")
                                        .font(.system(size: 36, weight: .bold))
                                        .foregroundColor(Color(red: 0.51, green: 0.74, blue: 0.79))
                                    Text("Years")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(.gray)
                                }
                                HStack{
                                    Text("\(vm.age[1]) Months |")
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundColor(.gray)
                                    
                                    
                                    Text("\(vm.age[2]) Days")
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundColor(.gray)
                                    Spacer()
                                }
                            }
                            
                            Divider()
                            
                            //------------------BIRTHDAY SECTION-------------------//
                            
                            VStack(alignment: .center, spacing: 12) {
                                
                                Text("Next Birthday")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(Color(red: 0.51, green: 0.74, blue: 0.79))
                                Image(systemName: "birthday.cake")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(Color(red: 0.51, green: 0.74, blue: 0.79))
                                
                                if let nextBirthdayWeekday = vm.calculateNextBirthdayWeekday() {
                                    Text(nextBirthdayWeekday)
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundColor(.gray)
                                } else {
                                    Text("Error calculating weekday")
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundColor(.gray)
                                }
                                Text(vm.calculateRemainingTimeUntilNextBirthday())
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.gray)
                                
                                HStack {
                                    
                                    Spacer()
                                }
                            }
                            
                        }
                        .padding()
                        Divider()
                        
                        //------------------SUMMARY SECTION-------------------//
                        
                        HStack(spacing: 70) {
                            VStack(spacing: 80) {
                                VStack(spacing: 10) {
                                    Spacer()
                                    Text("Years")
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundColor(.gray)
                                    Text(vm.age[0])
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.gray)
                                    VStack {
                                        Text("Days")
                                            .font(.system(size: 11, weight: .bold))
                                            .foregroundColor(.gray)
                                        Text(vm.calculateTotalDays())
                                        
                                            .font(.system(size: 9, weight: .bold))
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            
                            VStack(spacing: 10) {
                                Text("Summary")
                                    .foregroundColor(Color(red: 0.51, green: 0.74, blue: 0.79))
                                    .font(.system(size: 14, weight: .bold))
                                Spacer()
                                Text("Months")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(.gray)
                                Text(vm.calculateTotalMonths())
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.gray)
                                VStack {
                                    Text("Hours")
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundColor(.gray)
                                    Text(vm.calculateTotalHours())
                                        .font(.system(size: 9, weight: .bold))
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            VStack(spacing: 10) {
                                Spacer()
                                Text("Weeks")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(.gray)
                                Text(vm.calculateTotalWeeks())
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.gray)
                                VStack {
                                    Text("Minutes")
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundColor(.gray)
                                    Text(vm.calculateTotalMinutes())
                                        .font(.system(size: 9, weight: .bold))
                                        .foregroundColor(.gray)
                                    
                                }
                            }
                        }
                        .padding(.vertical)
                    }
                )
            
            Button(action: {
                vm.calculateAge()
            }) {
                GenericButtonText(text: "Calculate age")
            }
            
            Spacer()
        }
    }
    
    
  
}


#Preview
{
    AgeConversionView()
}


struct DatePickerBottomSheetView: View {
    
    @Binding var birthdate: Date
    @Binding var isDatePickerPresented: Bool
    var onDoneTapped: () -> Void // Callback closure
       private var maximumDate: Date {
           return Date()
       }
    
    var body: some View {
        VStack {
            DatePicker("", selection: $birthdate, in: ...maximumDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .labelsHidden()
                .accentColor(Color(red: 0.51, green: 0.74, blue: 0.79))
                .padding()
                
            
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundColor(Color(red: 0.51, green: 0.74, blue: 0.79))
                        .padding(.horizontal)
                        .frame(height: 50)
                    
                    Text("Done")
                        .foregroundColor(.white)
                       
                }
                .onTapGesture {
                    isDatePickerPresented.toggle()
                    onDoneTapped()
                }
            }
            Spacer()
            
        }
    }
}






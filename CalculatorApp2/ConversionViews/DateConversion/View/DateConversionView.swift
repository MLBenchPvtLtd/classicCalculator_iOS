//
//  DateConversionView.swift
//  CalculatorApp2
//
//  Created by ML Bench  on 01/01/2024.
//
import SwiftUI

struct DateConversionView: View {
    
    
    private let calculations = ["Days", "Months", "Years"]
    @StateObject private var vm = DateVM()
    
    var body: some View {
        VStack {
            loadView()
            Spacer()
        }
        .padding()
        .navigationBarTitle("Date")
        .onChange(of: vm.endDate) { _ in
            vm.calculateDateDifference()
        }
        .onChange(of: vm.startDate) { _ in
            vm.calculateDateDifference()
        }
        
        
    }
    
    func loadView() -> some View {
        VStack(alignment: .center, spacing: 20) {
            HStack {
                Text("From:")
                    .font(.system(size: 18, weight: .medium))
                Spacer()
                
                Button(action: {
                    vm.isStartDatePickerPresented.toggle()
                    vm.isTextFocused = 0
                }) {
                    HStack{
                        Text(vm.dateFormatter.string(from: vm.startDate))
                        Image(systemName: "arrowtriangle.down.fill")
                            .resizable()
                            .frame(width: 9, height: 6)
                    }
                }
                .sheet(isPresented: $vm.isStartDatePickerPresented) {
                    DatePickerBottomSheetView2(birthdate: $vm.startDate, isDatePickerPresented:$vm.isStartDatePickerPresented)
                        .presentationDetents([.height(450)])
                }
            }
            .foregroundColor(vm.isTextFocused == 0 ? Color(red: 0.51, green: 0.74, blue: 0.79) : .gray)
            
            
            HStack {
                Text("To:")
                    .font(.system(size: 18, weight: .medium))
                Spacer()
                
                
                Button(action: {
                    vm.isEndDatePickerPresented.toggle()
                    vm.isTextFocused = 1
                }) {
                    HStack{
                        Text(vm.dateFormatter.string(from: vm.endDate))
                        Image(systemName: "arrowtriangle.down.fill")
                            .resizable()
                            .foregroundStyle(.gray)
                            .frame(width: 9, height: 6)
                    }
                }
                .sheet(isPresented: $vm.isEndDatePickerPresented) {
                    DatePickerBottomSheetView2(birthdate: $vm.endDate, isDatePickerPresented:$vm.isEndDatePickerPresented)
                        .presentationDetents([.height(450)])
                }
            }
            .foregroundColor(vm.isTextFocused == 1 ? Color(red: 0.51, green: 0.74, blue: 0.79) : .gray)
            
            //------------------------------------------------------------//
            
            ZStack{
                RoundedRectangle(cornerRadius: 5) // Adjust the corner radius as needed
                    .foregroundColor(Color.gray.opacity(0.2))
                    .frame(height: 300)
                VStack(spacing: 30){
                    
                    Text("Difference")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(Color(red: 0.51, green: 0.74, blue: 0.79))
                    
                    VStack{
                        Rectangle()
                            .foregroundColor(Color.gray.opacity(0.5))
                            .frame(height: 1)
                        HStack(spacing: 60) {
                            
                            VStack {
                                Text("\(vm.daysResult)")
                                Rectangle()
                                    .foregroundColor(Color.gray.opacity(0.5))
                                    .frame(width: 55, height: 1)
                                Text("Days")
                            }
                            VStack {
                                Text("\(vm.monthsResult)")
                                Rectangle()
                                    .foregroundColor(Color.gray.opacity(0.5))
                                    .frame(width: 55, height: 1)
                                Text("Months")
                            }
                            VStack {
                                Text("\(vm.yearsResult)")
                                Rectangle()
                                    .foregroundColor(Color.gray.opacity(0.5))
                                    .frame(width: 55, height: 1)
                                Text("Years")
                            }
                        }
                        Rectangle()
                            .foregroundColor(Color.gray.opacity(0.5))
                            .frame(height: 1)
                    }
                    
                    HStack(spacing: 70){
                        VStack {
                            Text("From")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Color(red: 0.51, green: 0.74, blue: 0.79))
                            Text(vm.dateFormatter.string(from: vm.startDate))
                        }
                        
                        VStack {
                            Text("To")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Color(red: 0.51, green: 0.74, blue: 0.79))
                            Text(vm.dateFormatter.string(from: vm.endDate))
                        }
                        
                    }
                }
            }
            .padding()
        }
        
    }
    
 
    
}

#Preview
{
    DateConversionView()
}



struct DatePickerBottomSheetView2: View {
    @Binding var birthdate: Date
    @Binding var isDatePickerPresented: Bool
    
    var body: some View {
        VStack {
            DatePicker("", selection: $birthdate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .labelsHidden()
                .accentColor(Color(red: 0.51, green: 0.74, blue: 0.79))
            
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
                }
            }
            Spacer()
            
        }
    }
}

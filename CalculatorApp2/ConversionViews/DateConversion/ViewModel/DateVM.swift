//
//  DateVM.swift
//  CalculatorApp2
//
//  Created by ML Bench  on 01/02/2024.
//

import Foundation

class DateVM: ObservableObject{
    
    
    @Published var selectedCalculation = 0
    @Published var isStartDatePickerPresented = false
    @Published var isEndDatePickerPresented = false
    @Published var isTextFocused = 0
    
    @Published var yearsResult = "0"
    @Published var monthsResult = "0"
    @Published var daysResult = "0"
    @Published var startDate = Date()
    @Published var endDate = Date()
    
}

extension DateVM{
    
     func calculateDateDifference() {
        let calendar = Calendar.current
        
        // Set the time to midnight for both dates
        let startDateStartOfDay = calendar.startOfDay(for: startDate)
        let endDateStartOfDay = calendar.startOfDay(for: endDate)
        
        let components = calendar.dateComponents([.year, .month, .day], from: startDateStartOfDay, to: endDateStartOfDay)
        
        if let years = components.year, let months = components.month, let days = components.day {
            yearsResult = "\(abs(years))"
            monthsResult = "\(abs(months))"
            daysResult = "\(abs(days))"
        }
    }
    
     var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
}



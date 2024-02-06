//
//  AgeVM.swift
//  CalculatorApp2
//
//  Created by ML Bench  on 01/02/2024.
//

import Foundation

class AgeVM: ObservableObject{
    
    @Published  var startDateDOB = Date()
    @Published  var endDateCD = Date()
    @Published  var age: [String] = ["","",""]
    @Published  var isDatePickerPresentedDOB = false
    @Published  var isDatePickerPresentedCD = false
    @Published  var isTextFocused = 0
    @Published  var showError = false
    
    @Published  var yearsResult = "0"
    @Published  var monthsResult = "0"
    @Published  var daysResult = "0"
    
}

extension AgeVM{
    
     func calculateAge() {
        let calendar = Calendar.current
        
        
        if startDateDOB > endDateCD {
            showError = true
            
            // Hide the error message after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.showError = false
            }
            
            return
        }
        
        let components = calendar.dateComponents([.year, .month, .day], from: startDateDOB, to: endDateCD)
        
        if let years = components.year, let months = components.month, let days = components.day {
            
            let year = "\(years)"
            let months = "\(months)"
            let days = "\(days)"
            
            age[0] = (year)
            age[1] = (months)
            age[2] = (days)
            
        }
    }
    
     func calculateTotalMonths() -> String {
        let calendar = Calendar.current
        
        if startDateDOB > endDateCD {
            return "0"
        }
        
        let components = calendar.dateComponents([.month], from: startDateDOB, to: endDateCD)
        
        if let totalMonths = components.month {
            return "\(totalMonths)"
        }
        
        return "Error calculating total months"
    }

     func calculateTotalWeeks() -> String {
        let calendar = Calendar.current
        
        if startDateDOB > endDateCD {
            return "0"
        }
        
        let components = calendar.dateComponents([.weekOfMonth], from: startDateDOB, to: endDateCD)
        
        if let totalWeeks = components.weekOfMonth {
            return "\(totalWeeks)"
        }
        
        return "Error calculating total weeks"
    }

     func calculateTotalDays() -> String {
        let calendar = Calendar.current
        
        if startDateDOB > endDateCD {
            return "0"
        }
        
        let components = calendar.dateComponents([.day], from: startDateDOB, to: endDateCD)
        
        if let totalDays = components.day {
            return "\(totalDays)"
        }
        
        return "Error calculating total days"
    }

     func calculateTotalHours() -> String {
        let calendar = Calendar.current
        
        if startDateDOB > endDateCD {
            return "0"
        }
        
        let components = calendar.dateComponents([.hour], from: startDateDOB, to: endDateCD)
        
        if let totalHours = components.hour {
            return "\(totalHours)"
        }
        
        return "Error calculating total hours"
    }

     func calculateTotalMinutes() -> String {
        let calendar = Calendar.current
        
        if startDateDOB > endDateCD {
            return "0"
        }
        
        let components = calendar.dateComponents([.minute], from: startDateDOB, to: endDateCD)
        
        if let totalMinutes = components.minute {
            return "\(totalMinutes)"
        }
        
        return "Error calculating total minutes"
    }

     func calculateRemainingTimeUntilNextBirthday() -> String {
        let calendar = Calendar.current
        
        // Adjust the selected date to the current year
        var nextBirthdayComponents = calendar.dateComponents([.month, .day], from: startDateDOB)
        let currentYear = calendar.component(.year, from: endDateCD)
        nextBirthdayComponents.year = currentYear
        
        // Calculate the time difference between the adjusted next birthday and the current date
        if let nextBirthdayDate = calendar.date(from: nextBirthdayComponents) {
            if nextBirthdayDate < endDateCD {
                // If the next birthday is in the past, adjust to the next year
                nextBirthdayComponents.year = currentYear + 1
                if let adjustedNextBirthdayDate = calendar.date(from: nextBirthdayComponents) {
                    let components = calendar.dateComponents([.month, .day], from: endDateCD, to: adjustedNextBirthdayDate)
                    
                    if let remainingMonths = components.month, let remainingDays = components.day {
                        let remainingTimeString = String(format: "%01d months, %01d days", remainingMonths, remainingDays)
                        return "\(remainingTimeString)"
                    }
                }
            } else {
                let components = calendar.dateComponents([.month, .day], from: endDateCD, to: nextBirthdayDate)
                
                if let remainingMonths = components.month, let remainingDays = components.day {
                    let remainingTimeString = String(format: "%01d months, %01d days", remainingMonths, remainingDays)
                    return "\(remainingTimeString)"
                }
            }
        }
        
        return "Error calculating remaining time"
    }
    
     func calculateNextBirthdayWeekday() -> String? {
        let calendar = Calendar.current
        
        // Adjust the selected date to the current year
        var nextBirthdayComponents = calendar.dateComponents([.month, .day], from: startDateDOB)
        let currentYear = calendar.component(.year, from: endDateCD)
        nextBirthdayComponents.year = currentYear
        
        // Calculate the time difference between the adjusted next birthday and the current date
        if let nextBirthdayDate = calendar.date(from: nextBirthdayComponents) {
            let nextBirthdayWeekday = calendar.component(.weekday, from: nextBirthdayDate)
            return calendar.weekdaySymbols[nextBirthdayWeekday - 1]
        }
        
        return nil
    }
    
     var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }
    
}

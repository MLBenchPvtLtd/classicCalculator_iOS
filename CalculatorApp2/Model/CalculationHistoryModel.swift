//
//  CalculationHistoryModel.swift
//  CalculatorApp2
//
//  Created by Usama Nayyer on 06/06/1445 AH.
//

//import Foundation
//
//class CalculationHistoryModel: ObservableObject {
//    @Published var history: [CalculationRecord] = []
//}
//
//struct CalculationRecord: Identifiable {
//    let id = UUID()
//    let userInput: String
//    let result: String
//    let timestamp: Date
//}
import Foundation

class CalculationHistoryModel: ObservableObject {
    @Published var history: [(calculation: String, timestamp: Date)] = []

    func addCalculation(_ calculation: String) {
        let timestamp = Date()
        history.append((calculation, timestamp))
    }

    func clearHistory() {
        history.removeAll()
    }
}

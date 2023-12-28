//
//  CalculationHistory.swift
//  CalculatorApp2
//
//  Created by Usama Nayyer on 06/06/1445 AH.
//

import SwiftUI

struct CalculationHistory: View {
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    @Binding var history: [(calculation: String, timestamp: Date)]
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        loadView()
            .navigationBarTitle("Calculation History", displayMode: .inline)
            .onAppear {
                loadHistoryFromUserDefaults()
            }
    }
}

extension CalculationHistory {
    
    func loadView() -> some View {
        if history.isEmpty {
            return AnyView(
                Text("No history")
                    .foregroundColor(.gray)
                    .font(.title)
                    .padding()
            )
        } else {
            return AnyView(
                List {
                    ForEach(history, id: \.timestamp) { entry in
                        VStack(alignment: .leading) {
                            Text(entry.calculation)
                            Text("Performed on: \(entry.timestamp, formatter: dateFormatter)")
                                .foregroundColor(.gray)
                                .font(.footnote)
                        }
                    }
                    .onDelete(perform: deleteHistoryEntry)
                }
            )
        }
    }
    
    func deleteHistoryEntry(at offsets: IndexSet) {
        history.remove(atOffsets: offsets)
        // saveHistory()
    }
    func loadHistoryFromUserDefaults() {
        let loadedHistory = UserDefaults.standard.data(forKey: "calculationHistory")
        if let decodedHistory = try? JSONDecoder().decode([HistoryEntry].self, from: loadedHistory ?? Data()) {
            history = decodedHistory.map { ($0.calculation, $0.timestamp) }
        }
    }
    
    
}

struct HistoryEntry: Codable {
    let calculation: String
    let timestamp: Date
}

struct CalculationHistory_Previews: PreviewProvider {
    static var previews: some View {
        // Load history from UserDefaults or use an empty array if not found
        let loadedHistory = UserDefaults.standard.data(forKey: "calculationHistory")
        let sampleHistory: [(calculation: String, timestamp: Date)] = {
            if let decodedHistory = try? JSONDecoder().decode([HistoryEntry].self, from: loadedHistory ?? Data()) {
                return decodedHistory.map { ($0.calculation, $0.timestamp) }
            } else {
                return []
            }
        }()
        
        return CalculationHistory(history: .constant(sampleHistory))
    }
}

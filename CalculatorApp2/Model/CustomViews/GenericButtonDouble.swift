//
//  GenericButtonDouble.swift
//  CalculatorApp2
//
//  Created by ML Bench  on 02/01/2024.
//

import SwiftUI


struct GenericButtonDouble: View {
    var value: Double
    var unit: String
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(.blue)
                .frame(height: 50)
            
            Text("Converted Value: \(String(format: "%.2f", value)) \(unit)")
                .foregroundColor(.white)
        }
    }
}

#Preview {
    GenericButtonDouble(value: 0, unit: "")
}

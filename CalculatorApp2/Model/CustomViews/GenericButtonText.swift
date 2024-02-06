//
//  GenericButton.swift
//  CalculatorApp2
//
//  Created by ML Bench  on 02/01/2024.
//

import SwiftUI

struct GenericButtonText: View {
    
    var text: String
    
    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(Color(red: 0.51, green: 0.74, blue: 0.79))
                .frame(height: 50)
            
            Text(text)
                .foregroundColor(.white)
        }
    }
}

#Preview {
    GenericButtonText(text: "")
}


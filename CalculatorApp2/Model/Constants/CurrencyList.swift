//
//  CurrencyList.swift
//  CalculatorApp2
//
//  Created by ML Bench  on 01/01/2024.
//

import Foundation

struct Currency {
    var code: String
    var name: String
}

let currencies: [Currency] = [
    Currency(code: "USD", name: "United States Dollar"),
    Currency(code: "EUR", name: "Euro"),
    // Add more currencies as needed
]

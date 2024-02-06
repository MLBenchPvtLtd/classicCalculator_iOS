//
//  ContentView.swift
//  CalculatorApp2
//
//  Created by Usama Nayyer on 29/05/1445 AH.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        VStack{
            loadView()
        }
    }
}

extension ContentView{
    
    func loadView() -> some View{
        
        TabView {
            BasicCalcView()
                .tabItem {
                    Label("Basic", systemImage: "plus.forwardslash.minus")
                }
            ConversionView()
                .tabItem {
                    Label("Conversion", systemImage: "arrow.triangle.swap")
                }
        }
        .accentColor(Color(red: 0.51, green: 0.74, blue: 0.79))
    }
}

#Preview
{
    ContentView()
}


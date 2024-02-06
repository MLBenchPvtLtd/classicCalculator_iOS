//
//  ConversionView.swift
//  CalculatorApp2
//
//  Created by ML Bench  on 01/01/2024.
//

import SwiftUI

struct ConversionView: View {
    var body: some View {
        
        VStack{
            loadView()
        }
    }
}


extension ConversionView{
    
    func loadView() -> some View{
        VStack(spacing: 50){
            
            Text("Measurements")
                .foregroundColor(Color(red: 0.51, green: 0.74, blue: 0.79))
                .font(.custom(CustomFonts.euro.rawValue, size: 25))
                .kerning(2)
                .padding()
            
            HStack(spacing: 80) {
                
                VStack(spacing: 60){
                    
                    NavigationLink(destination: AgeConversionView()) {
                        CalculationBox(title: "Age", imageName: "birthday.cake")
                    }
                    
                    NavigationLink(destination: CurrencyConversionView()) {
                        CalculationBox(title: "Currency", imageName: "arrow.left.arrow.right")
                    }
                    
                    NavigationLink(destination: DiscountConversionView()) {
                        CalculationBox(title: "Discount", imageName: "tag")
                    }
                    
                    NavigationLink(destination: NumericConversionView()) {
                        CalculationBox(title: "Numeral", imageName: "numbersign")
                    }
                    
                    NavigationLink(destination: TimeConversionView()) {
                        CalculationBox(title: "Time", imageName: "clock")
                    }
                    
                    
                    Spacer()
                }
                VStack(spacing: 60){
                    
                    NavigationLink(destination: AreaConversionView()) {
                        CalculationBox(title: "Area", imageName: "arrow.up.right.and.arrow.down.left.rectangle")
                    }
                    
                    NavigationLink(destination: DataConversionView()) {
                        CalculationBox(title: "Data", imageName: "square.and.pencil")
                    }
                    
                    NavigationLink(destination: LengthConversionView()) {
                        CalculationBox(title: "Length", imageName: "figure.dress.line.vertical.figure")
                    }
                    
                    
                    NavigationLink(destination: SpeedConversionView()) {
                        CalculationBox(title: "Speed", imageName: "figure.disc.sports")
                    }
                    
                    
                    NavigationLink(destination: VolumeConversionView()) {
                        CalculationBox(title: "Volume", imageName: "shippingbox")
                    }
                    
                    Spacer()
                }
                VStack(spacing: 60){
                    
                    NavigationLink(destination: BMIConversionView()) {
                        CalculationBox(title: "BMI", imageName: "heart")
                    }
                    
                    NavigationLink(destination: DateConversionView()) {
                        CalculationBox(title: "Date", imageName: "calendar")
                    }
                    
                    NavigationLink(destination: MassConversionView()) {
                        CalculationBox(title: "Mass", imageName: "person")
                    }
                    
                    
                    NavigationLink(destination: TempConversionView()) {
                        CalculationBox(title: "Temprature", imageName: "thermometer.variable.and.figure")
                    }
                    
                    
                    Spacer()
                }
                
            }
            
        }
    }
    
    struct CalculationBox: View {
        var title: String
        var imageName: String
        
        var body: some View {
            VStack {
                Image(systemName: imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 26, height: 26)
                    .foregroundColor(.gray)
                
                Text(title)
                    .font(.custom(CustomFonts.euro.rawValue, size: 12))
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
            }
        }
    }
}

#Preview {
    ConversionView()
}




//  CurrencyConverterViewModel.swift
//  CalculatorApp2
//
//  Created by ML Bench  on 17/01/2024.
//


import Foundation
import Alamofire

struct CurrencyModal: Codable {
    let result: String
    let documentation,
        termsOfUse: String
    let timeLastUpdateUnix: Int
    let timeLastUpdateUTC: String
    let timeNextUpdateUnix: Int
    let timeNextUpdateUTC,
        baseCode: String
    let conversionRates: [String: Double]

    enum CodingKeys: String, CodingKey {
        case result, documentation
        case termsOfUse = "terms_of_use"
        case timeLastUpdateUnix = "time_last_update_unix"
        case timeLastUpdateUTC = "time_last_update_utc"
        case timeNextUpdateUnix = "time_next_update_unix"
        case timeNextUpdateUTC = "time_next_update_utc"
        case baseCode = "base_code"
        case conversionRates = "conversion_rates"
    }
}
extension CurrencyModal{
    init(){
        self.result = ""
        self.documentation = ""
        self.termsOfUse = ""
        self.timeLastUpdateUnix = 0
        self.timeLastUpdateUTC = ""
        self.timeNextUpdateUnix = 0
        self.timeNextUpdateUTC = ""
        self.baseCode = ""
        self.conversionRates = ["":0.0]
    }
}
   
class CurrencyVM : ObservableObject{
    @Published var currency = CurrencyModal()
    // Mapping between currency codes and country names
    let currencyNameMap: [String: String] = [
        "AZN": "Azerbaijani Manat",
        "NAD": "Namibian Dollar",
        "IQD": "Iraqi Dinar",
        "KWD": "Kuwaiti Dinar",
        "SEK": "Swedish Krona",
        "XCD": "East Caribbean Dollar",
        "BSD": "Bahamian Dollar",
        "TRY": "Turkish Lira",
        "BRL": "Brazilian Real",
        "MUR": "Mauritian Rupee",
        "GEL": "Georgian Lari",
        "NIO": "Nicaraguan Córdoba",
        "GBP": "British Pound Sterling",
        "MRU": "Mauritanian Ouguiya",
        "PHP": "Philippine Peso",
        "FKP": "Falkland Islands Pound",
        "TND": "Tunisian Dinar",
        "BOB": "Bolivian Boliviano",
        "PLN": "Polish Złoty",
        "DOP": "Dominican Peso",
        "UGX": "Ugandan Shilling",
        "MWK": "Malawian Kwacha",
        "ALL": "Albanian Lek",
        "DZD": "Algerian Dinar",
        "TJS": "Tajikistani Somoni",
        "JOD": "Jordanian Dinar",
        "SDG": "Sudanese Pound",
        "BZD": "Belize Dollar",
        "DJF": "Djiboutian Franc",
        "ANG": "Netherlands Antillean Guilder",
        "XAF": "Central African CFA Franc",
        "SBD": "Solomon Islands Dollar",
        "STN": "São Tomé and Príncipe Dobra",
        "FOK": "Faroese Króna",
        "DKK": "Danish Krone",
        "BGN": "Bulgarian Lev",
        "MGA": "Malagasy Ariary",
        "PYG": "Paraguayan Guarani",
        "LYD": "Libyan Dinar",
        "RON": "Romanian Leu",
        "AFN": "Afghan Afghani",
        "TVD": "Tuvaluan Dollar",
        "LKR": "Sri Lankan Rupee",
        "SZL": "Swazi Lilangeni",
        "BTN": "Bhutanese Ngultrum",
        "GMD": "Gambian Dalasi",
        "AMD": "Armenian Dram",
        "ZWL": "Zimbabwean Dollar",
        "FJD": "Fijian Dollar",
        "SLL": "Sierra Leonean Leone",
        "BND": "Brunei Dollar",
        "RSD": "Serbian Dinar",
        "BHD": "Bahraini Dinar",
        "LBP": "Lebanese Pound",
        "SOS": "Somali Shilling",
        "CZK": "Czech Republic Koruna",
        "BBD": "Barbadian Dollar",
        "NOK": "Norwegian Krone",
        "MZN": "Mozambican Metical",
        "ETB": "Ethiopian Birr",
        "PGK": "Papua New Guinean Kina",
        "IMP": "Isle of Man Pound",
        "GNF": "Guinean Franc",
        "UYU": "Uruguayan Peso",
        "MKD": "Macedonian Denar",
        "USD": "United States Dollar",
        "KHR": "Cambodian Riel",
        "THB": "Thai Baht",
        "JEP": "Jersey Pound",
        "CNY": "Chinese Yuan",
        "GHS": "Ghanaian Cedi",
        "XPF": "CFP Franc",
        "ARS": "Argentine Peso",
        "PAB": "Panamanian Balboa",
        "BWP": "Botswana Pula",
        "CHF": "Swiss Franc",
        "JMD": "Jamaican Dollar",
        "TMT": "Turkmenistani Manat",
        "IRR": "Iranian Rial",
        "LAK": "Laotian Kip",
        "XOF": "West African CFA Franc",
        "BAM": "Bosnia-Herzegovina Convertible Mark",
        "KID": "Kiribati Dollar",
        "UZS": "Uzbekistani Som",
        "AED": "United Arab Emirates Dirham",
        "TTD": "Trinidad and Tobago Dollar",
        "LSL": "Lesotho Loti",
        "HRK": "Croatian Kuna",
        "BYN": "Belarusian Ruble",
        "UAH": "Ukrainian Hryvnia",
        "SYP": "Syrian Pound",
        "ZAR": "South African Rand",
        "SHP": "Saint Helena Pound",
        "MYR": "Malaysian Ringgit",
        "EGP": "Egyptian Pound",
        "ZMW": "Zambian Kwacha",
        "WST": "Samoan Tala",
        "GTQ": "Guatemalan Quetzal",
        "ILS": "Israeli New Shekel",
        "PEN": "Peruvian Nuevo Sol",
        "BMD": "Bermudian Dollar",
        "YER": "Yemeni Rial",
        "VES": "Venezuelan Bolívar",
        "NPR": "Nepalese Rupee",
        "AUD": "Australian Dollar",
        "XDR": "Special Drawing Rights",
        "RWF": "Rwandan Franc",
        "VND": "Vietnamese Đồng",
        "GYD": "Guyanese Dollar",
        "MMK": "Burmese Kyat",
        "BDT": "Bangladeshi Taka",
        "AOA": "Angolan Kwanza",
        "BIF": "Burundian Franc",
        "AWG": "Aruban Florin",
        "CLP": "Chilean Peso",
        "COP": "Colombian Peso",
        "KRW": "South Korean Won",
        "SGD": "Singapore Dollar",
        "CAD": "Canadian Dollar",
        "MXN": "Mexican Peso",
        "HTG": "Haitian Gourde",
        "OMR": "Omani Rial",
        "SAR": "Saudi Riyal",
        "TZS": "Tanzanian Shilling",
        "SRD": "Surinamese Dollar",
        "TOP": "Tongan Paʻanga",
        "IDR": "Indonesian Rupiah",
        "LRD": "Liberian Dollar",
        "NZD": "New Zealand Dollar",
        "SLE": "Sierra Leonean Leone",
        "QAR": "Qatari Riyal",
        "INR": "Indian Rupee",
        "NGN": "Nigerian Naira",
        "KGS": "Kyrgyzstani Som",
        "VUV": "Vanuatu Vatu",
        "KZT": "Kazakhstani Tenge",
        "JPY": "Japanese Yen",
        "GIP": "Gibraltar Pound",
        "EUR": "Euro",
        "MVR": "Maldivian Rufiyaa",
        "ISK": "Icelandic Króna",
        "MNT": "Mongolian Tugrik",
        "CDF": "Congolese Franc",
        "SCR": "Seychellois Rupee",
        "TWD": "New Taiwan Dollar",
        "CUP": "Cuban Peso",
        "MOP": "Macanese Pataca",
        "MAD": "Moroccan Dirham",
        "KES": "Kenyan Shilling",
        "HKD": "Hong Kong Dollar",
        "KMF": "Comorian Franc",
        "HNL": "Honduran Lempira",
        "GGP": "Guernsey Pound",
        "PKR": "Pakistani Rupee",
        "KYD": "Cayman Islands Dollar",
        "CRC": "Costa Rican Colón",
        "HUF": "Hungarian Forint",
        "MDL": "Moldovan Leu",
        "RUB": "Russian Ruble",
        "ERN": "Eritrean Nakfa",
        "SSP": "South Sudanese Pound",
        "CVE": "Cape Verdean Escudo",
    ]

}


extension CurrencyVM

{
    func currencyName(for code: String) -> String {
           return currencyNameMap[code] ?? "Unknown Country"
       }
    func apiRequest(url: String) {
        Session.default.request(url).responseDecodable(of: CurrencyModal.self) { response in
            switch response.result {
            case .success(let currencies):
                print(currencies)
                self.currency = currencies
            case .failure(let error):
                print(error)
            }
        }
    }
}


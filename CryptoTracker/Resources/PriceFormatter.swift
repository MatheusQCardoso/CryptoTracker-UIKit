//
//  PriceFormatter.swift
//  CryptoTracker
//
//  Created by Matheus Quirino on 09/01/22.
//

import Foundation

final class PriceFormatter{
    static let shared = PriceFormatter()
    
    private let numberFormatter = NumberFormatter()
    
    private init(){
        numberFormatter.locale = .current
        numberFormatter.allowsFloats = true
        numberFormatter.numberStyle = .currency
        numberFormatter.currencySymbol = "USD"
        numberFormatter.formatterBehavior = .default
    }
    
    public func format(from price: Double) -> String? {
        return numberFormatter.string(from: NSNumber(floatLiteral: price))
    }
}

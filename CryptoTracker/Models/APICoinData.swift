//
//  CoinAPIResponse.swift
//  CryptoTracker
//
//  Created by Matheus Quirino on 09/01/22.
//

import Foundation

struct APICoinData: Codable{
    let asset_id: String
    let name: String?
    let price_usd: Double?
    let id_icon: String?
    let type_is_crypto: Int
}

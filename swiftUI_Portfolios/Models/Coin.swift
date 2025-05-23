//
//  Coin.swift
//  Portfolio_SwiftUI
//
//  Created by Javier FO on 4/15/25.
//

import Foundation

struct Coin: Codable, Identifiable {
    let id: String
    let symbol: String
    let name: String
    let image: String
    let currentPrice: Double
    let marketCapRank: Int
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCapRank = "market_cap_rank"
    }
}

//
//  CoinDataService.swift
//  Portfolio_SwiftUI
//
//  Created by Javier FO on 4/15/25.
//

import Foundation

class CoinDataService {
    
    private let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=20&page=1&sparkline=false&price_change_percentage=24h&locale=en"
    
    func fetchCoins() async throws -> [Coin] {
        guard let url = URL(string: urlString) else { return [] }
        
        do {
            //suspension point in the code
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let coins = try JSONDecoder().decode([Coin].self, from: data)
            
            return coins
            
        } catch {
            
            print("DEBUG: Error \(error.localizedDescription)")
            return []
        }
        
    }
    

}

extension CoinDataService {
    func fetchCoinsWithResult(completion: @escaping(Result<[Coin], CoinAPIError>) -> Void){
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.unknownError(error: error)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.requestFailed(description: "request failed")))
                return
            }

            guard httpResponse.statusCode == 200 else {
                completion(.failure(.invalidStatusCode(statusCode: httpResponse.statusCode)))
                return
            }

            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }

            do {
                let coins = try JSONDecoder().decode([Coin].self, from: data)
                completion(.success(coins))
            } catch {
                completion(.failure(.jsonParsingFailure))
            }

        }.resume()
    }

    func fetchPrice(coin: String, completion: @escaping (Double) -> Void) {

        let urlString = "https://api.coingecko.com/api/v3/simple/price?ids=\(coin)&vs_currencies=usd"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in

            if let error = error {
                print("Debug: \(error.localizedDescription)")
                //self.errorMessage = error.localizedDescription
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                //self.errorMessage = "Bad response"
                return
            }

            guard httpResponse.statusCode == 200 else {
                //self.errorMessage = "Failed status code \(httpResponse.statusCode)"
                return
            }

            print("Did receive data \(String(describing: data))")
            guard let data = data else { return }
            guard let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
            guard let value = jsonObject[coin] as? [String : Double] else { return }
            guard let price = value["usd"] else { return }

                //self.coin = coin.capitalized
                //self.price = "\(price)"
                completion(price)


        }.resume()
    }
}



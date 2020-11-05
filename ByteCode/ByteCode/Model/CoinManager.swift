//
//  CoinModel.swift
//  ByteCode
//
//  Created by ibg training 5 on 11/3/20.
//  Copyright © 2020 ibg training 5. All rights reserved.
//

import Foundation


protocol CoinManagerDelegate {
    
    func didUpdateWithPrice(price: String, currency: String)
}
    

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "YOUR_API_KEY"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    
    func getCoinPrice(for currency: String) {
        
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        // 1. Create a Url
        if let url = URL(string: urlString) {
            
            // 2. Create a URLSession
            let session = URLSession(configuration: .default)
            
            // 3. Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    return
                }
                
                if let safeData = data {
                    if let bitcoinPrice = self.parseJSON(safeData) {
                        
                        let priceString = String(format: "%.2f", bitcoinPrice)
                        self.delegate?.didUpdateWithPrice(price: priceString, currency: currency)
                    }
                    
                }
            }
            
            // 4. Start the task
            task.resume()
        }
        
    }
    
    func parseJSON(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.rate
            
            print(lastPrice)
            return lastPrice
            
        } catch {
            print(error)
            return nil
        }
        
    }
    
}

//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func managerDidUpdateRate(_ coinManager: CoinManager, with rate: Double)
    func managerDidFailWithError(_ error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "0972A140-60E8-4A97-A317-1301C3C1A2AF"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD", "UAH","USD","ZAR"]

    func getCoinPrice(for currency: String) {
        let requestString = "\(baseURL)/\(currency)"
        performRequest(urlString: requestString)
    }
    
    func performRequest(urlString: String) {
        // performs a request for
        print("Performing request with \(urlString)...")
        if let url = URL(string: urlString) {
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("\(apiKey)", forHTTPHeaderField:"X-CoinAPI-Key")
            request.timeoutInterval = 60.0
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    delegate?.managerDidFailWithError(error!)
                    return
                }
                if let safeData = data {
                    if let rate = self.getRateFromJSON(safeData) {
                        self.delegate?.managerDidUpdateRate(self, with: rate)
                        print("Updated rate")
                    }
                }
            }
            task.resume()
        }
        
    }
    
    func getRateFromJSON(_ jsonData: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: jsonData)
            let rate = decodedData.rate
            print(rate)
            return rate
        } catch {
            delegate?.managerDidFailWithError(error)
            return nil
        }
    }
}

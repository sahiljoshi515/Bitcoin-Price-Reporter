import Foundation

protocol CoinManagerDelegate {
    
    func didUpdatePrice(price: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "YOUR KEY"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    
    func getCoinPrice(for currency: String) {
        let url = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        if let urlString = URL(string: url) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: urlString) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    
                    if let bitcoin = self.parseJSON(coinData: safeData) {
                        let priceString = String(format: "%.2f", bitcoin)
                        self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                    }
                
                }
            }
            task.resume()
        }
    }
    
    
    func parseJSON(coinData: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
           let decodedData = try decoder.decode(CoinData.self, from: coinData)
            print(decodedData.rate)
            return decodedData.rate
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
    
  
    
    
}
        

    

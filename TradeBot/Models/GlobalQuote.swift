import Foundation
import RealmSwift
import SwiftUI
import Realm

/* This url https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=GOOG&apikey=43G7PFJZE4GBS714 */

//MARK: Entity
class GlobalQuote:  Object, Codable, ObjectKeyIdentifiable, Identifiable {
    //@Persisted objects are one-way bindings.
    //@Published combine object
    //@State is local @Binding will bind to Published or Persisted and dynamic
    @objc dynamic var symbol: String
    @objc dynamic var open: String
    @objc dynamic var high: String
    @objc dynamic var low: String
    @objc dynamic var price: String
    @objc dynamic var volume: String
    @objc dynamic var latest_trading_day: String
    @objc dynamic var previous_close: String
    @objc dynamic var change: String
    @objc dynamic var change_percent: String
    
    enum CodingKeys: String, CodingKey {
         case symbol = "01. symbol"
         case open = "02. open"
        case high = "03. high"
        case low = "04. low"
        case price = "05. price"
        case volume = "06. volume"
        case latest_trading_day = "07. latest trading day"
        case previous_close = "08. previous close"
        case change = "09. change"
        case change_percent = "10. change percent"
     }
  
}

protocol GlobalQuoteProtocol {
    func getSymbol(forSymbol: String?) -> [GlobalQuote]
}

// MARK: Data Feeds
struct GlobalQuoteResponse: Decodable {
    var globalQuote: GlobalQuote
    enum CodingKeys: String, CodingKey {
        case globalQuote = "Global Quote"
    }
}

// MARK: Interactor
class QuoteInteractor : ObservableObject {
     var quotes = [GlobalQuote]()
    @Published var quote: GlobalQuote = GlobalQuote.init()
    @Published var symbol: String
    var realm: QuoteRealm = QuoteRealm.init()
    init (symbol: String) {
        self.symbol = symbol
        self.addBindings(symbol: symbol)
        
    }
    func addBindings(symbol: String) {
        self.quotes = realm.getSymbol(forSymbol: symbol)
        quotes = realm.getSymbol(forSymbol: symbol)
        quote = realm.getQuote(forSymbol: symbol)
    }
    
    func refresh(symbol: String) -> () {
        quotes = realm.getSymbol(forSymbol: symbol)
        quote = realm.getQuote(forSymbol: symbol)
    }
    func getAll()  {
        quotes = realm.getSymbols()
    }
    
    func load(symbol: String) {
        Task {
      
                    guard
                    let updatedQuote: GlobalQuote = try? await realm.fetch(forSymbol: symbol) else { return }
                    self.refresh(symbol: updatedQuote.symbol)
                   self.addBindings(symbol: updatedQuote.symbol)
              
             }
    }
 
    func update(symbol: String) async throws -> GlobalQuote{
    guard
        let updatedQuote: GlobalQuote = try? await realm.fetch(forSymbol: symbol) else {
            return self.quote
        }
        self.addBindings(symbol: symbol)
        var globalQuoteInteractor = QuoteInteractor.init(symbol: "GOOG")
        let realm = try! await Realm()
        try! realm.write {
            realm.add(updatedQuote)
        }
        return updatedQuote
    }
}

enum DownloadError : Error{
   case statusNotOk, decoderError
}

struct QuoteRealm: GlobalQuoteProtocol {
    var token: NotificationToken?
    
    init( ) {
    }
    //MARK: Realm Functions
    func getSymbol(forSymbol: String?) -> [GlobalQuote] {
        let realm = try! Realm()
        return realm.objects(GlobalQuote.self).map{$0}.filter{ quote in
            return quote.symbol == forSymbol
        }.reversed()
    }
    func getSymbols() -> [GlobalQuote] {
        let realm = try! Realm()
        return realm.objects(GlobalQuote.self).distinct(by: ["symbol"]).map{$0}.reversed()
    }
  
    func getQuote(forSymbol: String) -> GlobalQuote {
        let realm = try! Realm()
        let quote = realm.objects(GlobalQuote.self).filter("symbol == '" + forSymbol + "'")
        if quote.first != nil {
            return quote.last!
        } else {
            let quote =  GlobalQuote.init()
            return quote
        }
       
    }
    
 @MainActor
    func fetch(forSymbol: String) async throws -> GlobalQuote   {
        
       //if let url = URL(string: "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol="+forSymbol+"&interval=5min&apikey=43G7PFJZE4GBS714") {
        var newforSymbol = "GOOG"
        if !forSymbol.isEmpty {
            newforSymbol = forSymbol
        }
        let (data, response) =
        try await URLSession.shared.data(from: URL(string: "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol="+newforSymbol+"&apikey=43G7PFJZE4GBS714")!)
            guard
                let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200
            else {
              throw DownloadError.statusNotOk
            }
            guard let decodedResponse = try? JSONDecoder().decode(GlobalQuoteResponse.self, from: data)
            else {  throw DownloadError.decoderError
            }
        print(decodedResponse.globalQuote)
        
        return decodedResponse.globalQuote
        
    }
    
}

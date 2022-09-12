import Foundation
import SwiftUI
import RealmSwift

protocol WatchListProtocol {
    var globalQuoteInteractor: QuoteInteractor { get set }
}
struct WatchList: View {
    var globalQuoteInteractor = QuoteInteractor.init(symbol: "GOOG")
    var body: some View {
         VStack {
            ForEach ( globalQuoteInteractor.quotes, content: { quote in
                    Text("Symbol: \(quote.symbol)")
                        .onAppear() {
                            print(quote.symbol)
                    }
               
        })
        }
    }
    
}

struct WatchListPreview: PreviewProvider {
    static var previews: some View {
        WatchList()
    }
}

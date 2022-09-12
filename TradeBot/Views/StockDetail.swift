import Foundation
import SwiftUI
import RealmSwift



protocol StockDetailProtocol {
    var quoteRealm: QuoteInteractor {get set}
}
struct StockDetail: View, StockDetailProtocol  {
    var quoteRealm: QuoteInteractor = QuoteInteractor.init(symbol: "GOOG")
    @State private var symbol = "GOOG"
    @State private var quotes: [GlobalQuote]  = [GlobalQuote.init()]
    @State private var quote: GlobalQuote = GlobalQuote.init()

    let timer = Timer.publish(every: 30, on: .main, in: .common).autoconnect()

    let columns = [
          GridItem(.flexible()),
          GridItem(.flexible())
      ]
    
    @State var currentDate = Date()
        
    var body: some View {
        let quoteRealm = QuoteInteractor.init(symbol: symbol)
   
        VStack.init(alignment: .leading, spacing: 1, content: {
            HStack {
                Image(systemName: "house") 
                    .resizable()
                    .frame(width: 30, height: 30, alignment: .center)
                    .padding(20)
                    .onTapGesture {
                        self.symbol = quoteRealm.symbol
                        self.quotes = quoteRealm.quotes
                        self.quote = quoteRealm.quote
                      
                }
                    .background(Color.blue)
                    .foregroundColor(.white)
                
                    
            }
            .frame(width:50,height: 50, alignment: .center)
            .mask(Circle())
            .offset(x:40, y:40)
            ZStack {
                VStack.init(alignment: .center, spacing: 0.5, content: {
                    Text(quote.symbol).font(.Large)
                    Text(quote.price).font(.Medium)
                    Text(quote.volume).font(.Medium)
                    Text(quote.latest_trading_day).font(.Small)
                    Text("\(currentDate)").font(.Small)
                              .onReceive(timer) { input in
                                  currentDate = input
                              }
                }).frame(width: 200, height: 200, alignment: .leading)
            }.offset(x:140,y:-40)
            ZStack {
                TextField("Symbol", text: $symbol).onSubmit {
                    Task {
                     try? await quoteRealm.update(symbol: symbol)
                        self.quotes = quoteRealm.quotes
                    }
                 
                }
                    .padding(10)
                    .cornerRadius(5.0)
                    .background(Color.LightGray)
                    .padding(.leading, 5)
                    .padding(.trailing, 5)
           
                    Image(systemName: "magnifyingglass.circle")
                        .resizable()
                        .foregroundColor(.black)
                        .frame(width: 30, height: 30, alignment: .leading)
                        .offset(x: (UIScreen.screenWidth / 2) - 30)
                        .opacity(0.3)
                        .onTapGesture {
                                        quoteRealm.getAll()
                            }
                        
                        
    
            }.frame(width: UIScreen.screenWidth, height: 50, alignment: .center)
            .background(Color.DarkGray)
            .padding(.leading, 20)
            .padding(.trailing, 20)
            .offset(x: 0, y: -80.0)
            
            ScrollView {
            LazyVGrid(columns: columns)  {
                ForEach ( quoteRealm.quotes, content: { quote in
                       VStack{
                                Text("Symbol: \(quote.symbol)")
                                Text("Price: \(quote.price)")
                                Text("Volume: \(quote.volume)")
                       }.frame(width: 140, height: 70, alignment: .top).padding(.top, 20)
                       .offset(y:10)
                       .font(.Small)
                       .background(Color.blue).opacity(0.5)
                })            .padding(4)
            }
            }.standard()
            .frame(height: UIScreen.screenHeight - 40)
            .offset(x:20, y:-50)
            
        }).standard().ignoresSafeArea().offset(y:150)
           
          
    }
}


struct StockDetailPreview: PreviewProvider {
    static var previews: some View {
        StockDetail()
    }
}

//
//   Page returns a standard page with a color and conserves .light and .dark
//   colorScheme
//
//
//

import Foundation
import SwiftUI

struct Page : View {
    @Binding var isPresented : Bool // Bindable
    var backgroundColor: Color
    var view: AnyView
    
    @State var opacity: Double = 1.0 // internal state
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        
        if(isPresented) {
            VStack{
            ZStack {
                VStack{}.standard().background(backgroundColor)
                 .opacity(colorScheme == .light ? 0.15 : 0.45)  //curtain
                AnyView(view)
            }
        
            .background( colorScheme == .light ? Color.white: Color.black)
            .onDisappear(perform: {
            isPresented = false
        })
                
            }
        }
    
    }
    
}
struct PageView: View {
    @Binding var presented: Bool
    var backgroundColor: Color
    @State var page: AnyView
  
    var Action:() -> Void

    var body: some View {
        ZStack {
            VStack{
                Page.init(isPresented: $presented, backgroundColor: backgroundColor, view: page).standard()
                
            }
        }.opacity(presented ? 1.0: 0.0)
        //.offset(x: presented ? 0 : -200)
        .frame(width: presented ? UIScreen.screenWidth : 0, height: presented ? UIScreen.screenHeight: 0, alignment: .top).animation(runOnce())
    }
}


struct PagePreview: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) {
            Page(isPresented: .constant(true),backgroundColor: Color.green, view: AnyView(ListSample())).preferredColorScheme($0).frame(height:UIScreen.screenHeight, alignment: .top)
               }
        
    }
}

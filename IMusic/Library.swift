//
//  Library.swift
//  IMusic
//
//  Created by Andrey Novikov on 8/7/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import SwiftUI

struct Library: View {
    var body: some View {
        VStack {
            GeometryReader { geomentry in
                HStack(alignment: .center) {
                    Button(action: {
                        print("123")
                    }, label: {
                        Image(systemName: "play.fill")
                    })
                        .frame(width: geomentry.size.width / 2 - 20, height: 50)
                        .accentColor(Color(#colorLiteral(red: 1, green: 0.2415002286, blue: 0.6340380311, alpha: 1)))
                        .background(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                        .cornerRadius(5)
                    
                    
                    Button(action: {
                        print("321")
                    }, label: {
                        Image(systemName: "arrow.2.circlepath")
                    })
                        .frame(width: geomentry.size.width / 2 - 20, height: 50)
                        .accentColor(Color(#colorLiteral(red: 1, green: 0.2415002286, blue: 0.6340380311, alpha: 1)))
                        .background(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                        .cornerRadius(5)
                    
                }.padding()
            }
            .frame(height: 50)
            
            Divider()
                .padding(.leading, 16)
                .padding(.trailing, 16)
            
            List {
                LibraryCellCell()
            }
        }
    }
}

struct LibraryCellCell: View {
    var body: some View {
        
        HStack {
            Image(systemName: "arrow.2.circlepath")
                .resizable()
                .cornerRadius(2)
                .frame(width: 50, height: 50)
            
            
            VStack {
                Text("Text title1")
                Text("Text tile2")
                
            }
            .padding(.leading, 16)
        }
        .padding(.leading, 16)
    }
}

struct Library_Previews: PreviewProvider {
    static var previews: some View {
        Library()
    }
}

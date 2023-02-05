//
//  ContentView.swift
//  Calculator_IOS
//
//  Created by Shobhit Goswami on 05/02/23.
//

import SwiftUI

struct ContentView: View {
    
    let buttonGrid = [
        ["AC", "⌫", "%", "/"],
        ["7", "8", "9", "x"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        [".", "0", "", "="]
    ]
    
    let operators = ["/", "+", "x", "%"]
    
    var body: some View {
        VStack {
            HStack {
                
            Spacer()
                
            Text("History")
                .padding()
                .foregroundColor(.white)
                .font(.system(size: 30, weight: .heavy))
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            
            HStack {
                
                Spacer()
                    
                Text("Current")
                    .padding()
                    .foregroundColor(.white)
                    .font(.system(size: 50, weight: .heavy))
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
            
                ForEach(buttonGrid, id: \.self) {
                    row in
                    HStack{
                        ForEach(row, id: \.self) {
                            cell in
                            
                            Button(
                                action: {
                                buttonPressed(cell: cell)
                                }, label: {
                                Text(cell)
                                    .foregroundColor(buttonColor(cell))
                                    .font(.system(size: 50, weight: .heavy))
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                }
                            )
                        }
                    }
                    
                }
        }
        .background(Color.black)
    }
    
    func buttonColor(_ cell: String) -> Color {
        if(cell == "AC" || cell == "⌫"){
            return .red
            
        }
        if(cell == "-" || cell == "=" || operators.contains(cell)){
            return .orange
            
        }
        return .white
    }
    
    func buttonPressed(cell: String) {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

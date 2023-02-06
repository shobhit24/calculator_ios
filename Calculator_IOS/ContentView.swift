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
        [".", "0", "="]
    ]
    
    let operators = ["/", "+", "x", "%"]
    
    var body: some View {
        VStack {
            HStack {
                
            Spacer()
                
            Text("History")
                .padding()
                .foregroundColor(.black)
                .font(.system(size: 30, weight: .heavy))
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            
            HStack {
                
                Spacer()
                    
                Text("Current")
                    .padding()
                    .foregroundColor(.black)
                    .font(.system(size: 50, weight: .heavy))
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
            
            ForEach(buttonGrid, id: \.self) { row in
                HStack(alignment: .top,spacing: 12) {
                    ForEach(row, id: \.self) { cell in
                        if(cell != ""){ Button(action: {
                            buttonPressed(cell: cell)
                        }, label: {
                            Text(cell)
                                .font(.system(size: 24))
                                .frame(width: self.buttonWidth(cell),
                                       height: self.buttonHeight(cell))
                                .foregroundColor(.black)
                                .overlay( cell == "=" ?
                                          RoundedRectangle(cornerRadius: 42).stroke(.white, lineWidth: 3) :
                                            RoundedRectangle(cornerRadius: 70).stroke(.white, lineWidth: 3)
                                    )


                        })}
                       
                    }
                }
                .shadow(color: .gray, radius: 1, x: 1, y: 2)
                .padding(.bottom, 3)
                Spacer()
            }
            
            
        }
        .background(Color.white)
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
    
    func buttonWidth(_ cell: String) -> CGFloat {
        if cell == "=" {
            return ((UIScreen.main.bounds.width + 60 - (4*12)) / 5) * 2
        }
        return (UIScreen.main.bounds.width + 60 - (5*12)) / 5
    }
    
    func buttonHeight(_ cell: String) -> CGFloat {
        return (UIScreen.main.bounds.width - 60 - (5*12)) / 4
    }
    
    func buttonPressed(cell: String) {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//  ContentView.swift
//  Calculator_IOS
//
//  Created by Shobhit Goswami on 05/02/23.
//

import SwiftUI

struct CustomColor {
    static let myColor = Color("0xffF4BC4D")
    static let secondColor = UIColor.init(named: "0xffF4BC4D")
    // Add more here...
}

struct ContentView: View {
    
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    let buttonGrid = [
        ["AC", "%", "x", "/"],
        ["7", "8", "9", "-"],
        ["4", "5", "6", "+"],
        ["1", "2", "3", "⌫"],
        [".", "0", "="]
    ]
    
    let operators = ["/", "+", "x", "%"]
    
    let purpleColorHolder = ["/", "+", "-", "+", "⌫", "="]
    
    @State var visibleWorkings = ""
    @State var visibleResults = "0"
    @State var showAlert = false
    
    var body: some View {
        VStack {
            
            // History View
            HStack {
                Spacer()
                Text(visibleWorkings)
                    .padding().foregroundColor(isDarkMode ? Color("Dark Result") : Color("Light Result"))
                    .font(.system(size: 30, weight: .heavy))
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            
            
            // Result View
            HStack {
                
                Spacer()
                
                Text(visibleResults)
                    .padding()
                    .foregroundColor(isDarkMode ? Color("Dark Result") : Color("Light Result"))
                    .font(.system(size: 64, weight: .heavy))
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            
            
            // Toggle Button to change theme Dark <-> Light
            HStack() {
                Toggle("", isOn: $isDarkMode).labelsHidden()
                    .tint(Color(UIColor(Color("Dark Purple"))))
                    .onChange(of: isDarkMode) { value in
                        isDarkMode.toggle()
                    }
                Text(isDarkMode ? "Switch to LIGHT THEME" : "Switch to DARK THEME")
                    .foregroundColor(isDarkMode ? .white : .black)
                Spacer()
            }
            .padding(.leading, 22)
            
            
            // Double ForEach loop to build pur num-pad
            ForEach(buttonGrid, id: \.self) { row in
                HStack(alignment: .top,spacing: 12) {
                    ForEach(row, id: \.self) { cell in
                        Button(
                            action: {
                                buttonPressed(cell: cell)
                            },
                            label: {
                                Text(cell)
                                    .font(.system(size: 24))
                                    .frame(width: self.buttonWidth(cell),
                                           height: self.buttonHeight(cell))
                                    .foregroundColor(isDarkMode ? .white : .black)
                                    .background(self.buttonColor(cell))
                                    .overlay( cell == "=" ?
                                              RoundedRectangle(cornerRadius: 42).stroke(.white, lineWidth: 3) :
                                                RoundedRectangle(cornerRadius: 70).stroke(.white, lineWidth: 3)
                                    )
                                
                                
                            })
                        .background(isDarkMode ? Color(UIColor(Color("Selection Dark Color"))) : Color(UIColor(Color("Selection Color")))) // If you have this
                        .cornerRadius(42)
                     
                        
                    }
                }
                .shadow(color: .gray, radius: 1, x: 1, y: 2)
                .padding(.bottom, 3)
                Spacer()
            }
        }
        .background(isDarkMode ? Color(UIColor(Color("Dark Background"))) : Color(UIColor(Color("Light Background"))))
        .alert(isPresented: $showAlert) {
            
            // Alert Popup in case of Invalid input
            Alert(
                title: Text("Invalid Input"),
                message: Text(visibleWorkings),
                dismissButton: .default(Text("Okay"))
            )
        }
        
    }
    
    // function to get the different colours for button depending upon the theme
    func buttonColor(_ cell: String) -> Color {
        if(cell == "AC"){
            return Color(UIColor(Color("Yellow")))
            
        }
        if(cell == "%" || cell == "x"){
            return isDarkMode ? Color(UIColor(Color("Dark Yellow"))) : Color(UIColor(Color("Light Yellow")))
            
        }
        if(purpleColorHolder.contains(cell)){
            return isDarkMode ? Color(UIColor(Color("Dark Purple"))) : Color(UIColor(Color("Light Purple")))
        }
        return isDarkMode ? Color(UIColor(Color("Default Dark Button"))) : Color(UIColor(Color("Default Light Button")))
    }
    
    // functions to get the width and height of the buttons in order to handle responsiveness of numpad on different screen-size devices
    func buttonWidth(_ cell: String) -> CGFloat {
        if cell == "=" {
            return ((UIScreen.main.bounds.width + 60 - (4*12)) / 5) * 2
        }
        return (UIScreen.main.bounds.width + 60 - (5*12)) / 5
    }
    
    func buttonHeight(_ cell: String) -> CGFloat {
        return (UIScreen.main.bounds.width - 60 - (5*12)) / 4
    }
    
    // function to do the operation depending upon the type of button pressed
    func buttonPressed(cell: String) {
        switch (cell) {
        case "AC":
            visibleWorkings = ""
            visibleResults = "0"
        case "⌫":
            visibleWorkings = String(visibleWorkings.dropLast())
        case "=":
            visibleResults = calculateResults()
        case "-":
            addMinus()
        case "x", "/", "%", "+":
            addOperator(cell)
        default:
            visibleWorkings += cell
        }
    }
    
    // function to add the operators in the visible workings (History)
    func addOperator(_ cell : String) {
        if !visibleWorkings.isEmpty {
            let last = String(visibleWorkings.last!)
            if operators.contains(last) || last == "-" {
                visibleWorkings.removeLast()
            }
            visibleWorkings += cell
        }
    }
    
    // function to add negative in the starting to make a number negative in the visible workings (History)
    func addMinus() {
        if  visibleWorkings.isEmpty || visibleWorkings.last! != "-" {
            visibleWorkings += "-"
        }
    }
    
    // function to perform operation
    func calculateResults() -> String {
        if(validInput()) {
            var workings = visibleWorkings.replacingOccurrences(of: "%", with: "*0.01")
            workings = workings.replacingOccurrences(of: "x", with: "*")
            let expression = NSExpression(format: workings)
            let result = expression.expressionValue(with: nil, context: nil) as! Double
            return formatResult(val: result)
        }
        showAlert = true
        return ""
    }
    
    // function to check if the input is valid
    func validInput() -> Bool {
        if(visibleWorkings.isEmpty) {
            return false
        }
        
        let last = String(visibleWorkings.last!)
        
        if(operators.contains(last) || last == "-") {
            if(last != "%" || visibleWorkings.count == 1) {
                return false
            }
        }
        return true
    }
    // function to evalute and show formatted result
    func formatResult(val : Double) -> String {
        if(val.truncatingRemainder(dividingBy: 1) == 0) {
            return String(format: "%.0f", val)
        }
        return String(format: "%.2f", val)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

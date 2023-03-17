//
//  ContentView.swift
//  CircleSliderDemo
//
//  Created by sunyazhou on 2023/3/16.
//

import SwiftUI


struct ContentView: View
{
    @State var progress1 = 0.75
    @State var progress2 = 37.5
    @State var progress3 = 7.5
    
    var body: some View {
        ZStack {
            Color(hue: 0.58, saturation: 0.06, brightness: 1.0)
                .edgesIgnoringSafeArea(.all)

            VStack {
                CircularSliderView(value: $progress1)
                    .frame(width:250, height: 250)
                
                HStack {
                    CircularSliderView(value: $progress2, in: 1...10)

                    CircularSliderView(value: $progress3, in: 0...100)
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

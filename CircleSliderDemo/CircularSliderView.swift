//
//  CircularSliderView.swift
//  CircleSliderDemo
//
//  Created by sunyazhou on 2023/3/16.
//

import Foundation
import SwiftUI

struct CircularSliderView: View
{
    @Binding var progress: Double
    @State private var rotationAngle = Angle(degrees: 0)
    
    private var minValue = 0.0
    private var maxValue = 1.0
    
    init(value progress: Binding<Double>, in bounds: ClosedRange<Int> = 0...1) {
        self._progress = progress
        self.minValue = Double(bounds.first ?? 0)
        self.maxValue = Double(bounds.last ?? 1)
        self.rotationAngle = Angle(degrees: progressFraction * 360.0)

    }
    
    private var progressFraction: Double {
        return ((progress - minValue) / (maxValue - minValue))
    }
    
    private func changeAngle(location: CGPoint) {
        // 为位置创建一个向量（在 iOS 上反转 y 坐标系统）
        let vector = CGVector(dx: location.x, dy: -location.y)
        
        //计算向量的角度
        let angleRadians = atan2(vector.dx, vector.dy)
        
        // 将角度转换为 0 到 360 的范围（而不是负角度）
        let positiveAngle = angleRadians < 0.0 ? angleRadians + (2.0 * .pi) : angleRadians
        
        // 根据角度更新滑块进度值
        progress = ((positiveAngle / (2.0 * .pi)) * (maxValue - minValue )) + minValue
        rotationAngle = Angle(radians: positiveAngle)
    }
    
    var body: some View {
        GeometryReader { gr in
            let radius = (min(gr.size.width, gr.size.height) / 2.0) * 0.9
            let sliderWidth = radius * 0.1
            
            VStack(spacing: 0) {
                ZStack {
                    Circle() //外圆
                        .stroke(Color(hue: 0.0, saturation: 0.0, brightness: 0.9), lineWidth: 20.0)
                        .overlay() {
                            Text("\(progress, specifier: "%.2f")")
                                .font(.system(size: radius * 0.6, weight: .bold, design: .rounded))
                        }
                    Circle() //进度条
                        .trim(from: 0, to: progressFraction)
                        .stroke(Color(hue: 0.0, saturation: 0.5, brightness: 0.9),
                                style: StrokeStyle(lineWidth: sliderWidth, lineCap: .round))
                        .rotationEffect(Angle(degrees: -90))
                    Circle() //旋钮
                        .fill(Color.white)
                        .shadow(radius: sliderWidth * 0.3)
                        .frame(width: sliderWidth, height: sliderWidth)
                        .offset(y: -radius)
                        .rotationEffect(rotationAngle)
                        .gesture(
                            DragGesture(minimumDistance: 0.0)
                                .onChanged() { value in
                                    changeAngle(location: value.location)
                                }
                        )
                }
                .frame(width: radius * 2.0, height: radius * 2.0, alignment: .center)
                .padding(radius * 0.1)
            }
            
            .onAppear {
                self.rotationAngle = Angle(degrees: progressFraction * 360.0)
            }
            
        } 
    }
}

//
//  ContentView.swift
//  ChartViewV2Demo
//
//  Created by Samu András on 2020. 07. 25..
//  Copyright © 2020. Samu András. All rights reserved.
//

import SwiftUI
import SwiftUICharts

struct ContentView: View {
    @State var data1: [Double] = (0..<16).map { _ in .random(in: 9.0...100.0) }
    @State var data2: [Double] = (0..<16).map { _ in .random(in: 9.0...100.0) }
    @State var data3: [Double] = (0..<12).map { _ in .random(in: 9.0...100.0) }

	@State private var curvedLines : Bool = false
	@State private var showBackground : Bool = false
	@State private var lineWidth : CGFloat = 1.0

	@State private var chartMaxLimit = ChartLimit.fromData
	@State private var chartMaxExplicit : Double = 200
	@State private var symmetrical : Bool = false

    let mixedColorStyle = ChartStyle(backgroundColor: .white, foregroundColor: [
        ColorGradient(ChartColors.orangeBright, ChartColors.orangeDark),
        ColorGradient(.purple, .blue)
    ])
    let blueStlye = ChartStyle(backgroundColor: .white,
                               foregroundColor: [ColorGradient(.purple, .blue)])
    let orangeStlye = ChartStyle(backgroundColor: .white,
                                 foregroundColor: [ColorGradient(ChartColors.orangeBright, ChartColors.orangeDark)])

    var body: some View {

		let currentStyle = ChartStyle(backgroundColor: .white,
									  foregroundColor: [ColorGradient(.purple, .blue)],
									  lineWidth: lineWidth, curvedLines: curvedLines, showBackground: showBackground)
		currentStyle.limits = ChartLimits(yLimit: chartMaxLimit, symmetrical: symmetrical)

        return VStack(alignment: .center, spacing: 12.0) {
            BarChart()
                .data(data2)
                .chartStyle(mixedColorStyle)

            CardView(showShadow: false) {
                ChartLabel("Title", type: .subTitle)
                LineChart()
            }
            .data(data1)
			.chartStyle(currentStyle)

            CardView {
                ChartLabel("Title", type: .title)
                BarChart()
            }
            .data(data3)
            .chartStyle(orangeStlye)
            .frame(width: 160, height: 240)
            .padding()

			HStack {
				Button(action: {
					self.data1 = (0..<16).map { _ in .random(in: 1.0...100.0) } as [Double]
					self.data2 = (0..<16).map { _ in .random(in: 1.0...100.0) } as [Double]
					self.data3 = (0..<16).map { _ in .random(in: 1.0...100.0) } as [Double]

					self.data1[0] = 100.0		// Override the first few random values . . .
					self.data2[0] = 100.0
					self.data3[0] = 100.0		// Make sure we are showing the extremes of values

					self.data1[1] = 1.0			// by going from max to min a couple of times
					self.data2[1] = 1.0
					self.data3[1] = 1.0

					self.data1[2] = 100.0
					self.data2[2] = 100.0
					self.data3[2] = 100.0

					self.data1[3] = 0.0
					self.data2[3] = 0.0
					self.data3[3] = 0.0


				}) {
					Image(systemName: "shuffle")
				}
				Spacer()
				Text("Curved").font(.footnote)
				Toggle("", isOn: $curvedLines).labelsHidden()
				Spacer()
				Text("Background").font(.footnote)
				Toggle("", isOn: $showBackground).labelsHidden()
				Spacer()
				Text("Width").font(.footnote)
				Slider(value: $lineWidth, in: 1...40) {
					Text("Width")	// not used? What's the point of this if it is unseen?
				}
			}.padding(.horizontal)

			HStack {
				Picker(selection: $chartMaxLimit, label: Text("")) {
					Text("Data").tag(ChartLimit.fromData)
					Text("10…").tag(ChartLimit.powerOfTen)
					Text("50…").tag(ChartLimit.halfPowerOfTen)
					Text("#0…").tag(ChartLimit.firstSignificant)
					Text("##0…").tag(ChartLimit.secondSignificant)
					Text("\(chartMaxExplicit, specifier: "%.0f")").tag(ChartLimit.explicit(range:chartMaxExplicit ..< chartMaxExplicit))
					}.pickerStyle(SegmentedPickerStyle())
				Slider(value: $chartMaxExplicit, in:100...1000, step:25)
				Spacer()
				Text("Symmetrical").font(.footnote)
				Toggle("", isOn: $symmetrical).labelsHidden()
			}.padding(.horizontal)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

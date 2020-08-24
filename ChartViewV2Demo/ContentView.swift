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

	@State private var selectedTab = 1

	@State var data1: [Double] = (0..<16).map { _ in .random(in: 9.0...100.0) }
	@State var data2: [Double] = (0..<16).map { _ in .random(in: 9.0...100.0) }
	@State var data3: [Double] = (0..<12).map { _ in .random(in: 9.0...100.0) }
	@State var data4: [Double] = (0..<8) .map { _ in .random(in: 1.0...125.0) }

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
	let blueStyle = ChartStyle(backgroundColor: .white,
							   foregroundColor: [ColorGradient(.purple, .blue)])
	let orangeStyle = ChartStyle(backgroundColor: .white,
								 foregroundColor: [ColorGradient(ChartColors.orangeBright, ChartColors.orangeDark)])

	let multiStyle = ChartStyle(backgroundColor: Color.green.opacity(0.2),
								foregroundColor:
									[ColorGradient(.purple, .blue),
									 ColorGradient(.orange, .red),
									 ColorGradient(.green, .yellow),
									 ColorGradient(.red, .purple),
									 ColorGradient(.yellow, .orange),
									])

	var body: some View {

		let currentStyle = ChartStyle(backgroundColor: .white,
									  foregroundColor: [ColorGradient(.purple, .blue)],
									  lineWidth: lineWidth, curvedLines: curvedLines, showBackground: showBackground)
		currentStyle.limits = ChartLimits(yLimit: chartMaxLimit, symmetrical: symmetrical)

		return VStack {

			HStack {
				Button(action: {
					self.data1 = (0..<16).map { _ in .random(in: 1.0...100.0) } as [Double]
					self.data2 = (0..<16).map { _ in .random(in: 1.0...100.0) } as [Double]
					self.data3 = (0..<16).map { _ in .random(in: 1.0...100.0) } as [Double]
					self.data4 = (0..<8) .map { _ in .random(in: 1.0...125.0) } as [Double]

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
					Text("Shuffle baby")
				}

				Spacer()
				// Other controls
			}
			.padding()

			TabView(selection: $selectedTab) {

				VStack {

					BarChart()
						.data(data2)
						.chartStyle(mixedColorStyle)


					CardView {
						ChartLabel("Bar Chart", type: .legend)
						BarChart()
					}
					.data(data3)
					.chartStyle(orangeStyle)
					.frame(width: 160, height: 240)
					.padding()
				}
				.tabItem { Image(systemName:"chart.bar.xaxis") }.tag(1)
				VStack {

					PieChart()
						.data(data1)
						.chartStyle(orangeStyle)

					CardView {
						ChartLabel("Pie Chart", type: .title)
						PieChart()
					}
					.data(data2)
					.chartStyle(blueStyle)
					.padding()


				}
				.tabItem { Image(systemName:"chart.pie.fill") }.tag(2)



				VStack {

					CardView(showShadow: true) {
						ChartLabel("Line Chart", type: .subTitle)
						LineChart()
					}
					.data(data1)
					.chartStyle(currentStyle)
					.padding()


					LineChart()
						.data(data2)
						.chartStyle(currentStyle)

					HStack {
						Group {		// beat the limit of 10
							Spacer()
							Text("Curve").font(.footnote)
							Toggle("", isOn: $curvedLines).labelsHidden()
							Spacer()
							Text("Bkgnd").font(.footnote)
							Toggle("", isOn: $showBackground).labelsHidden()
						}
						Spacer()
						Text("Line").font(.footnote)
						Slider(value: $lineWidth, in: 1...40) {
							Text("Line width")	// not used? What's the point of this if it is unseen?
						}
						.frame(maxWidth:50)	// limit width
						Spacer()
						Text("±").font(.footnote)
						Toggle("", isOn: $symmetrical).labelsHidden()
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
							.frame(maxWidth:50)	// limit width
					}.padding(.horizontal)
				}
				.tabItem { Image(systemName:"waveform.path.ecg.rectangle") }.tag(3)

				VStack {

					RingsChart()
						.data(self.data4)
						.chartStyle(multiStyle)
						.padding()

					CardView(showShadow: false) {
						ChartLabel("Rings Chart", type: .legend)
						RingsChart()
					}
					.data(Array(self.data4[0...2]))
					.chartStyle(multiStyle)
					.frame(width: 130, height: 130)
					.padding([.bottom])

				}
				.tabItem { Image(systemName:"circle") }.tag(4)
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}





//
//  ContentView.swift
//  SwiftBicycleDemoApp
//
//  Copyright © 2020 Spheresoft. All rights reserved.
//

import SwiftUI
import SwiftBicycle

class ConverterNetwork: ObservableObject, BicycleNetworkDelegate {
    let objectWillChange = ObjectWillChangePublisher()

    let network = BicycleNetwork()

    // Fields
    var yardsField = Field<Double>(name: "yards")
    var feetField = Field<Double>(name: "feet")
    var inchesField = Field<Double>(name: "inches")

    init() {
        let nf = NumberFormatter()
        nf.positiveFormat = "##0.##"
        yardsField.formatter = nf
        feetField.formatter = nf
        inchesField.formatter = nf

        network.adoptField(field: yardsField)
        network.adoptField(field: feetField)
        network.adoptField(field: inchesField)
        Calculator1OpFactory.registerFactory(target: yardsField, operand0: feetField) { $0 / 3 }
        Calculator1OpFactory.registerFactory(target: feetField, operand0: yardsField) { $0 * 3 }
        Calculator1OpFactory.registerFactory(target: inchesField, operand0: feetField) { $0 * 12 }
        Calculator1OpFactory.registerFactory(target: feetField, operand0: inchesField) { $0 / 12 }

        network.delegate = self
        network.connectCalculators()
    }

    func networkWillCalculate(_ network: BicycleNetwork) {
        objectWillChange.send()
    }
}

extension TextField where Label == Text {
    func foregroundColor(code: AnyField.Code) -> some View {
        let color: Color
        switch code {
        case .error:
            color = .red
        case .set:
            color = .blue
        default:
            color = .black
        }
        return foregroundColor(color)
    }
}

struct ContentView: View {
    @ObservedObject var network: ConverterNetwork

    var body: some View {
        VStack {
            Text("Bicycle Converter")
                .font(.system(.title))
            HStack {
                Text("Yards")
                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0))
                    .frame(width: 80, alignment: .trailing)
                TextField("Yards", field: $network.yardsField)
                    .foregroundColor(code: network.yardsField.code)

                Spacer()
            }
            HStack {
                Text("Feet")
                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0))
                    .frame(width: 80, alignment: .trailing)
                TextField("Feet", field: $network.feetField)
                    .foregroundColor(code: network.feetField.code)

                Spacer()
            }
            HStack {
                Text("Inches")
                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0))
                    .frame(width: 80, alignment: .trailing)
                TextField("Inches", field: $network.inchesField)
                    .foregroundColor(code: network.inchesField.code)
                Spacer()
            }
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(network: ConverterNetwork())
    }
}

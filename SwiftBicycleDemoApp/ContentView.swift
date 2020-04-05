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
    var feetField = Field<Double>()
    var inchesField = Field<Double>()

    init() {
        network.adoptField(field: feetField)
        network.adoptField(field: inchesField)
        Calculator1OpFactory.registerFactory(targetId: inchesField.id, operator1Id: feetField.id) { $0 * 12.0 }
        Calculator1OpFactory.registerFactory(targetId: feetField.id, operator1Id: inchesField.id) { $0 / 12.0 }

        network.delegate = self
        network.connectCalculators()
    }

    func networkWillCalculate(_ network: BicycleNetwork) {
        objectWillChange.send()
    }
}

extension TextField {
    func foregroundColor(code: AnyField.Code) -> some View {
         return foregroundColor(Color(code == .set ? .blue : .black))
    }
}

struct ContentView: View {
    @ObservedObject var network: ConverterNetwork

    var body: some View {
        VStack {
            Text("Bicycle Converter")
                .font(.system(.title))
            HStack {
                Text("Feet")
                TextField("Feet", text: $network.feetField.text)
                    .foregroundColor(code: network.feetField.code)
                Spacer()
            }
            HStack {
                Text("Inches")
                TextField("Inches", text: $network.inchesField.text)
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

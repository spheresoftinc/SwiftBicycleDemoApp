//
//  ContentView.swift
//  SwiftBicycleDemoApp
//
//  Copyright © 2020 Spheresoft. All rights reserved.
//

import SwiftUI
import SwiftBicycle

struct ConverterNetworkState: NetworkState {
    // Fields
    let feetField = Field<Double>()
    let inchesField = Field<Double>()

    // Build the network when you get a reference to one. This network will be
    // shared wiht all values of ConverterNetworkState copied from the first one.
    var collection: FieldCollection? {
        didSet {
            guard let collection = self.collection else { return }
            collection.adoptField(field: feetField)
            collection.adoptField(field: inchesField)
            let _ = CalculatorInitializer1Op(targetId: inchesField.id, operator1Id: feetField.id) { $0 * 12.0 }
            let _ = CalculatorInitializer1Op(targetId: feetField.id, operator1Id: inchesField.id) { $0 / 12.0 }

            collection.connectCalculators()
        }
    }

    // MARK: UI State
    // These properties are bindable into SwiftUI directly. The ones that can be changed need
    // a didSet to send that change to the fields that back them up. If you change anything,
    // call updateState() to update the other fields, which the UI is bound to.

    var feetText: String = "" {
        didSet {
            self.feetField.set(text: feetText, updateState: { self.updateState() })
        }
    }
    var feetColor: UIColor = .black

    var inchesText: String = "" {
        didSet {
            self.inchesField.set(text: inchesText, updateState: { self.updateState() })
        }
    }
    var inchesColor: UIColor = .black

    mutating func updateState() {
        (feetText, feetColor) = getTextAndColor(field: feetField)
        (inchesText, inchesColor) = getTextAndColor(field: inchesField)
    }
}

struct ContentView: View {
    @State var uiState: ConverterNetworkState

    init(fieldCollection: FieldCollection) {
        self._uiState = ConverterNetworkState.make(collection: fieldCollection)
    }

    var body: some View {
        VStack {
            Text("Bicycle Converter")
                .font(.system(.title))
            HStack {
                Text("Feet")
                TextField("Feet", text: $uiState.feetText)
                    .foregroundColor(Color(uiState.feetColor))
                Spacer()
            }
            HStack {
                Text("Inches")
                TextField("Inches", text: $uiState.inchesText)
                    .foregroundColor(Color(uiState.inchesColor))
                Spacer()
            }
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(fieldCollection: FieldCollection())
    }
}

//
//  BicycleExtensions.swift
//  SwiftBicycleDemoApp
//
//  Created by Louis Franco on 4/4/20.
//  Copyright © 2020 App-o-Mat. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import SwiftBicycle

extension Field where Field.ValueType: Equatable & LosslessStringConvertible {
    func set(value: T, updateState: () -> Void) {
        guard
            let collection = self.collection,
            self.code == .clear || self.value() != value
        else { return }

        collection.adoptSetter(setter: SetterConstant(target: self, value: value))
        updateState()
    }

    func set(text: String, updateState: () -> Void) {
        if let val = T(text) {
            set(value: val, updateState: updateState)
        }
    }

    func get() -> (String, Field.Code) {
        let text: String
        if self.code != .clear {
            text = String(self.value())
        } else {
            text = ""
        }
        return (text, self.code)
    }
}

protocol NetworkState {
    init()
    var collection: FieldCollection? { get set }
    mutating func updateState()
    func getTextAndColor<T: Equatable & LosslessStringConvertible>(field: Field<T>) -> (String, UIColor)
}

extension NetworkState {
    func getTextAndColor<T: Equatable & LosslessStringConvertible>(field: Field<T>) -> (String, UIColor) {
        let (text, code) = field.get()
        return (text, code == .set ? .blue : .black)
    }

    static func make<T: NetworkState>(collection: FieldCollection) -> State<T> {
        var state = T()
        state.collection = collection
        return State<T>(initialValue: state)
    }
}

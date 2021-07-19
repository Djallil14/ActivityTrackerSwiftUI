//
//  Binding+onChange.swift
//  ActivityTracker
//
//  Created by Djallil Elkebir on 2021-07-19.
//

import SwiftUI

extension Binding {
    func onChange(_ handler: @escaping ()->Void)-> Binding<Value> {
        Binding(
            get: {self.wrappedValue},
            set: {newValue in
                self.wrappedValue = newValue
                handler()
            }
        )
    }
}

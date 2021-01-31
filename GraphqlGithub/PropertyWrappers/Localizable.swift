//
//  Localizable.swift
//  GraphqlGithub
//
//  Created by ricardo hernandez  on 29/01/21.
//

import Foundation

@propertyWrapper
struct Localizable {
    private var key: String
    var wrappedValue: String {
        get { NSLocalizedString(key, comment: "") }
        set { key = newValue }
    }
    init(wrappedValue: String) {
        self.key = wrappedValue
    }
}

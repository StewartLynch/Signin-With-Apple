//
//  DocumentSerializable.swift
//  SwiftUISignInWithAppleAndFirebaseDemo
//
//  Created by Alex Nagy on 08/12/2019.
//  Copyright © 2019 Alex Nagy. All rights reserved.
//

import Foundation

protocol DocumentSerializable {
    init?(documentData: [String: Any])
}

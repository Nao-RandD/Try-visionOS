//
//  String+Extension.swift
//  ObjectMaker
//
//  Created by Nao RandD on 2023/09/17.
//

import Foundation

extension String: Error, LocalizedError {
    public var errorDescription: String? { self }
}

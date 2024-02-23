//
//  BaseViewModelCreator.swift
//  UnitTest_Sample
//
//  Created by osmanyildirim
//

import Foundation

protocol BaseViewModelCreator {
    associatedtype ViewModel

    static func create(_ viewController: BaseViewModel?) -> ViewModel
}

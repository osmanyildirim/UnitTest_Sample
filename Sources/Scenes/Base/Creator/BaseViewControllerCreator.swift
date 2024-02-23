//
//  BaseViewControllerCreator.swift
//  UnitTest_Sample
//
//  Created by osmanyildirim
//

import UIKit

protocol BaseViewControllerCreator {
    associatedtype ViewModel

    static func create(viewModel: ViewModel?) -> UIViewController
}

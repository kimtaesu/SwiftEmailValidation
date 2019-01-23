//
//  EmailValidationResultState.swift
//  SwiftEmailValidation
//
//  Created by tskim on 23/01/2019.
//  Copyright © 2019 hucet. All rights reserved.
//
import UIKit
import ReactorKit
import SkyFloatingLabelTextField

protocol UITextFieldForValidation {
    var input: SkyFloatingLabelTextField { get }
}

extension UITextFieldForValidation where Self: HasDisposeBag {
    func bindEmailValidation<T: Reactor>(reactor: T) where T.State: EmailValidationResultState {
        reactor.state.map { $0.validationResult }
            .distinctUntilChanged()
            .bind(to: input.rx.error)
            .disposed(by: disposeBag)
    }
}

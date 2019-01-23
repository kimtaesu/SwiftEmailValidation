//
//  ViewController.swift
//  SwiftEmailValidation
//
//  Created by tskim on 23/01/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import UIKit
import ReactorKit
import SkyFloatingLabelTextField
import RxCocoa
import RxSwift

class ViewController: UIViewController, UITextFieldForValidation {

    internal let input = SkyFloatingLabelTextField(frame: CGRect.init(x: 50, y: 50, width: 300, height: 40))

    override func viewDidLoad() {
        super.viewDidLoad()
        input.title = "Email"
        view.addSubview(input)
        self.reactor = EmailValidationReactor()
    }
}

extension ViewController: View, HasDisposeBag {
    func bind(reactor: EmailValidationReactor) {
        self.bindEmailValidation(reactor: reactor)
        input.rx.text
            .map { Reactor.Action.setEmail($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

extension Reactive where Base: SkyFloatingLabelTextField {
    var error: Binder<ValidationResult?> {
        return Binder(self.base) { input, validation in
            switch validation {
            case .no(let error)?:
                input.errorMessage = error
            default:
                input.errorMessage = ""
            }
        }
    }
}


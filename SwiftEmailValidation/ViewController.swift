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

class ViewController: UIViewController {

    private let inputEmail = SkyFloatingLabelTextField(frame: CGRect.init(x: 50, y: 50, width: 300, height: 40))

    override func viewDidLoad() {
        super.viewDidLoad()
        inputEmail.title = "Email"
        view.addSubview(inputEmail)
        self.reactor = EmailValidationReactor()
    }
}

extension ViewController: View, HasDisposeBag {
    func bind(reactor: EmailValidationReactor) {
        inputEmail.rx.text
            .map { Reactor.Action.setEmail($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state.map { $0.validationResult }
            .distinctUntilChanged()
            .bind(to: inputEmail.rx.error)
            .disposed(by: disposeBag)
        
//        reactor.state.map { $0.validationResult }
//            .distinctUntilChanged()
//            .asDriver(onErrorJustReturn: nil)
//            .drive(inputEmail.rx.error)
//            .disposed(by: disposeBag)
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


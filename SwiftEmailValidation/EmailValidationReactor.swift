//
//  EmailValidationReactor.swift
//  SwiftEmailValidation
//
//  Created by tskim on 23/01/2019.
//  Copyright © 2019 hucet. All rights reserved.
//
import ReactorKit
import RxSwift
import UIKit

enum ValidationResult: Equatable {
    case ok
    case no(_ msg: String)
}

protocol EmailValidationResultState {
    var email: String { get }
    var validationResult: ValidationResult? { get }
}

class EmailValidationReactor: Reactor {
    internal let initialState: State = State(email: "")

    enum Action {
        case setEmail(String?)
    }

    struct State: EmailValidationResultState {
        var email: String

        public init(email: String) {
            self.email = email
        }

        var validationResult: ValidationResult?
    }

    enum Mutation {
        case setEmail(String)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setEmail(let email):
            guard let email = email else { return .empty() }
            return .just(Mutation.setEmail(email))
        }
    }
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = State(email: state.email)
        switch mutation {
        case .setEmail(let email):
            newState.email = email
            newState.validationResult = email.validEmail
        }
        return newState
    }
}

extension String {
    var isNotEmpty: Bool {
        return !self.isEmpty
    }

    var validEmail: ValidationResult {
        return self.isEmail ? ValidationResult.ok : ValidationResult.no("This is not an email format.")
    }

    var isEmail: Bool {
        let EMAIL_REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", EMAIL_REGEX).evaluate(with: self)
    }
}

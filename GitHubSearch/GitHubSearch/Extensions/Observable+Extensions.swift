//
//  Observable+Extensions.swift
//  GitHubSearch
//
//  Created by Ivan Kalaica on 21/09/2017.
//  Copyright © 2017 Kalaica. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension ObservableType {
    public func asSignalIgnoringErrors() -> Signal<E> {
        return asSignal(onErrorRecover: { e in
            #if DEBUG
                fatalError("\(e)")
            #else
                return Signal.empty()
            #endif
        })
    }
}

extension ObservableType {
    public func asDriverIgnoringErrors() -> Driver<E> {
        return asDriver(onErrorRecover: { e in
            #if DEBUG
                fatalError("\(e)")
            #else
                return Driver.empty()
            #endif
        })
    }
}

extension ObservableType {
    public func retryAfter(seconds: Int, scheduler: SchedulerType = MainScheduler.instance) -> Observable<E> {
        return retryWhen { (errors: Observable<Error>) in
            return errors.flatMap { _ -> Observable<Int> in
                return Observable<Int>.timer(RxTimeInterval(seconds), scheduler: scheduler)
            }
        }
    }
    
    public func retry(maxAttemptCount count: Int, delayBetweenAttemptsInSeconds delay: Int, scheduler: SchedulerType = MainScheduler.instance) -> Observable<E> {
        return retryWhen { (errors: Observable<Error>) in
            return errors.flatMapWithIndex { (e: Error, i: Int) -> Observable<Int> in
                if i >= count - 1 {
                    return Observable.error(e)
                }
                return Observable<Int>.timer(RxTimeInterval(delay), scheduler: scheduler)
            }
        }
    }
}

extension ObservableType {
    public func scanAndMaybeEmit<State, Emit>(state: State, accumulator: @escaping (State, E) throws -> (State, Emit?)) -> Observable<Emit> {
        return self.scan((state, nil)) { stateEmitPair, element in
            return try accumulator(stateEmitPair.0, element)
            }
            .flatMap { stateEmitPair -> Observable<Emit> in
                return stateEmitPair.1.map { Observable.just($0) } ?? Observable.empty()
        }
    }
}

extension SharedSequence {
    public func scanAndMaybeEmit<State, Emit>(state: State, accumulator: @escaping (State, E) -> (State, Emit?)) -> SharedSequence<S, Emit> {
        return self.scan((state, nil)) { stateEmitPair, element in
            return accumulator(stateEmitPair.0, element)
            }
            .flatMap { stateEmitPair -> SharedSequence<S, Emit> in
                return stateEmitPair.1.map { SharedSequence<S, Emit>.just($0) } ?? SharedSequence<S, Emit>.empty()
        }
    }
}

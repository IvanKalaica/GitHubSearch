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

extension Observable {
    public static func system<R>(
        _ initialState: R,
        accumulator: @escaping (R, Element) -> R,
        scheduler: SchedulerType,
        feedback: (Observable<R>) -> Observable<Element>...
        ) -> Observable<R> {
        return Observable<R>.deferred {
            let replaySubject = ReplaySubject<R>.create(bufferSize: 1)
            
            let inputs: Observable<Element> = Observable.merge(feedback.map { $0(replaySubject.asObservable()) })
                .observeOn(scheduler)
            
            return inputs.scan(initialState, accumulator: accumulator)
                .startWith(initialState)
                .do(onNext: { output in
                    replaySubject.onNext(output)
                })
        }
    }
}

extension SharedSequence {
    public static func system<R>(
        _ initialState: R,
        accumulator: @escaping (R, E) -> R,
        feedback: (SharedSequence<S, R>) -> SharedSequence<S, Element>...
        ) -> SharedSequence<S, R> {
        return SharedSequence<S, R>.deferred {
            let replaySubject = ReplaySubject<R>.create(bufferSize: 1)
            
            let outputDriver = replaySubject.asSharedSequence(onErrorDriveWith: SharedSequence<S, R>.empty())
            
            // This is a hack because we need to make sure events are being sent async because of reentrancy.
            // In case MainScheduler is being used, we need to use MainScheduler.asyncInstance to make sure state is modified async.
            // If there is some unknown scheduler instance, we just use it.
            let originalScheduler = SharedSequence<S, R>.SharingStrategy.scheduler
            let scheduler = (originalScheduler as? MainScheduler).map { _ in MainScheduler.asyncInstance } ?? originalScheduler
            
            let inputs = SharedSequence.merge(feedback.map { $0(outputDriver) })
                .asObservable()
                .observeOn(scheduler)
                .asSharedSequence(onErrorDriveWith: SharedSequence<S, Element>.empty())
            
            return inputs.scan(initialState, accumulator: accumulator)
                .startWith(initialState)
                .do(onNext: { output in
                    replaySubject.onNext(output)
                })
        }
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

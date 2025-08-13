//
//  MyObservable.swift
//  UIKitPractice21
//
//  Created by 송재훈 on 8/12/25.
//

import Foundation

@propertyWrapper
final class MyObservable<T> {
    struct MyPublisher {
        private let observable: MyObservable<T>
        
        init(observable: MyObservable<T>) {
            self.observable = observable
        }
        
        func bind(handler: @escaping (T) -> Void) {
            handler(observable.value)
            self.observable.handlers.append(handler)
        }
    }
    
    private var handlers: [(T) -> Void]
    private var value: T
    
    var projectedValue: MyObservable<T>.MyPublisher {
        get {
            MyPublisher(observable: self)
        }
    }
    
    var wrappedValue: T {
        get {
            return value
        }
        set {
            self.value = newValue
            
            self.handlers.forEach {
                $0(newValue)
            }
        }
    }
    
    init(value: T) {
        self.value = value
        self.handlers = []
    }
}

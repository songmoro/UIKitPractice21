//
//  UIControl+.swift
//  UIKitPractice21
//
//  Created by 송재훈 on 8/12/25.
//

import UIKit
import Combine

extension UIControl {
    struct EventPublisher: Publisher {
        typealias Output = UIControl
        typealias Failure = Never
        
        private let control: UIControl
        private let event: UIControl.Event
        
        init(control: UIControl, event: UIControl.Event) {
            self.control = control
            self.event = event
        }
        
        func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, UIControl == S.Input {
            let subscription = EventSubscription(control: control, subscrier: subscriber, event: event)
            subscriber.receive(subscription: subscription)
        }
    }
    
    private final class EventSubscription<EventSubscriber: Subscriber>: Subscription where EventSubscriber.Input == UIControl, EventSubscriber.Failure == Never {
        private let control: UIControl
        private let event: UIControl.Event
        private var subscriber: EventSubscriber?
        
        init(control: UIControl, subscrier: EventSubscriber, event: UIControl.Event) {
            self.control = control
            self.subscriber = subscrier
            self.event = event
            
            control.addTarget(self, action: #selector(handler), for: event)
        }
        
        func request(_ demand: Subscribers.Demand) {
            
        }
        
        func cancel() {
            subscriber = nil
            control.removeTarget(self, action: #selector(handler), for: event)
        }
        
        @objc private func handler() {
            _ = subscriber?.receive(control)
        }
    }
    
    func publisher(_ event: UIControl.Event) -> UIControl.EventPublisher {
        return EventPublisher(control: self, event: event)
    }
}

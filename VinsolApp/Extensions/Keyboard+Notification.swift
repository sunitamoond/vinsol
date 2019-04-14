//
//  Keyboard+Notification.swift
//  VinsolApp
//
//  Created by Sunita Moond on 14/04/19.
//  Copyright © 2019 Sunita Moond. All rights reserved.
//

//import Foundation
//import UIKit
//
//struct NotificationDescriptor<A> {
//    let name: Notification.Name
//    let convert: (Notification) -> A
//}
//
//extension NotificationCenter {
//    func addObserver<A>(descriptor: NotificationDescriptor<A>, block: @escaping (A) -> ()) -> Token {
//        let token = addObserver(forName: descriptor.name, object: nil, queue: nil) { (note) in
//            block(descriptor.convert(note))
//        }
//
//        return Token(token: token, center: self)
//    }
//}
//
//class Token {
//    let center: NotificationCenter
//    let token: NSObjectProtocol
//
//    init(token: NSObjectProtocol, center: NotificationCenter) {
//        self.token = token
//        self.center = center
//    }
//
//    deinit {
//        center.removeObserver(token)
//    }
//}
//
//struct KeyboardPayload {
//    let beginFrame: CGRect
//    let duration: TimeInterval
//}
//
//extension KeyboardPayload {
//   init(note: Notification) {
//        guard let info = note.userInfo,
//            let keyboardFrameValue = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
//            else {
//                self.beginFrame = CGRect.zero
//                self.duration = 0
//
//                return
//        }
//        self.beginFrame = keyboardFrameValue
//        self.duration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
//    }
//}

//extension UIViewController {
//    static let keyboardWillShow = NotificationDescriptor(name: .UIResponder.keyboardWillShowNotification, convert: KeyboardPayload.init(note: Notification.init(name: .UIResponder.keyboardWillShowNotification)))
//    static let keyboardWillHide = NotificationDescriptor(name: Notification.Name.UIResponder.keyboardWillHideNotification, convert: KeyboardPayload.init)
//}

//struct SystemNotification {
//    static let keyboardShowNotification = NotificationDescriptor(name: .UIResponder.keyboardWillShowNotification, convert: KeyboardPayload(note: <#T##Notification#>))
//    static let keyboardHideNotification = NotificationDescriptor(name: .UIResponder.keyboardWillHideNotification, convert: KeyboardPayload(note: <#T##Notification#>))
//}


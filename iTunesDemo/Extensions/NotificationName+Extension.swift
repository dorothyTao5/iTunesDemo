//
//  NotificationName+Extension.swift
//  iTunesDemo
//
//  Created by dorothyTao on 2022/4/13.
//

import Foundation

extension Notification.Name {
    static let PlayerUnknownNotification = Notification.Name(rawValue: "UnknownNotification")
    static let PlayerReadyToPlayNotification = Notification.Name(rawValue: "ReadyToPlayNotification")
    static let PlayerDidToPlayNotification = Notification.Name(rawValue: "DidToPlayNotification")
    static let PlayerBufferingStartNotification = Notification.Name(rawValue: "BufferingStartNotification")
    static let PlayerBufferingEndNotification = Notification.Name(rawValue: "BufferingEndNotification")
    static let PlayerFailedNotification = Notification.Name(rawValue: "FailedNotification")
    static let PauseNotification = Notification.Name(rawValue: "PauseNotification")
    static let PlayerPlayFinishNotification = Notification.Name(rawValue: "PlayFinishNotification")
}

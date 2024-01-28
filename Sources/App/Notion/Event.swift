//
//  Event.swift
//  TestNotionSwift
//
//  Created by 朱浩宇 on 2024/1/23.
//

import Foundation

struct Event {
    let uid: String
    let title: String
    let start: Date
    let end: Date?
    let dateOnly: Bool
    let description: String
    let meeting: URL?
    let invitee: [Invitee]
}

class Invitee {
    var rsvp: Bool = true;
    var name: String;
    var email: String;

    init(name: String, email: String) {
        self.name = name;
        self.email = email;
    }

    func setRsvp(rsvp: Bool) {
        self.rsvp = rsvp;
    }
}

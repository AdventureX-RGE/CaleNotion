//
//  File.swift
//
//
//  Created by 慕芸熙 on 2024/1/24.
//

import Foundation;

func date2DtStringEnd(date: Date) -> String {
    let endFormatter = DateFormatter();
    endFormatter.dateFormat = "HHmmss";
    endFormatter.timeZone = TimeZone.current;

    return endFormatter.string(from: date);
}

func date2DtStringFront(date: Date) -> String {
    let frontFormatter = DateFormatter();
    frontFormatter.dateFormat = "yyyyMMdd";
    frontFormatter.timeZone = TimeZone.current;

    return frontFormatter.string(from: date);
}

func date2DtString(date: Date) -> String {
    return date2DtStringFront(date: date) + "T" + date2DtStringEnd(date: date);
}

public class IcsItem {
    var section: IcsSection = .none;
    var children: [IcsItem] = [];

    func asString() -> String {
        """
        BEGIN:\(self.section.asString())
        \(self.propertiesAsString())
        \(self.childrenAsString())
        END:\(self.section.asString())
        """
    }

    func propertiesAsString() -> String {
        ""
    }

    func childrenAsString() -> String {
        var result: [String] = [];
        for child in children {
            result.append(child.asString());
        }
        return result.joined(separator: "\n");
    }


    func addChild(_ child: IcsItem) {
        self.children.append(child);
    }
}

public class IcsMain: IcsItem {
    var prodid: String = "-//unknown//unknown//EN";
    var version: IcsVersion = .v2;
    var calscale: String = "GREGORIAN";
    var method: IcsMethod = .PUBLISH;
    var classification: IcsClass = .PUBLIC;

    override init() {
        super.init();
        self.section = .VCALENDAR;
    }

    override func propertiesAsString() -> String {
        """
        PRODID:\(self.prodid)
        VERSION:\(self.version.asString())
        CALSCALE:\(self.calscale)
        METHOD:\(self.method)
        CLASS:\(self.classification.asString())
        """
    }
}

public class IcsTimeZone: IcsItem {
    var timezone: TimeZone = TimeZone.current;

    override init() {
        super.init();
        self.section = .VTIMEZONE;
    }

    override func propertiesAsString() -> String {
        """
        TZID:\(self.timezone.identifier)
        TZURL:http://tzurl.org/zoneinfo-outlook/\(self.timezone.identifier)
        X-LIC-LOCATION:\(self.timezone.identifier)
        """
    }
}

public class IcsEvent: IcsItem {
    var dtStart: Date;
    var dtEnd: Date?;
    var summary: String;
    var uid: String;
    var dtStamp: Date = Date();
    var description: String = "";
    var location: String = "";
    var timezone: TimeZone = TimeZone.current;
    var dayOnly: Bool = false;
    var invitees: [Invitee];

    init(_ event: Event) {
        self.dtStart = event.start;
        self.dtEnd = event.end;
        self.summary = event.title;
        self.description = event.title;
        self.location = event.title;
        self.uid = event.uid;
        self.dayOnly = event.dateOnly;
        self.description = event.description;
        self.location = event.meeting?.description ?? "";
        self.invitees = event.invitee;

        super.init();
        self.section = .VEVENT;
    }

    override func propertiesAsString() -> String {
        var dtStartString = "";
        var dtEndString = "";
        var inviteeString = "";

        if self.dayOnly {
            dtStartString = "DTSTART;VALUE=DATE:\(date2DtStringFront(date: self.dtStart))";
        } else {
            dtStartString = "DTSTART;TZID=\(self.timezone.identifier):\(date2DtString(date: self.dtStart))"
        }

        if let endDate = self.dtEnd {
            if self.dayOnly {
                dtEndString = "DTEND;VALUE=DATE:\(date2DtStringFront(date: endDate))";
            } else {
                dtEndString = "DTEND;TZID=\(self.timezone.identifier):\(date2DtString(date: endDate))";
            }
        }

        for invitee in invitees {
            inviteeString += "ATTENDEE;CUTYPE=INDIVIDUAL;ROLE=REQ-PARTICIPANT;RSVP=\(invitee.rsvp.description.uppercased());CN=\(invitee.name):MAILTO:\(invitee.email)\n";
        }

        return """
        DTSTAMP:\(date2DtString(date: self.dtStamp))
        \(dtStartString)
        \(dtEndString)
        SUMMARY:\(self.summary)
        UID:\(self.uid)
        DESCRIPTION:\(self.description)
        LOCATION:\(self.location)
        \(inviteeString)
        """;
    }
}

public class IcsAlarm: IcsItem {
    var trigger: IcsTriggerTime = .beforeMinutes(10);
    var action: IcsTriggerAction = .DISPLAY;
    var description: String = "Reminder";

    override init() {
        super.init();
        self.section = .VALARM;
    }

    override func propertiesAsString() -> String {
        """
        TRIGGER:\(self.trigger.asString())
        ACTION:\(self.action)
        DESCRIPTION:\(self.description)
        """
    }
}
 

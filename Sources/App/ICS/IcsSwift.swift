func icsFromEventList(_ events: [Event]) -> IcsMain {
    let main = IcsMain();
    main.addChild(IcsTimeZone());
    for event in events {
        let aEvent = IcsEvent(event);
        aEvent.addChild(IcsAlarm());
        main.addChild(aEvent);
    }
    return main;
}

enum IcsClass {
	case PUBLIC;
	case PRIVATE;
	case CONFIDENTIAL;
	case ianaToken(String);
	case xName(String);

	func asString() -> String {
		switch self {
			case .ianaToken(let token): return "\(token)";
			case .xName(let name): return "\(name)";
			default: return "\(self)"
		}
	}
}

enum IcsVersion {
	case v1;
	case v2;

	func asString() -> String {
		switch self {
			case .v1: return "1.0";
			case .v2: return "2.0";
		}
	}
}

enum IcsSection: String {
	case VCALENDAR;
	case VTIMEZONE;
	case STANDARD;
	case VEVENT;
	case VALARM;
	case none;

	func asString() -> String {
		switch self {
			case .none: return "";
			default: return "\(self)";
		}
	}
}

enum IcsMethod: String {
	case PUBLISH;
}

enum IcsTriggerTime {
	case beforeSeconds(Int);
	case beforeMinutes(Int);

	func asString() -> String {
		switch self {
			case .beforeSeconds(let second): return "-PT\(second)S"
			case .beforeMinutes(let minute): return "-PT\(minute)M"
		}
	}
}

enum IcsTriggerAction: String {
	case DISPLAY;
	case AUDIO;
	case EMAIL;
}

//
// Do not edit directly, this file was auto-generated.
//

import SwiftUI

public enum EsdsColors {
    public enum red: String, CaseIterable {
        case red50
        case red100
        case red200
        case red300
        case red400
        case red500
        case red600
        case red700
        case red800
        case red900
        case red950

        public var color: Color {
            Color(rawValue)
        }
    }

    public enum gray: String, CaseIterable {
        case gray50
        case gray100
        case gray200
        case gray300
        case gray400
        case gray500
        case gray600
        case gray700
        case gray800
        case gray900
        case gray950
        case gray400 - 10
        case gray950 - 10
        case gray400 - 6
        case gray400 - 8
        case gray400 - 14
        case gray950 - 14
        case gray950 - 6
        case gray950 - 8

        public var color: Color {
            Color(rawValue)
        }
    }

    public enum pink: String, CaseIterable {
        case pink50
        case pink100
        case pink200
        case pink300
        case pink400
        case pink500
        case pink600
        case pink700
        case pink800
        case pink900
        case pink950

        public var color: Color {
            Color(rawValue)
        }
    }

    public enum blue: String, CaseIterable {
        case blue50
        case blue100
        case blue200
        case blue300
        case blue400
        case blue500
        case blue600
        case blue700
        case blue800
        case blue900
        case blue950

        public var color: Color {
            Color(rawValue)
        }
    }

    public enum black: String, CaseIterable {
        case black

        public var color: Color {
            Color(rawValue)
        }
    }

    public enum white: String, CaseIterable {
        case white

        public var color: Color {
            Color(rawValue)
        }
    }

    public enum purple: String, CaseIterable {
        case purple50
        case purple100
        case purple200
        case purple300
        case purple400
        case purple500
        case purple600
        case purple700
        case purple800
        case purple900
        case purple950

        public var color: Color {
            Color(rawValue)
        }
    }

    public enum orange: String, CaseIterable {
        case orange50
        case orange100
        case orange200
        case orange300
        case orange400
        case orange500
        case orange600
        case orange700
        case orange800
        case orange900
        case orange950

        public var color: Color {
            Color(rawValue)
        }
    }

    public enum lime: String, CaseIterable {
        case lime50
        case lime100
        case lime200
        case lime300
        case lime400
        case lime500
        case lime600
        case lime700
        case lime800
        case lime900
        case lime950

        public var color: Color {
            Color(rawValue)
        }
    }

    public enum cyan: String, CaseIterable {
        case cyan50
        case cyan100
        case cyan200
        case cyan300
        case cyan400
        case cyan500
        case cyan600
        case cyan700
        case cyan800
        case cyan900
        case cyan950

        public var color: Color {
            Color(rawValue)
        }
    }

    public enum indigo: String, CaseIterable {
        case indigo50
        case indigo100
        case indigo200
        case indigo300
        case indigo400
        case indigo500
        case indigo600
        case indigo700
        case indigo800
        case indigo900
        case indigo950

        public var color: Color {
            Color(rawValue)
        }
    }

    public enum aqua: String, CaseIterable {
        case aqua50
        case aqua100
        case aqua200
        case aqua300
        case aqua400
        case aqua500
        case aqua600
        case aqua700
        case aqua800
        case aqua900
        case aqua950

        public var color: Color {
            Color(rawValue)
        }
    }

    public enum violet: String, CaseIterable {
        case violet50
        case violet100
        case violet200
        case violet300
        case violet400
        case violet500
        case violet600
        case violet700
        case violet800
        case violet900
        case violet950

        public var color: Color {
            Color(rawValue)
        }
    }

    public enum coral: String, CaseIterable {
        case coral50
        case coral100
        case coral200
        case coral300
        case coral400
        case coral500
        case coral600
        case coral700
        case coral800
        case coral900
        case coral950

        public var color: Color {
            Color(rawValue)
        }
    }

    public enum ocean: String, CaseIterable {
        case ocean50
        case ocean100
        case ocean200
        case ocean300
        case ocean400
        case ocean500
        case ocean600
        case ocean700
        case ocean800
        case ocean900
        case ocean950

        public var color: Color {
            Color(rawValue)
        }
    }

    public enum emerald: String, CaseIterable {
        case emerald50
        case emerald100
        case emerald200
        case emerald300
        case emerald400
        case emerald500
        case emerald600
        case emerald700
        case emerald800
        case emerald900
        case emerald950

        public var color: Color {
            Color(rawValue)
        }
    }

    public enum yellow: String, CaseIterable {
        case yellow50
        case yellow100
        case yellow200
        case yellow300
        case yellow400
        case yellow500
        case yellow600
        case yellow700
        case yellow800
        case yellow900
        case yellow950

        public var color: Color {
            Color(rawValue)
        }
    }

    public enum transparent: String, CaseIterable {
        case transparent

        public var color: Color {
            Color(rawValue)
        }
    }

    public static var allByCategory: [(name: String, colors: [Color])] {
        [
            ("red", red.allCases.map(\.color)),
            ("gray", gray.allCases.map(\.color)),
            ("pink", pink.allCases.map(\.color)),
            ("blue", blue.allCases.map(\.color)),
            ("black", black.allCases.map(\.color)),
            ("white", white.allCases.map(\.color)),
            ("purple", purple.allCases.map(\.color)),
            ("orange", orange.allCases.map(\.color)),
            ("lime", lime.allCases.map(\.color)),
            ("cyan", cyan.allCases.map(\.color)),
            ("indigo", indigo.allCases.map(\.color)),
            ("aqua", aqua.allCases.map(\.color)),
            ("violet", violet.allCases.map(\.color)),
            ("coral", coral.allCases.map(\.color)),
            ("ocean", ocean.allCases.map(\.color)),
            ("emerald", emerald.allCases.map(\.color)),
            ("yellow", yellow.allCases.map(\.color)),
            ("transparent", transparent.allCases.map(\.color))
        ].sorted { $0.colors.count > $1.colors.count }
    }
}

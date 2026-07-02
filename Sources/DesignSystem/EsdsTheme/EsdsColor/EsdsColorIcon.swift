/*
 Do not edit directly, this file was auto-generated.
 */

import SwiftUI

public struct EsdsColorIcon: Sendable {
    public let brand: EsdsColorIconBrand
    public let disabled: Color
    public let feedback: EsdsColorIconFeedback
    public let inverse: Color
    public let on: EsdsColorIconOn
    public let primary: Color
    public let secondary: Color
    public let tertiary: Color

    init(
        brand: EsdsColorIconBrand = EsdsColorIconBrand(),
        disabled: Color = RawToken.EsdsColor.iconDisabled,
        feedback: EsdsColorIconFeedback = EsdsColorIconFeedback(),
        inverse: Color = RawToken.EsdsColor.iconInverse,
        on: EsdsColorIconOn = EsdsColorIconOn(),
        primary: Color = RawToken.EsdsColor.iconPrimary,
        secondary: Color = RawToken.EsdsColor.iconSecondary,
        tertiary: Color = RawToken.EsdsColor.iconTertiary
    ) {
        self.brand = brand
        self.disabled = disabled
        self.feedback = feedback
        self.inverse = inverse
        self.on = on
        self.primary = primary
        self.secondary = secondary
        self.tertiary = tertiary
    }
}

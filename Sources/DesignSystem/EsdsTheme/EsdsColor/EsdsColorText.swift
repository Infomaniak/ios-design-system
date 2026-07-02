/*
 Do not edit directly, this file was auto-generated.
 */

import SwiftUI

public struct EsdsColorText: Sendable {
    public let brand: EsdsColorTextBrand
    public let disabled: Color
    public let feedback: EsdsColorTextFeedback
    public let inverse: Color
    public let on: EsdsColorTextOn
    public let primary: Color
    public let secondary: Color
    public let tertiary: Color

    init(
        brand: EsdsColorTextBrand = EsdsColorTextBrand(),
        disabled: Color = RawToken.EsdsColor.textDisabled,
        feedback: EsdsColorTextFeedback = EsdsColorTextFeedback(),
        inverse: Color = RawToken.EsdsColor.textInverse,
        on: EsdsColorTextOn = EsdsColorTextOn(),
        primary: Color = RawToken.EsdsColor.textPrimary,
        secondary: Color = RawToken.EsdsColor.textSecondary,
        tertiary: Color = RawToken.EsdsColor.textTertiary
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

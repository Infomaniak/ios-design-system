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
        disabled: Color = PrimitiveToken.Color.textDisabled,
        feedback: EsdsColorTextFeedback = EsdsColorTextFeedback(),
        inverse: Color = PrimitiveToken.Color.textInverse,
        on: EsdsColorTextOn = EsdsColorTextOn(),
        primary: Color = PrimitiveToken.Color.textPrimary,
        secondary: Color = PrimitiveToken.Color.textSecondary,
        tertiary: Color = PrimitiveToken.Color.textTertiary
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

/*
 Do not edit directly, this file was auto-generated.
 */

import SwiftUI

public extension EsdsTheme.Color {
    struct Text: Sendable {
        public let brand: Brand
        public let disabled: Color
        public let feedback: Feedback
        public let inverse: Color
        public let on: On
        public let primary: Color
        public let secondary: Color
        public let tertiary: Color

        init(
            brand: Brand = Brand(),
            disabled: Color = PrimitiveToken.Color.textDisabled,
            feedback: Feedback = Feedback(),
            inverse: Color = PrimitiveToken.Color.textInverse,
            on: On = On(),
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
}

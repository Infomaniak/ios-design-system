/*
 Do not edit directly, this file was auto-generated.
 */

import SwiftUI

public struct EsdsColorBackground: Sendable {
    public let brand: EsdsColorBackgroundBrand
    public let dataviz: EsdsColorBackgroundDataviz
    public let disabled: Color
    public let elevation: EsdsColorBackgroundElevation
    public let feedback: EsdsColorBackgroundFeedback

    init(
        brand: EsdsColorBackgroundBrand = EsdsColorBackgroundBrand(),
        dataviz: EsdsColorBackgroundDataviz = EsdsColorBackgroundDataviz(),
        disabled: Color = PrimitiveToken.Color.backgroundDisabled,
        elevation: EsdsColorBackgroundElevation = EsdsColorBackgroundElevation(),
        feedback: EsdsColorBackgroundFeedback = EsdsColorBackgroundFeedback()
    ) {
        self.brand = brand
        self.dataviz = dataviz
        self.disabled = disabled
        self.elevation = elevation
        self.feedback = feedback
    }
}

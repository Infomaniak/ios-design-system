/*
  Do not edit directly, this file was auto-generated.
*/

import SwiftUI

public struct EsdsColorText: Sendable {
   public let disabled: Color
   public let inverse: Color
   public let primary: Color
   public let secondary: Color
   public let tertiary: Color
   public let brand: EsdsColorTextBrand
   public let feedback: EsdsColorTextFeedback
   public let on: EsdsColorTextOn
   
     init(
       disabled: Color = RawToken.EsdsColor.textDisabled,
       inverse: Color = RawToken.EsdsColor.textInverse,
       primary: Color = RawToken.EsdsColor.textPrimary,
       secondary: Color = RawToken.EsdsColor.textSecondary,
       tertiary: Color = RawToken.EsdsColor.textTertiary,
       brand: EsdsColorTextBrand = EsdsColorTextBrand(),
       feedback: EsdsColorTextFeedback = EsdsColorTextFeedback(),
       on: EsdsColorTextOn = EsdsColorTextOn()
     ) {
       self.disabled = disabled
       self.inverse = inverse
       self.primary = primary
       self.secondary = secondary
       self.tertiary = tertiary
       self.brand = brand
       self.feedback = feedback
       self.on = on
     }
 }
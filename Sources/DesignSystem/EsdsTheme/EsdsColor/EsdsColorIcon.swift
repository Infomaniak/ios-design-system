/*
  Do not edit directly, this file was auto-generated.
*/

import SwiftUI

public struct EsdsColorIcon: Sendable {
   public let disabled: Color
   public let inverse: Color
   public let primary: Color
   public let secondary: Color
   public let tertiary: Color
   public let brand: EsdsColorIconBrand
   public let feedback: EsdsColorIconFeedback
   public let on: EsdsColorIconOn
   
   init(
     disabled: Color = RawToken.EsdsColor.iconDisabled,
     inverse: Color = RawToken.EsdsColor.iconInverse,
     primary: Color = RawToken.EsdsColor.iconPrimary,
     secondary: Color = RawToken.EsdsColor.iconSecondary,
     tertiary: Color = RawToken.EsdsColor.iconTertiary,
     brand: EsdsColorIconBrand = EsdsColorIconBrand(),
     feedback: EsdsColorIconFeedback = EsdsColorIconFeedback(),
     on: EsdsColorIconOn = EsdsColorIconOn()
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
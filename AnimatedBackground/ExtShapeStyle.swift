//
//  ExtShapeStyle.swift
//  AnimatedBackground
//
//  Created by Antoine Lucchini on 15/10/2024.
//

import SwiftUI

// MARK: - Gradient colors

private let tl = Color(hex: "#41FF00")
private let tc = Color(hex: "#FF97E8")
private let tr = Color(hex: "#FFF200")

private let ml = Color(hex: "#FF97E8")
private let mc = Color(hex: "#FFF200")
private let mr = Color(hex: "#41FF00")

private let bl = Color(hex: "#FFF200")
private let bc = Color(hex: "#41FF00")
private let br = Color(hex: "#FF97E8")

// MARK: - Grainy gradient

extension ShapeStyle where Self == AnyShapeStyle {
    static func grainGradient(time: TimeInterval, gridSize: Int = 3) -> Self {
        return AnyShapeStyle(ShaderLibrary.default.grainGradient(
            .boundingRect,
            .float(3),
            .float(time),
            .colorArray([tl, tc, tr,
                         ml, mc, mr,
                         bl, bc, br])
        ))
    }
}

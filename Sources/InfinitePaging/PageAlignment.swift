/*
 PageAlignment.swift
 InfinitePaging

 Created by Takuto Nakamura on 2023/11/07.
*/

import SwiftUI

public enum PageAlignment: String, CaseIterable {
    case horizontal
    case vertical

    func scalar(_ size: CGSize) -> CGFloat {
        switch self {
        case .horizontal: return size.width
        case .vertical: return size.height
        }
    }

    func offset(_ value: CGFloat) -> CGSize {
        switch self {
        case .horizontal: 
            return CGSize(width: value, height: 0)
        case .vertical:
            return CGSize(width: 0, height: value)
        }
    }
}

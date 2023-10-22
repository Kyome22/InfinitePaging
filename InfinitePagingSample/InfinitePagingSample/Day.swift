/*
 Day.swift
 InfinitePagingSample

 Created by Takuto Nakamura on 2023/10/22.
*/

import Foundation
import InfinitePaging

struct Page: Pageable {
    var id = UUID()
    var number: Int
}

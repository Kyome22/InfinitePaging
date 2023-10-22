/*
 InfinitePagingView.swift
 InfinitePaging

 Created by Takuto Nakamura on 2023/10/22.
*/

import SwiftUI

public protocol Pageable: Equatable & Identifiable {}

public struct InfinitePagingView<T: Pageable, Content: View>: View {
    @Binding var objects: [T]
    let pagingHandler: (PageDirection) -> Void
    let content: (T) -> Content

    init(
        objects: Binding<[T]>,
        pagingHandler: @escaping (PageDirection) -> Void,
        @ViewBuilder content: @escaping (T) -> Content
    ) {
        assert(objects.wrappedValue.count == 3, "objects count must be 3.")
        _objects = objects
        self.pagingHandler = pagingHandler
        self.content = content
    }

    public var body: some View {
        GeometryReader { proxy in
            HStack(alignment: .center, spacing: 0) {
                ForEach(objects) { object in
                    content(object)
                        .frame(width: proxy.size.width, height: proxy.size.height)
                }
            }
            .modifier(
                InfinitePagingViewModifier(
                    objects: $objects,
                    pageWidth: proxy.size.width,
                    pagingHandler: pagingHandler
                )
            )
        }
    }
}

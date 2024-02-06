/*
 InfinitePagingView.swift
 InfinitePaging

 Created by Takuto Nakamura on 2023/10/22.
*/

import SwiftUI

public protocol Pageable: Equatable & Identifiable {}

public struct InfinitePagingView<T: Pageable, Content: View>: View {
    @Binding var objects: [T]
    private let minimumDistance: CGFloat
    private let pageAlignment: PageAlignment
    private let pagingHandler: (PageDirection) -> Void
    private let content: (T) -> Content

    public init(
        objects: Binding<[T]>,
        minimumDistance: CGFloat = 0,
        pageAlignment: PageAlignment,
        pagingHandler: @escaping (PageDirection) -> Void,
        @ViewBuilder content: @escaping (T) -> Content
    ) {
        assert(objects.wrappedValue.count == 3, "objects count must be 3.")
        _objects = objects
        self.minimumDistance = minimumDistance
        self.pageAlignment = pageAlignment
        self.pagingHandler = pagingHandler
        self.content = content
    }

    public var body: some View {
        GeometryReader { proxy in
            Group {
                switch pageAlignment {
                case .horizontal:
                    horizontalView(size: proxy.size)
                case .vertical:
                    verticalView(size: proxy.size)
                }
            }
            .modifier(
                InfinitePagingViewModifier(
                    objects: $objects,
                    pageSize: Binding<CGFloat>(
                        get: { pageAlignment.scalar(proxy.size) },
                        set: { _ in }
                    ),
                    minimumDistance: minimumDistance,
                    pageAlignment: pageAlignment,
                    pagingHandler: pagingHandler
                )
            )
        }
        .clipped()
        .id(pageAlignment)
    }

    private func horizontalView(size: CGSize) -> some View {
        return HStack(alignment: .center, spacing: 0) {
            ForEach(objects) { object in
                content(object)
                    .frame(width: size.width, height: size.height)
            }
        }
    }

    private func verticalView(size: CGSize) -> some View {
        return VStack(alignment: .center, spacing: 0) {
            ForEach(objects) { object in
                content(object)
                    .frame(width: size.width, height: size.height)
            }
        }
    }
}

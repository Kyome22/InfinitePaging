/*
 InfinitePagingViewModifier.swift
 InfinitePaging

 Created by Takuto Nakamura on 2023/10/22.
*/

import SwiftUI

struct InfinitePagingViewModifier<T: Pageable>: ViewModifier {
    @Binding var objects: [T]
    @Binding var pageSize: CGFloat
    @State var pagingOffset: CGFloat
    @State var draggingOffset: CGFloat
    private let minimumDistance: CGFloat
    let pageAlignment: PageAlignment
    let pagingHandler: (PageDirection) -> Void

    var dragGesture: some Gesture {
        DragGesture(minimumDistance: minimumDistance)
            .onChanged { value in
                draggingOffset = pageAlignment.scalar(value.translation)
            }
            .onEnded { value in
                let oldIndex = Int(floor(0.5 - (pagingOffset / pageSize)))
                pagingOffset += pageAlignment.scalar(value.translation)
                draggingOffset = 0
                let newIndex = Int(max(0, min(2, floor(0.5 - (pagingOffset / pageSize)))))
                if #available(iOS 17.0, *) {
                    withAnimation(.linear(duration: 0.1)) {
                        pagingOffset = -pageSize * CGFloat(newIndex)
                    } completion: {
                        if newIndex == oldIndex { return }
                        if newIndex == 0 {
                            pagingHandler(.backward)
                        }
                        if newIndex == 2 {
                            pagingHandler(.forward)
                        }
                    }
                } else {
                    withAnimation(.linear(duration: 0.1)) {
                        pagingOffset = -pageSize * CGFloat(newIndex)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        if newIndex == oldIndex { return }
                        if newIndex == 0 {
                            pagingHandler(.backward)
                        }
                        if newIndex == 2 {
                            pagingHandler(.forward)
                        }
                    }
                }
            }
    }

    init(
        objects: Binding<[T]>,
        pageSize: Binding<CGFloat>,
        minimumDistance: CGFloat,
        pageAlignment: PageAlignment,
        pagingHandler: @escaping (PageDirection) -> Void
    ) {
        _objects = objects
        _pageSize = pageSize
        _pagingOffset = State(initialValue: -pageSize.wrappedValue)
        _draggingOffset = State(initialValue: 0)
        self.minimumDistance = minimumDistance
        self.pageAlignment = pageAlignment
        self.pagingHandler = pagingHandler
    }

    func body(content: Content) -> some View {
        content
            .offset(pageAlignment.offset(pagingOffset + draggingOffset))
            .simultaneousGesture(dragGesture)
            .onChange(of: objects) { _ in
                pagingOffset = -pageSize
            }
            .onChange(of: pageSize) { _ in
                pagingOffset = -pageSize
            }
    }
}

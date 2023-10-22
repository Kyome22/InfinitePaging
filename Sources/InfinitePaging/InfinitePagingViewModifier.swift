/*
 InfinitePagingViewModifier.swift
 InfinitePaging

 Created by Takuto Nakamura on 2023/10/22.
*/

import SwiftUI

struct InfinitePagingViewModifier<T: Pageable>: ViewModifier {
    @Binding var objects: [T]
    @Binding var pageWidth: CGFloat
    @State var pagingOffset: CGFloat
    @State var draggingOffset: CGFloat
    let pagingHandler: (PageDirection) -> Void

    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                draggingOffset = value.translation.width
            }
            .onEnded { value in
                let oldIndex = Int(floor(0.5 - (pagingOffset / pageWidth)))
                pagingOffset += value.translation.width
                draggingOffset = 0
                let newIndex = Int(max(0, min(2, floor(0.5 - (pagingOffset / pageWidth)))))
                withAnimation(.linear(duration: 0.1)) {
                    pagingOffset = -pageWidth * CGFloat(newIndex)
                } completion: {
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

    init(
        objects: Binding<[T]>,
        pageWidth: Binding<CGFloat>,
        pagingHandler: @escaping (PageDirection) -> Void
    ) {
        _objects = objects
        _pageWidth = pageWidth
        _pagingOffset = State(initialValue: -pageWidth.wrappedValue)
        _draggingOffset = State(initialValue: 0)
        self.pagingHandler = pagingHandler
    }

    func body(content: Content) -> some View {
        content
            .offset(x: pagingOffset + draggingOffset, y: 0)
            .simultaneousGesture(dragGesture)
            .onChange(of: objects) { _, _ in
                pagingOffset = -pageWidth
            }
            .onChange(of: pageWidth) { _, _ in
                pagingOffset = -pageWidth
            }
    }
}

/*
 ContentView.swift
 InfinitePagingSample

 Created by Takuto Nakamura on 2023/10/22.
*/

import SwiftUI
import InfinitePaging

struct ContentView: View {
    // Prepare three elements to display at first.
    @State var pages: [Page] = [
        Page(number: -1),
        Page(number: 0),
        Page(number: 1)
    ]
    @State var pageAlignment: PageAlignment = .horizontal

    var body: some View {
        VStack {
            InfinitePagingView(
                objects: $pages,
                pageAlignment: pageAlignment,
                pagingHandler: { pageDirection in
                    paging(pageDirection)
                },
                content: { page in
                    pageView(page)
                }
            )
            Picker("Alignment", selection: $pageAlignment) {
                ForEach(PageAlignment.allCases) { alignment in
                    Text(verbatim: alignment.label)
                        .tag(alignment)
                }
            }
        }
    }

    // Define the View that makes up one page.
    private func pageView(_ page: Page) -> some View {
        return Text(String(page.number))
            .font(.largeTitle)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray)
            .clipShape(RoundedRectangle(cornerRadius: 32))
            .padding()
    }

    // Shifts the array element by one when a paging request comes.
    private func paging(_ pageDirection: PageDirection) {
        switch pageDirection {
        case .backward:
            if let number = pages.first?.number {
                pages.insert(Page(number: number - 1), at: 0)
                pages.removeLast()
            }
        case .forward:
            if let number = pages.last?.number {
                pages.append(Page(number: number + 1))
                pages.removeFirst()
            }
        }
    }
}

extension PageAlignment: Identifiable {
    public var id: String { rawValue }
    var label: String { rawValue.localizedCapitalized }
}

#Preview {
    ContentView()
}

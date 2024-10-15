//
//  ContentView.swift
//  AnimatedBackground
//
//  Created by Antoine Lucchini on 15/10/2024.
//

import SwiftUI

struct ContentView: View {

    @State private var startTime = Date.now

    var body: some View {
        TimelineView(.animation) { timeline in
            let elapsedTime = startTime.distance(to: Date.now)
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundStyle(.grainGradient(time: elapsedTime*3))
                .opacity(0.6)
                .background(.black)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    ContentView()
}

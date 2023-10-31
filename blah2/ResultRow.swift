//
//  ResultRow.swift
//  blah2
//
//  Created by Jay Wren on 10/30/23.
//

import SwiftUI

struct ResultRow: View {
    var result: Result
    var body: some View {
        HStack {
            Text(result.name)
            Spacer()
            Text(result.description)
            Spacer()
            Text(result.duration.formatted(.time(pattern:
                    .minuteSecond(padMinuteToLength: 2,
                                 fractionalSecondsLength: 3)
            )))
        }
    }
}
/* e.g. because I'm learning swiftui
#Preview("zomg") {
    ResultRow(result: results[0])
}
#Preview("home") {
    ResultRow(result: results[1])
}*/

#Preview {
    Group {
        ResultRow(result: resultsPreview[0])
        ResultRow(result: resultsPreview[1])
    }
}

var resultsPreview: [Result] = [
    Result(id: 1, name: "1.1.1.1", description: "zomg ", duration: Duration(secondsComponent: 1, attosecondsComponent: 30000000000000000)),
    Result(id: 1, name: "192.168.1.1", description: "home router ", duration: Duration(secondsComponent: 2, attosecondsComponent: 40000000000000000)),
]

//
//  ResultList.swift
//  blah2
//
//  Created by Jay Wren on 10/30/23.
//

import SwiftUI

struct ResultList:View {
    var results: [Result]
    var body: some View {
        List (results.sorted {$0.duration < $1.duration}, id:\.id) {result in
            ResultRow(result: result)
        }
    }
}

#Preview {
    ResultList(results:resultsPreview)
}

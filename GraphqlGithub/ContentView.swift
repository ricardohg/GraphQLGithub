//
//  ContentView.swift
//  GraphqlGithub
//
//  Created by ricardo hernandez  on 27/01/21.
//

import SwiftUI

struct ContentView: View {
    @StateObject var remote = Remote()
    var body: some View {
        Text("Hello, world")
            .padding()
            .onAppear {
                self.remote.searchForGraphQLRepositories(with: 10, endCursor: nil)
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

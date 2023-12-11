//
//  pia12iosiapApp.swift
//  pia12iosiap
//
//  Created by BillU on 2023-12-11.
//

import SwiftUI

@main
struct pia12iosiapApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var store = Store()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .task(id: scenePhase) {
                    if scenePhase == .active {
                        await store.fetchActiveTransactions()
                    }
                    
                }
        }
    }
}

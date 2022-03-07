//
//  RealMeApp.swift
//  RealMe
//
//  Created by shehan karunarathna on 2022-03-07.
//

import SwiftUI
import RealmSwift

@main
struct RealMeApp: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.realmConfiguration, Realm.Configuration(  ))
        }
    }
}

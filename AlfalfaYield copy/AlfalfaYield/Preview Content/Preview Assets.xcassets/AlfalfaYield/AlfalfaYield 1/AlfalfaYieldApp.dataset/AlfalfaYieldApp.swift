//
//  AlfalfaYieldApp.swift
//  AlfalfaYield
//
//
import SwiftUI

@main  // This tells SwiftUI that this is the app entry point
struct AlfalfaYieldApp: App {
    var body: some Scene {
        WindowGroup {
            LoginPageView()  // Your starting view
        }
    }
}

    
    struct YourAppNameApp: App {
        var body: some Scene {
            WindowGroup {
                LoginPageView()  // Use your custom view here
            }
        }
    }


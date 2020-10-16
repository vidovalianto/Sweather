//
//  ContentView.swift
//  Sweather
//
//  Created by Vido Shaweddy on 10/14/20.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var dashboardVM = DashboardViewModel.shared
    
    var body: some View {
        VStack {
            Text(dashboardVM.curLocation ?? "Looking for location")
            if let location = dashboardVM.curLocation,
               let weather = dashboardVM.weathers,
               let lottieName = weather.weathers.first?.icon.lottieCode {
                LottieView(name: lottieName,
                           loopMode: .loop,
                           contentMode: .scaleAspectFit)
                
                Spacer()
                
                DetailView(location: "",
                           temp: String(weather.main.temp.toFahrenheit),
                           feelsLike: String(weather.main.feelsLike.toFahrenheit),
                           humidity: String(weather.main.humidity),
                           pressure: String(weather.main.pressure),
                           windSpeed: String(weather.wind.speed),
                           windDeg: String(weather.wind.deg))
                
            } else {
                LottieView(name: "error",
                           loopMode: .loop,
                           contentMode: .scaleAspectFit)
            }
            
        }.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

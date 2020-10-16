//
//  ContentView.swift
//  Sweather
//
//  Created by Vido Shaweddy on 10/14/20.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var dashboardVM = DashboardViewModel.shared
    @State var isUpdate = true
    @State var shouldRestart = false

    var body: some View {
        VStack {
            Text(dashboardVM.curLocation ?? "Looking for location")
                .bold()
                .font(.subheadline)
            
            if self.isUpdate,
               let weather = dashboardVM.weathers,
               let lottieName = weather.weathers.first?.icon.lottieCode {
                LottieView(name: lottieName,
                           loopMode: .loop,
                           contentMode: .scaleAspectFit)
                    .onReceive(NotificationCenter.default.publisher(for: UIScene.willDeactivateNotification)) { _ in
                            self.isUpdate = false
                        }
                    
                
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
                    .onAppear {
                        self.toggleRestart()
                    }
                
                if shouldRestart {
                    Text("Restart app after you have working connection").font(.caption)
                }
            }
        }.padding()
        .onReceive(NotificationCenter.default.publisher(for: UIScene.didActivateNotification)) { _ in
            self.isUpdate = true
    }
        .onReceive(NotificationCenter.default.publisher(for: UIScene.willEnterForegroundNotification)) { _ in
            self.isUpdate = true
        }.onDisappear {
            shouldRestart = false
        }
    }
    
    private func toggleRestart() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
            shouldRestart = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

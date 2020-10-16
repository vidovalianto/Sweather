//
//  DetailView.swift
//  Sweather
//
//  Created by Vido Shaweddy on 10/15/20.
//

import SwiftUI

struct DetailView: View {
    var location: String
    var temp: String
    var feelsLike: String
    var humidity: String
    var pressure: String
    var windSpeed: String
    var windDeg: String
    
    var body: some View {
        VStack(spacing: 20) {
            Text(location)
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Humidity: \(humidity)").font(.caption)
                    Text("Pressure: \(pressure)").font(.caption)
                    HStack(alignment: .center, spacing: 5) {
                        Text("💨").font(.callout)
                        Text("Speed: \(windSpeed)").font(.caption)
                        Text("Angle: \(windDeg)°").font(.caption)
                    }
                }
                
                Spacer()
                
                VStack {
                    Text("\(temp)°").bold().font(.largeTitle)
                    Text("Feels Like \(feelsLike)°").font(.callout)
                }
                
            }
        }
        .padding()
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(location:"StuyTown - New York - NY - 10009",
                   temp: "69",
                   feelsLike: "60",
                   humidity: "72",
                   pressure: "1012",
                   windSpeed: "2",
                   windDeg: "210")
    }
}


//
//  Rain.swift
//  Weatherify
//
//  Created by Vido Valianto on 4/10/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import Foundation

public class Rain: Codable {
    public let oneh: Double?
    public let threeh: Double?

    enum CodingKeys: String, CodingKey {
        case oneh = "1h", threeh = "3h"
    }

    public init(oneh: Double = 0.0, threeh: Double = 0.0) {
        self.oneh = oneh
        self.threeh = threeh
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.oneh = try? container.decode(Double.self, forKey: .oneh)
        self.threeh = try? container.decode(Double.self, forKey: .threeh)
    }
}

//
//  ContentView.swift
//  PacketTime
//
//  Created by Chien Lee on 2024/6/29.
//

import Combine
import SwiftUI

struct ContentView: View {
    enum MACInterface: String, CaseIterable, Identifiable {
        case GMII, XGMII
        var id: Self { self }
    }

    enum TimeUnits: String, CaseIterable, Identifiable {
        case second = "s"
        case millisecond = "ms"
        case microsecond = "µs"
        case nanosecond = "ns"
        case picosecond = "ps"
        var id: Self { self }
    }

    @State private var packetSizeInBytes: Int = 0
    @State private var chosenInterface: MACInterface = .GMII
    @State private var timeUnit: TimeUnits = .microsecond

    private var interfaceBitsPerSecond: Int {
        switch chosenInterface {
        case .GMII:
            return 1000000000
        case .XGMII:
            return 10000000000
        }
    }

    private var duration: Double {
        switch timeUnit {
        case .second:
            return Double(packetSizeInBytes) * 8 / Double(interfaceBitsPerSecond)
        case .millisecond:
            return Double(packetSizeInBytes) * 8 * 1000 / Double(interfaceBitsPerSecond)
        case .microsecond:
            return Double(packetSizeInBytes) * 8 * 1000000 / Double(interfaceBitsPerSecond)
        case .nanosecond:
            return Double(packetSizeInBytes) * 8 * 1000000000 / Double(interfaceBitsPerSecond)
        case .picosecond:
            return Double(packetSizeInBytes) * 8 * 1000000000000 / Double(interfaceBitsPerSecond)
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Packet Length in Bytes") {
                    TextField("", value: $packetSizeInBytes, format: .number)
                        .keyboardType(.numberPad)
                }

                Section("Interface") {
                    Picker("interface", selection: $chosenInterface) {
                        ForEach(MACInterface.allCases) { item in
                            Text(item.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("Duration") {
                    HStack {
                        Text("\(duration.formatted())")
                        Picker("", selection: $timeUnit) {
                            ForEach(TimeUnits.allCases) { item in
                                Text(item.rawValue)
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("PacketTime").font(.largeTitle)
                        Text("Calculate the Time Duration of a Packets").font(.subheadline)
                    }
                    .padding(.top, 40)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

//
//  CallingPoint.swift
//  TrainInformationService
//

import Foundation

public struct CallingPoint: Codable {
    let id = UUID()
	public let stationName: String
	public let stationCode: String
	public let departureTime: String
	public let currentStatus: String
}

//
//  CallingPoint.swift
//  TrainInformationService
//

import Foundation

public struct CallingPoint: Codable {
	public let stationName: String
	public let stationCode: String
	public let departureTime: String
	public let currentStatus: String
}

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
    
    public init(stationName: String, stationCode: String, departureTime: String, currentStatus: String) {
        self.stationName = stationName
        self.stationCode = stationCode
        self.departureTime = departureTime
        self.currentStatus = currentStatus
    }
}

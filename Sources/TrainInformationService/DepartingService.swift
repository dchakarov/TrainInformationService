//
//  DepartingService.swift
//  TrainInformationService
//

import Foundation

public struct DepartingService: Codable {
	public let serviceId: String
	public let destination: String
	public let departureTime: String
	public let currentStatus: String
	public let delayReason: String?
    
    public init(serviceId: String, destination: String, departureTime: String, currentStatus: String, delayReason: String?) {
        self.serviceId = serviceId
        self.destination = destination
        self.departureTime = departureTime
        self.currentStatus = currentStatus
        self.delayReason = delayReason
    }
}

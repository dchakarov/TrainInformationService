//
//  CallingPoint.swift
//  TrainInformationService
//
//  Created by Dimitar Chakarov on 21/11/2018.
//  Copyright © 2018 Dimitar Chakarov. All rights reserved.
//

import Foundation

public struct CallingPoint: Codable {
	public let stationName: String
	public let stationCode: String
	public let departureTime: String
	public let currentStatus: String
}

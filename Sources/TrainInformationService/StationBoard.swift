//
//  StationBoard.swift
//  TrainInformationService
//

import Foundation

public struct StationBoard: Codable {
    public let generatedAt: Date
    public let locationName: String
    public let stationCode: String
    public let filterLocationName: String?
    public let filterStationCode: String?
    
    public let trainServices: [DepartingService]
    
    public init(generatedAt: Date, locationName: String, stationCode: String, filterLocationName: String?, filterStationCode: String?, trainServices: [DepartingService]) {
        self.generatedAt = generatedAt
        self.locationName = locationName
        self.stationCode = stationCode
        self.filterLocationName = filterLocationName
        self.filterStationCode = filterStationCode
        self.trainServices = trainServices
    }
}

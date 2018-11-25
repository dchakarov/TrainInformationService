//
//  TrainInformationService.swift
//  TrainInformationService
//
//  Created by Dimitar Chakarov on 21/11/2018.
//  Copyright © 2018 Dimitar Chakarov. All rights reserved.
//

import Foundation
import SWXMLHash

public enum Result<T> {
	case success(T)
	case error(Error)
}

public class TrainInformationService {
	let apiUrl: String
	let token: String
	let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
	var dataTask: URLSessionDataTask?
	
	public init(apiUrl: String, token: String) {
		self.apiUrl = apiUrl
		self.token = token
	}
	
	func executeSoapRequest(_ request: String, parameters: [String: String], completion: @escaping (Result<Data>) -> Void) {
		var paramLines = [String]()
		for (key, value) in parameters {
			paramLines.append("<ns1:\(key)>\(value)</ns1:\(key)>")
		}
		let paramString = paramLines.joined()
		let soapMessage = """
		<SOAP-ENV:Envelope
		xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"
		xmlns:ns1="http://thalesgroup.com/RTTI/2017-10-01/ldb/"
		xmlns:ns2="http://thalesgroup.com/RTTI/2010-11-01/ldb/commontypes">
		<SOAP-ENV:Header>
		<ns2:AccessToken>
		<ns2:TokenValue>\(token)</ns2:TokenValue>
		</ns2:AccessToken>
		</SOAP-ENV:Header>
		<SOAP-ENV:Body>
		<ns1:\(request)>\(paramString)</ns1:\(request)>
		</SOAP-ENV:Body>
		</SOAP-ENV:Envelope>
		"""
		let url = URL(string: apiUrl)
		var urlRequest = URLRequest(url: url!)
		urlRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
		urlRequest.addValue(String(soapMessage.count), forHTTPHeaderField: "Content-Length")
		urlRequest.httpMethod = "POST"
		urlRequest.httpBody = soapMessage.data(using: .utf8, allowLossyConversion: false)
		
		dataTask = defaultSession.dataTask(with: urlRequest) { data, _, error in
			if let error = error {
				completion(.error(error))
				return
			}
			if let data = data {
				completion(.success(data))
			}
		}
		dataTask?.resume()
	}
	
	public func departureBoard(for station: String, items: Int, completion: @escaping (Result<[DepartingService]>) -> Void) {
		let parameters = ["numRows": "\(items)", "crs": station]
		executeSoapRequest("GetDepartureBoardRequest", parameters: parameters) { result in
			switch result {
			case .success(let data):
				var board: [DepartingService] = []
				let xml = SWXMLHash.config { config in
					config.shouldProcessNamespaces = true
					}.parse(data)
				for service in xml["Envelope"]["Body"]["GetDepartureBoardResponse"]["GetStationBoardResult"]["trainServices"]["service"].all {
					var delayReason: String?
					let serviceId = service["serviceID"].element!.text
					let destination = service["destination"]["location"]["locationName"].element!.text
					let departureTime = service["std"].element!.text
					let currentStatus = service["etd"].element!.text
					if let reason = service["delayReason"].element?.text {
						delayReason = reason
					}
					let departingService = DepartingService(serviceId: serviceId, destination: destination, departureTime: departureTime, currentStatus: currentStatus, delayReason: delayReason)
					board.append(departingService)
				}
				completion(.success(board))
			case .error(let error):
				completion(.error(error))
			}
		}
	}
	
	public func serviceDetails(_ serviceID: String, completion: @escaping (Result<[CallingPoint]>) -> Void) {
		let parameters = ["serviceID": serviceID]
		executeSoapRequest("GetServiceDetailsRequest", parameters: parameters) { result in
			switch result {
			case .success(let data):
				var schedule: [CallingPoint] = []
				let xml = SWXMLHash.config { config in
					config.shouldProcessNamespaces = true
				}.parse(data)
				for callingPointItem in xml["Envelope"]["Body"]["GetServiceDetailsResponse"]["GetServiceDetailsResult"]["subsequentCallingPoints"]["callingPointList"]["callingPoint"].all {
					let stationName = callingPointItem["locationName"].element!.text
					let stationCode = callingPointItem["crs"].element!.text
					let departureTime = callingPointItem["st"].element!.text
					let currentStatus = callingPointItem["et"].element!.text
					let callingPoint = CallingPoint(stationName: stationName, stationCode: stationCode, departureTime: departureTime, currentStatus: currentStatus)
					schedule.append(callingPoint)
				}
				completion(.success(schedule))
			case .error(let error):
				completion(.error(error))
			}
		}
	}
}

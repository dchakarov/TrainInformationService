//
//  TrainInformationService.swift
//  TrainInformationService
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
                
//                print(xml)
                
                let currentLocation = xml["Envelope"]["Body"]["GetDepartureBoardResponse"]["GetStationBoardResult"]["locationName"].element!.text
				for service in xml["Envelope"]["Body"]["GetDepartureBoardResponse"]["GetStationBoardResult"]["trainServices"]["service"].all {
//                    print(service)
                    var delayReason, platform, cancelReason, via: String?
					let serviceId = service["serviceID"].element!.text
                    
                    // add via station if there is one. technically is route name not destination now 🤷🏻‍♂️
					let destination = service["destination"]["location"]["locationName"].element!.text
                    if let v = service["destination"]["location"]["via"].element?.text {
                        via = v.replacingOccurrences(of: "via ", with: "")
                    }
                    
                    let origin = service["origin"]["location"]["locationName"].element!.text
                    
					let departureTime = service["std"].element!.text
					let currentStatus = service["etd"].element!.text
                    
                    
					if let reason = service["delayReason"].element?.text {
						delayReason = reason
					}
                    if let plat = service["platform"].element?.text {
                        platform = plat
                    }
                    if let reason2 = service["cancelReason"].element?.text {
                        cancelReason = reason2
                    }
                    let operatingCompany = service["operator"].element!.text
                    let length = Int(service["length"].element?.text ?? "0")
                    
                    
                    let departingService = DepartingService(serviceId: serviceId, destination: destination, via: via, origin: origin, departureTime: departureTime, currentStatus: currentStatus, delayReason: delayReason, platform: platform, operatingCompany: operatingCompany, cancelReason: cancelReason, length: length ?? 0, currentLocation: currentLocation)
					board.append(departingService)
				}
				completion(.success(board))
			case .error(let error):
				completion(.error(error))
			}
		}
	}
	
	public func getUpcomingCallingPoints(_ serviceID: String, completion: @escaping (Result<[CallingPoint]>) -> Void) {
		let parameters = ["serviceID": serviceID]
		executeSoapRequest("GetServiceDetailsRequest", parameters: parameters) { result in
			switch result {
			case .success(let data):
				var schedule: [CallingPoint] = []
				let xml = SWXMLHash.config { config in
					config.shouldProcessNamespaces = true
				}.parse(data)
				for callingPointItem in xml["Envelope"]["Body"]["GetServiceDetailsResponse"]["GetServiceDetailsResult"]["subsequentCallingPoints"]["callingPointList"]["callingPoint"].all {
//                    print(callingPointItem)
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
    
    public func getPreviousCallingPoints(_ serviceID: String, completion: @escaping (Result<[CallingPoint]>) -> Void) {
        let parameters = ["serviceID": serviceID]
        executeSoapRequest("GetServiceDetailsRequest", parameters: parameters) { result in
            switch result {
            case .success(let data):
                var schedule: [CallingPoint] = []
                let xml = SWXMLHash.config { config in
                    config.shouldProcessNamespaces = true
                }.parse(data)
                for callingPointItem in xml["Envelope"]["Body"]["GetServiceDetailsResponse"]["GetServiceDetailsResult"]["previousCallingPoints"]["callingPointList"]["callingPoint"].all {
//                    print(callingPointItem)
                    let stationName = callingPointItem["locationName"].element!.text
                    let stationCode = callingPointItem["crs"].element!.text
                    let departureTime = callingPointItem["st"].element!.text
                    let currentStatus = callingPointItem["at"].element?.text ?? "On time"
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

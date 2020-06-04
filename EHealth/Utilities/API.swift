//
//  API.swift
//  EHealth
//
//  Created by Jon McLean on 1/6/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import UIKit
import Alamofire

class API {
    
    let baseUrl = "http://localhost:8080/"
    
    static let shared = API()
    
    private func determineSuccess(success: @escaping (Data) -> Void, failure: @escaping (Error?) -> Void, response: DataResponse<Data>) {
        if let code = response.response?.statusCode {
            if code == 200 {
                if let v = response.result.value {
                    success(v)
                }else {
                    print("failed to get value")
                    failure(nil)
                }
            }else {
                print(code)
                if let v = response.result.value {
                    print(String(data: v, encoding: .utf8))
                }
                failure(nil)
            }
        }else {
            failure(nil)
        }
    }
    
    func registerUser(email: String, password: String, firstName: String, lastName: String, phoneNumber: String, dob: Date, success: @escaping (Data) -> Void, failure: @escaping (Error?) -> Void) {
        let params = ["email":email, "password":password, "firstName":firstName, "lastName":lastName, "phone": phoneNumber, "dob":dob.timeIntervalSince1970 * 1000] as [String : Any]
        Alamofire.request(baseUrl + "user/register", method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            self.determineSuccess(success: success, failure: failure, response: dataResponse)
        }
    }
    
    func registerPatient(concessionType: ConcessionType, concessionNumber: String, medicareNumber: String, userId: Int, success: @escaping (Data) -> Void, failure: @escaping (Error?) -> Void) {
        var params : [String : Any]
        var url: String = baseUrl
        if concessionType != .none {
            url += "user/patient/concession/add"
            params = ["userId":userId, "medicareNumber":medicareNumber, "concessionType": concessionType.rawValue, "concessionNumber": concessionNumber]
        }else {
            url += "user/patient/add"
            params = ["userId": userId, "medicareNumber": medicareNumber]
        }
        
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            self.determineSuccess(success: success, failure: failure, response: dataResponse)
        }
    }
    
    func login(email: String, password: String, success: @escaping (Data) -> Void, failure: @escaping (Error?) -> Void) {
        let params: [String : Any ] = ["email": email, "password": password]
        
        Alamofire.request(baseUrl + "user/login", method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            self.determineSuccess(success: success, failure: failure, response: dataResponse)
        }
    }
    
    func getUser(userId: Int, success: @escaping (Data) -> Void, failure: @escaping (Error?) -> Void) {
        Alamofire.request(baseUrl + "user/\(userId)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            self.determineSuccess(success: success, failure: failure, response: dataResponse)
        }
    }
    
    func getPatient(userId: Int, success: @escaping (Data) -> Void, failure: @escaping (Error?) -> Void) {
        Alamofire.request(baseUrl + "user/patient/\(userId)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            self.determineSuccess(success: success, failure: failure, response: dataResponse)
        }
    }
    
    func getAppointmentsForDay(token: String, date: Date, success: @escaping (Data) -> Void, failure: @escaping (Error?) -> Void) {
        Alamofire.request(baseUrl + "appointment/find/patient/\(token)/\(Int(date.timeIntervalSince1970 * 1000))", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            self.determineSuccess(success: success, failure: failure, response: dataResponse)
        }
    }
    
    func getAppointmentsForPatient(token: String, success: @escaping (Data) -> Void, failure: @escaping (Error?) -> Void) {
        Alamofire.request(baseUrl + "appointment/find/patient/\(token)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            self.determineSuccess(success: success, failure: failure, response: dataResponse)
        }
    }
    
    func getDoctor(doctorId: Int, success: @escaping (Data) -> Void, failure: @escaping (Error?) -> Void) {
        Alamofire.request(baseUrl + "user/doctor/id/\(doctorId)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            self.determineSuccess(success: success, failure: failure, response: dataResponse)
        }
    }
    
    func getAllDoctors(success: @escaping (Data) -> Void, failure: @escaping (Error?) -> Void) {
        Alamofire.request(baseUrl + "user/doctor/all", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            self.determineSuccess(success: success, failure: failure, response: dataResponse)
        }
    }
    
    func getDoctorHours(doctorId: Int, success: @escaping (Data) -> Void, failure: @escaping (Error?) -> Void) {
        Alamofire.request(baseUrl + "availabiltity/hours/\(doctorId)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            self.determineSuccess(success: success, failure: failure, response: dataResponse)
        }
    }
    
    func registerDoctor(userId: Int, registration: String, success: @escaping (Data) -> Void, failure: @escaping (Error?) -> Void) {
        let params: [String : Any] = ["userId": userId, "registration": registration]
        Alamofire.request(baseUrl + "user/doctor/add", method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            self.determineSuccess(success: success, failure: failure, response: dataResponse)
        }
    }
    
    func createAppointment(token: String, doctorId: Int, startTimestamp: Int, success: @escaping (Data) -> Void, failure: @escaping (Error?) -> Void) {
        let params: [String : Any] = ["session": token, "doctor": doctorId, "startTimestamp": startTimestamp]
        Alamofire.request(baseUrl + "appointment/patient/create", method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            self.determineSuccess(success: success, failure: failure, response: dataResponse)
        }
    }
    
    func createAppointmentInfo(token: String, appointmentId: Int, description: String, mimeTypes: [String], success: @escaping (Data) -> Void, failure: @escaping (Error?) -> Void) {
        let params: [String: Any] = ["sessionToken": token, "appointmentId": appointmentId, "description": description, "image": mimeTypes[0]]
        Alamofire.request(baseUrl + "/appointment/info/add", method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            self.determineSuccess(success: success, failure: failure, response: dataResponse)
        }
    }
    
    func imageCallback(callbackUrl: String, success: @escaping (Data) -> Void, failure: @escaping (Error?) -> Void) {
        Alamofire.request("http://\(callbackUrl)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            self.determineSuccess(success: success, failure: failure, response: dataResponse)
        }
    }
    
    func createMessageGroup(direct: Bool, name: String, memberId: Int, token: String, appointmentId: Int, success: @escaping (Data) -> Void, failure: @escaping (Error?) -> Void) {
        let params: [String : Any] = ["direct": direct, "memberIds": memberId, "sessionToken": token, "name":name, "appointmentId": appointmentId]
        Alamofire.request(baseUrl + "message", method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            self.determineSuccess(success: success, failure: failure, response: dataResponse)
        }
    }
    
    func getAppointmentInfo(token: String, appointmentId: Int, success: @escaping (Data) -> Void, failure: @escaping (Error?) -> Void) {
        Alamofire.request(baseUrl + "appointment/info/get/\(token)/\(appointmentId)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            self.determineSuccess(success: success, failure: failure, response: dataResponse)
        }
    }
    
    func sendMessage(groupId: Int, token: String, content: String, success: @escaping (Data) -> Void, failure: @escaping (Error?) -> Void) {
        let params: [String : Any] = ["sessionToken": token, "content": content]
        Alamofire.request(baseUrl + "/message/\(groupId)/send", method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            self.determineSuccess(success: success, failure: failure, response: dataResponse)
        }
    }
    
    func getPrescriptions(token: String, success: @escaping (Data) -> Void, failure: @escaping (Error?) -> Void) {
        Alamofire.request(baseUrl + "/prescription/all/s/"+token, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            self.determineSuccess(success: success, failure: failure, response: dataResponse)
        }
    }
    
    func getMedication(medicationId: Int, success: @escaping (Data) -> Void, failure: @escaping (Error?) -> Void) {
        Alamofire.request(baseUrl + "/medication/\(medicationId)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            self.determineSuccess(success: success, failure: failure, response: dataResponse)
        }
    }
    
    func getUrgentCases(token: String, success: @escaping (Data) -> Void, failure: @escaping (Error?) -> Void) {
        Alamofire.request(baseUrl + "/urgent/all/s/\(token)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            self.determineSuccess(success: success, failure: failure, response: dataResponse)
        }
    }
    
    func postUrgentCase(token: String, description: String, mimeType: String, success: @escaping (Data) -> Void, failure: @escaping (Error?) -> Void) {
        let params = ["token": token, "description": description, "image": mimeType]
        Alamofire.request(baseUrl + "/urgent/submit", method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            self.determineSuccess(success: success, failure: failure, response: dataResponse)
        }
    }
    
    func getPatientForId(id: Int, success: @escaping (Data) -> Void, failure: @escaping (Error?) -> Void) {
        Alamofire.request(baseUrl + "user/patient/id/\(id)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            self.determineSuccess(success: success, failure: failure, response: dataResponse)
        }
    }
    
    func getDoctorFromId(userId: Int, success: @escaping (Data) -> Void, failure: @escaping (Error?) -> Void) {
        Alamofire.request(baseUrl + "user/doctor/\(userId)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            self.determineSuccess(success: success, failure: failure, response: dataResponse)
        }
    }
    
    func getAppointmentsForDoctor(doctorId: Int, success: @escaping (Data) -> Void, failure: @escaping (Error?) -> Void) {
        Alamofire.request(baseUrl + "/appointment/all/doctor/\(doctorId)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            self.determineSuccess(success: success, failure: failure, response: dataResponse)
        }
    }
    
    func getAppointmentsForDayForDoctor(token: String, date: Date, success: @escaping (Data) -> Void, failure: @escaping (Error?) -> Void) {
        Alamofire.request(baseUrl + "appointment/find/doctor/\(token)/\(Int(date.timeIntervalSince1970 * 1000))", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            self.determineSuccess(success: success, failure: failure, response: dataResponse)
        }
    }
    
    func getGroupForAppointment(appointmentId: Int, success: @escaping (Data) -> Void, failure: @escaping (Error?) -> Void) {
        Alamofire.request(baseUrl + "message/for/\(appointmentId)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            self.determineSuccess(success: success, failure: failure, response: dataResponse)
        }
    }
    
    func addMemberToGroup(groupId: Int, memberId: Int, token: String, success: @escaping (Data) -> Void, failure: @escaping (Error?) -> Void) {
        let params: [String : Any] = ["sessionToken": token]
        Alamofire.request(baseUrl + "message/\(groupId)/member/\(memberId)", method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            self.determineSuccess(success: success, failure: failure, response: dataResponse)
        }
    }
    
    func getPrescriptions(patientId: Int, success: @escaping (Data) -> Void, failure: @escaping (Error?) -> Void) {
        print(patientId)
        Alamofire.request(baseUrl + "prescription/all/p/\(patientId)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            self.determineSuccess(success: success, failure: failure, response: dataResponse)
        }
    }
    
    func createMedication(name: String, input: String, dosage: Double, dosageUnit: String, schedule: Int, success: @escaping (Data) -> Void, failure: @escaping (Error?) -> Void) {
        let params : [String : Any] = ["medicationName": name, "input": input, "dosage": dosage, "dosageUnit": dosageUnit, "schedule": schedule]
        Alamofire.request(baseUrl + "medication/add", method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            self.determineSuccess(success: success, failure: failure, response: dataResponse)
        }
    }
    
    func createPrescription(patientId: Int, medicationId: Int, frequency: Double, frequencyUnit: String, notes: String, token: String, success: @escaping (Data) -> Void, failure: @escaping (Error?) -> Void) {
        let params: [String : Any] = ["patientId": patientId, "medicationId": medicationId, "frequency": frequency, "frequencyUnit": frequencyUnit, "notes": notes, "sessionToken": token]
        Alamofire.request(baseUrl + "prescription/add", method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            self.determineSuccess(success: success, failure: failure, response: dataResponse)
        }
    }
    
    func getUnresolvedCaes(token: String, success: @escaping (Data) -> Void, failure: @escaping (Error?) -> Void) {
        Alamofire.request(baseUrl + "urgent/unresolved/\(token)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            self.determineSuccess(success: success, failure: failure, response: dataResponse)
        }
    }
    
    func resolveCase(caseId: Int, token: String, success: @escaping (Data) -> Void, failure: @escaping (Error?) -> Void) {
        let params: [String : Any] = ["token": token, "caseId": caseId]
        Alamofire.request(baseUrl + "urgent/resolve", method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            self.determineSuccess(success: success, failure: failure, response: dataResponse)
        }
    }
}

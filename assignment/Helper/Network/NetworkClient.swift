//
//  NetworkClient.swift
//  assignment
//
//  Created by Adarsh Sharma on 24/12/24.
//

import Foundation

class NetworkClient {
    static func request<T: Codable>(
        url: String,
        urlParams: [String: String]? = nil,
        headers: [String: String]? = nil,
        body: Data? = nil,
        method: String,
        responseModel: T.Type
    ) async throws -> T {
        // Construct the URL with parameters
        var urlComponents = URLComponents(string: url)
        if let urlParams = urlParams {
            urlComponents?.queryItems = urlParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let finalURL = urlComponents?.url else {
            throw APIError.invalidURL
        }
        
        // Create the request
        var request = URLRequest(url: finalURL)
        request.httpMethod = method
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        request.httpBody = body
        
        // Perform the request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check the response status code
        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            throw APIError.httpError(httpResponse.statusCode)
        }
        
        // Decode the response
        do {
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            return decodedResponse
        } catch {
            throw APIError.decodingError(error)
        }
    }
    
    // Define common API errors
    enum APIError: Error, LocalizedError {
        case invalidURL
        case httpError(Int)
        case noData
        case decodingError(Error)
        
        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "Invalid URL"
            case .httpError(let statusCode):
                return "HTTP error with status code \(statusCode)"
            case .noData:
                return "No data received"
            case .decodingError(let error):
                return "Decoding error: \(error.localizedDescription)"
            }
        }
    }
}

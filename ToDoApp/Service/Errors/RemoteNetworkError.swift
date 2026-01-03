//
//  RemoteNetworkError.swift
//  ToDoApp
//
//  Created by Hamid Mahmood on 12/31/25.
//

/// Network errors for remote operations.
enum RemoteNetworkError: Error, Equatable {

    /// Invalid request URL.
    case invalidURL

    /// Empty or corrupted response data.
    case invalidData

    /// Failed to decode response.
    case decodingFailed

    /// Response is not a valid HTTP response.
    case invalidResponse

    /// Server returned non-2xx status code.
    case invalidStatusCode(Int)

    /// User-facing error message.
    var errorMessage: String {
        switch self {
        case .invalidURL:
            return "We were unable to create a valid request. Please try again later."

        case .invalidData:
            return "The server returned incomplete or corrupted data."

        case .invalidResponse:
            return "We received an unexpected response from the server."

        case .decodingFailed:
            return "We couldn’t process the data received from the server."

        case .invalidStatusCode(let statusCode):
            return "The server responded with an unexpected status code (\(statusCode))."
        }
    }
}

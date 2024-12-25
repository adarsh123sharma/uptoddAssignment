//
//  ContentViewModel.swift
//  assignment
//
//  Created by Adarsh Sharma on 24/12/24.
//

import SwiftUI

class ContentViewModel: ObservableObject {
    @Published var dietResponse: Diets?
    @Published var errorString: String?
    
    func fetchData() async {
        do {
            let response: BaseResponse = try await NetworkClient.request(
                url: "https://uptodd.com/fetch-all-diets",
                method: "GET",
                responseModel: BaseResponse.self
            )
            await MainActor.run {
                if response.statusBoolean {
                    errorString = nil
                    dietResponse = response.data?.diets
                } else {
                    errorString = "API Failed"
                }
            }
        } catch {
            await MainActor.run {
                errorString = error.localizedDescription
            }
        }
    }
}

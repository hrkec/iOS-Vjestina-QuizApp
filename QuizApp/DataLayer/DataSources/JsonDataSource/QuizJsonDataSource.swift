import Foundation

struct QuizJsonDataSource: QuizJsonSourceProtocol {

    func fetchQuizzesFromJson() throws -> [Quiz] {
        guard let jsonURL = Bundle.main.url(forResource: "Restaurants", withExtension: "json") else {
            throw ParsingError.jsonNotFound
        }

        guard let jsonData = try? Data(contentsOf: jsonURL) else {
            throw ParsingError.failedToGetJsonData
        }

        let decodedData = try JSONDecoder().decode(Response.self, from: jsonData)
        return decodedData.restaurants
    }
    
}

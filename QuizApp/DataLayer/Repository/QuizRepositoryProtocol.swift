//
//  QuizRepositoryProtocol.swift
//  QuizApp
//
//  Created by Marin on 24.05.2021..
//

protocol QuizRepositoryProtocol {
    func fetchData(filter: FilterSettings) -> [Quiz]
    func deleteLocalData(withId id: Int)
}

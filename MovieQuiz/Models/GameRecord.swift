//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Сергей Андреев on 10.10.2022.
//

import Foundation

struct GameRecord: Codable, Comparable {
    
    let correct: Int
    let total: Int
    let date: Date
    
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        return lhs.correct < rhs.correct
    }
    func gameStatistics() -> String {
        return "\(correct)/\(total) \(date.dateTimeString)"
    }
}

//
//  NetworkRoutingProtocol.swift
//  MovieQuiz
//
//  Created by Сергей Андреев on 29.10.2022.
//

import Foundation

protocol NetworkRouting {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}

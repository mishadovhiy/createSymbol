//
//  Globals.swift
//  createSymbol
//
//  Created by Mikhailo Dovhyi on 12.02.2022.
//

import Foundation


class Globals {
    
    
    
    
    
}


extension String {
    func slice(from: String, to: String) -> String? {
        var text:String?
        let _ = (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                text = String(self[substringFrom..<substringTo])
            }
        }
        
        return text
    }
    
    func endIndex<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.upperBound
    }
}

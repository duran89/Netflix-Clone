//
//  Extensions.swift
//  Netflix Clone
//
//  Created by 권정근 on 3/5/24.
//

import Foundation


extension String {
    
    func capitalizeFirstLetter() -> String {
        
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
        
    }
}

//
//  LanguageTableViewCell.swift
//  Translator
//
//  Created by Alex on 8/29/20.
//  Copyright © 2020 Weekend. All rights reserved.
//

import UIKit

class LanguageTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var langIconImageView: UIImageView!
    @IBOutlet weak var langTitleLbl: UILabel!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    // MARK: - Setup UI
    
    private func setupUI(){
        backgroundColor = #colorLiteral(red: 0.0862745098, green: 0.1019607843, blue: 0.1137254902, alpha: 1)
        langTitleLbl.textColor = .white
        
        // Flag Image View
        langIconImageView.contentMode = .scaleAspectFit
    }

}

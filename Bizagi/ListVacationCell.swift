//
//  ListVacationCell.swift
//  Bizagi
//
//  Created by Edilberto Amado Perdomo on 23/08/17.
//  Copyright © 2017 Edilberto Amado Perdomo. All rights reserved.
//

import UIKit

class ListVacationCell: UITableViewCell {
    
    
    @IBOutlet weak var _NombreSolicitante: UILabel!
    @IBOutlet weak var _FechaDeA: UILabel!
    @IBOutlet weak var _CantidadDias: UILabel!
    @IBOutlet weak var _ImgEstado: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

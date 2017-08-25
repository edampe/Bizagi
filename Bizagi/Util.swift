//
//  Util.swift
//  Bizagi
//
//  Created by Edilberto Amado P on 25/08/17.
//  Copyright © 2017 Edilberto Amado Perdomo. All rights reserved.
//

import Foundation
import UIKit

class Util{
    
    // MARK: Custom functions
    
    /**
     * Funcion para mostrar el progress bar.
     */
    func progressBarDisplayer(_ msg:String, _ indicator:Bool, _ view: UIView ) {
        
        _StrLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
        _StrLabel.text = msg
        _StrLabel.textColor = UIColor.white
        _MessageFrame = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25 , width: 180, height: 50))
        _MessageFrame.layer.cornerRadius = 15
        _MessageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
        if indicator {
            _ActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
            _ActivityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            _ActivityIndicator.startAnimating()
            _MessageFrame.addSubview(_ActivityIndicator)
        }
        _MessageFrame.addSubview(_StrLabel)
        view.addSubview(_MessageFrame)
    }
    
    /**
     * Funcion para ocultar el progress bar.
     */
    func afterResponse(){
        _MessageFrame.removeFromSuperview()
    }
    
    
    /**
     * Funcion para calcular los dias de vacaciones basandose en la fecha de inicio y fin.
     */
    func calcularDias(position: Int, beginDate: String, endDate: String) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        let beginDate = dateFormatter.date(from: beginDate)
        let endDate = dateFormatter.date(from: endDate)
        
        let calendar = NSCalendar.current
        
        let fecha_desde = calendar.startOfDay(for: beginDate!)
        let fecha_hasta = calendar.startOfDay(for: endDate!)
        
        let dias = Set<Calendar.Component>([.day])
        let result = calendar.dateComponents(dias, from: fecha_desde as   Date,  to: fecha_hasta as Date)
        
        return String(describing: result.day!)
    }
    
    
}


//
//  Utils.swift
//  TestSiriProject
//
//  Created by hao.wang on 2021/5/14.
//

import Foundation

class Utils {
    
    public static func dispatch(_ time: Float, closure: @escaping () -> Void) {
        let t = time * Float(NSEC_PER_SEC)
        let _time = DispatchTime.now() + Double(Int64(UInt64(t))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: _time, execute: closure)
    }
    
    public static func dispatch(_ time: Double, closure: @escaping () -> Void) {
        dispatch(Float(time), closure: closure)
    }
    
    public static func dispatch(_ time: Int, closure: @escaping ()->Void) {
        dispatch(Float(time), closure: closure)
    }
    
}

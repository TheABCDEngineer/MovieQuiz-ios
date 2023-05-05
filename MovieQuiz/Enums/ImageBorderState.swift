import UIKit

enum ImageBorderState {
    case noBorders
    case correctUserResponse
    case incorrectUserResponse
    
    var values: (width: CGFloat, colour: CGColor) {
        switch self {
        case .noBorders: return (0,UIColor.ypBackground.cgColor)
        case .correctUserResponse: return (8, UIColor.ypGreen.cgColor)
        case .incorrectUserResponse: return (8, UIColor.ypRed.cgColor)
        }
    }
}

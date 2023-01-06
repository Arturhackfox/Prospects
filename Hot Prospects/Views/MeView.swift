//
//  MeView.swift
//  Hot Prospects
//
//  Created by Arthur Sh on 05.01.2023.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct MeView: View {
    @State private var name = "Anonnymous"
    @State private var email = "you@yourmail.com"
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        NavigationView{
            Form {
                Section{
                    TextField("Name", text: $name)
                    TextField("Email-address", text: $email)
                    
                    Image(uiImage: generateQrCode(from: "\(name)\n \(email)"))
                        .resizable()
                        .interpolation(.none)
                        .frame(width: 200, height: 200)
                }
            }
        }
    }
    
    func generateQrCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)
        
        if let outPutImage = filter.outputImage {
            if let cgimg = context.createCGImage(outPutImage, from: outPutImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        return UIImage(systemName: "plus") ?? UIImage()
    }
}

struct MeView_Previews: PreviewProvider {
    static var previews: some View {
        MeView()
    }
}

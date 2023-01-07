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
    @State private var qrCode = UIImage()
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        NavigationView{
            Form {
                Section{
                    TextField("Name", text: $name)
                    TextField("Email-address", text: $email)
                    
                    Image(uiImage: qrCode)
                        .resizable()
                        .interpolation(.none)
                        .frame(width: 200, height: 200)
                        .contextMenu{
                            Button{
                                let imageSaver = ImageSaver()
                                imageSaver.writeToPhotoAlbum(image: qrCode)
                            } label: {
                                Label("Save this picture", systemImage: "square.and.arrow.down")
                            }
                        }
                        .onAppear(perform: updateQr)
                        .onChange(of: name) { _ in updateQr()}
                        .onChange(of: email) { _ in updateQr()}
                        //MARK: on appear -> Make qr code
                        //MARK: on change of email or name -> Generate new qr code and stash it in qrCode property
                }
            }
        }
    }
    
    func updateQr() {
        qrCode = generateQrCode(from: "\(name)\n \(email)")
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

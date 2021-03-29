//
//  ImagePickerView.swift
//  AGM-Hodinkee
//
//  Created by Arturo Gamarra on 3/29/21.
//

import SwiftUI

struct ImagePickerView: UIViewControllerRepresentable {

    typealias UIViewControllerType = UIImagePickerController
    
    // MARK: - Properties
    @Environment(\.presentationMode) var presentationMode
    @Binding var imagen: UIImage?
    var sourceType: UIImagePickerController.SourceType
    
    func makeCoordinator() -> ImagePickerViewCoordinator {
        ImagePickerViewCoordinator(view: self)
    }
    
    // Se ejcuta cuando creamos el ViewController
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let pickerVC = UIImagePickerController()
        pickerVC.sourceType = .photoLibrary
        pickerVC.delegate = context.coordinator
        return pickerVC
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
}

class ImagePickerViewCoordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var view: ImagePickerView
    
    init(view: ImagePickerView) {
        self.view = view
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        view.presentationMode.wrappedValue.dismiss()
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            return
        }
        view.imagen = selectedImage
        view.presentationMode.wrappedValue.dismiss()
    }
}

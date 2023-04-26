import SwiftUI

struct UIImagePickerView: UIViewControllerRepresentable {
    @Binding var showSheet: Bool
    @Binding var image: UIImage?

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: UIImagePickerView

        init(_ parent: UIImagePickerView) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.editedImage] as? UIImage {
                parent.image = image
            } else if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.showSheet = true
        }

        // キャンセルボタンが押された際に呼ばれる
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.showSheet = false
        }
    }

    // Coordinatorを生成、SwiftUIによって自動的に呼びだし
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // View生成時に実行
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let viewController = UIImagePickerController()
        viewController.delegate = context.coordinator
        viewController.sourceType = .camera
        viewController.cameraFlashMode = .auto
        return viewController
    }

    // View更新時に実行
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) { }
}

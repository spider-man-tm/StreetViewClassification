import SwiftUI
import PhotosUI

struct PHPickerView: UIViewControllerRepresentable {
    @Binding var showSheet: Bool
    @Binding var image: UIImage?
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PHPickerView
        
        init(_ parent: PHPickerView) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            // 写真は１つだけ選択可能、最初の１件を指定
            if let result = results.first {
                // UIImage型の写真のみ非同期で取得
                result.itemProvider.loadObject(ofClass: UIImage.self) {
                    (image, error) in
                    // 写真が取得できた場合、選択された写真を親クラスのimageに代入
                    if let unwrapImage = image as? UIImage {
                        self.parent.image = unwrapImage
                    }
                }
                parent.showSheet = true
            } else {
                parent.showSheet = false
            }
        }
    }
    
    // Coordinatorを生成、SwiftUIによって自動的に呼びだし
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // Viewを生成するときに実行
    func makeUIViewController(
        context: UIViewControllerRepresentableContext<PHPickerView>)
        -> PHPickerViewController {
            var configuration = PHPickerConfiguration()
            configuration.filter = .images     // 静止画を選択
            configuration.selectionLimit = 1   // 選択可能枚数の上限
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = context.coordinator
            return picker
    }
    
    // Viewが更新されたときに実行
    func updateUIViewController(
        _ uiViewController: PHPickerViewController,
        context: UIViewControllerRepresentableContext<PHPickerView>) { }
}

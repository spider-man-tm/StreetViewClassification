import UIKit

extension UIImage {
    /// 画像を正方形にクリッピングする
    ///
    /// - Returns: クリッピングされた正方形の画像
    func cropping2square()-> UIImage!{
        let cgImage    = self.cgImage
        let width = (cgImage?.width)!
        let height = (cgImage?.height)!
        let resizeSize = min(height,width)
        let orientation = self.imageOrientation

        let cropCGImage = self.cgImage?.cropping(to: CGRect(x: (width - resizeSize) / 2, y: (height - resizeSize) / 2, width: resizeSize, height: resizeSize))

        let cropImage = UIImage(cgImage: cropCGImage!, scale: 0, orientation: orientation)
        return cropImage
    }
    
    private func min(_ a : Int, _ b : Int ) -> Int {
        if a < b { return a}
        else { return b}
    }
}

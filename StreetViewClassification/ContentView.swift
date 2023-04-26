import SwiftUI

struct ContentView: View {
    @State var image: UIImage? = nil      // 選択された写真
    @State var showSheet = false          // 各種シートの開閉状態を管理
    @State var showActionSheet = false    // アクションシートの開閉状態を管理
    @State var isCamera = false           // UIImagePickerControllerの使用
    @State var isLibrary = false          // PHPickerControllerの使用
    @State var finished = false           // 処理終了を示すステータス
    
    var body: some View {

        ZStack {
            BackgroundView()
            
            VStack {
                Spacer()
                Image("01-character")
                    .resizable()
                    .scaledToFit()
                Spacer()
                Button(action: {
                    image = nil             // imageを初期化
                    showActionSheet = true  // アクショシートを開く
                }) {
                    Text("写真を選択")
                        .frame(width: 200, height: 60)
                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.gray, lineWidth: 3))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.black)
                        .font(.title)
                }
                Spacer(minLength: 100)
            }
            
            // シート
            .fullScreenCover(isPresented: $showSheet) {
                if let unwrapCaptureImage = image {
                    if finished {
                        ClassficationView(showSheet: $showSheet, image: unwrapCaptureImage, finished: $finished)
                    } else {
                        SelectView(showSheet: $showSheet, image: $image, finished: $finished)
                    }
                } else {
                    if isCamera && !isLibrary {
                        UIImagePickerView(showSheet: $showSheet, image: $image)
                    } else if !isCamera && isLibrary {
                        PHPickerView(showSheet: $showSheet, image: $image)
                    }
                }
            }
            
            // アクションシート
            .actionSheet(isPresented: $showActionSheet) {
                ActionSheet(title: Text("写真の選択先を選んでください"),
                            message: Text("選択された写真データは外部に共有されません\nAI判定の処理はモバイル端末上のみで行います"),
                            buttons: [
                    .default(Text("カメラ"), action: {
                        // カメラが利用可能かチェック
                        if UIImagePickerController.isSourceTypeAvailable(.camera){
                            isCamera = true
                            isLibrary = false
                            showSheet = true
                        }
                    }),
                    .default(Text("フォトライブラリ"), action: {
                        isCamera = false
                        isLibrary = true
                        showSheet = true
                    }),
                    .cancel(),
                ])
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.portrait)
    }
}

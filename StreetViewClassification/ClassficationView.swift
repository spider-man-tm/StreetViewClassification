import SwiftUI
import CoreML
import Vision

struct ClassficationView: View {
    @State var cls = ["", "", "", "", ""]
    @State var prb = [0, 0, 0, 0, 0]
    
    @State private var currentIndex = 0
    @GestureState private var dragOffset: CGFloat = 0
    
    @Binding var showSheet: Bool     // シートの開閉状態を管理
    var image: UIImage               // 選択された写真
    @Binding var finished: Bool
    
    let itemPadding: CGFloat = 15
    
    // リクエストを作成
    func createClassificationRequest() -> VNCoreMLRequest {
        do {
            // モデルの設定
            let configuration = MLModelConfiguration()
            // モデル
            let model = try VNCoreMLModel(for: ResNext50_32x4d(configuration: configuration).model)
            // リクエスト
            let request = VNCoreMLRequest(model: model, completionHandler: { request, error in
                // 画像分類の処理
                performClassification(request: request)
            })
            return request

        } catch {
            fatalError("modelが読み込めません")
        }
    }
    
    // 画像分類の処理
    func performClassification(request: VNRequest) {
        // 結果を取得
        guard let results = request.results else {
            return
        }
        // [Any]から[VNClassificationObservation]にキャスト
        // 予測結果が高い方から順に配列に格納されている
        let classification = results as! [VNClassificationObservation]
        // 高い確率のクラスを取得
        for i in 0..<5 {
            cls[i] = classification[i].identifier
            prb[i] = Int(classification[i].confidence * 100)
        }
    }
    
    // 実際に画像を分類する
    func classifyImage(image: UIImage) {
        // 入力された画像の型をUIImageからCIImageに変換
        guard let ciImage = CIImage(image: image) else {
            fatalError("CIImageに変換できません")
        }
        // ハンドラを作る
        let handler = VNImageRequestHandler(ciImage: ciImage)
        // リクエストを作成
        let classificationRequest = createClassificationRequest()
        classificationRequest.imageCropAndScaleOption = .scaleFill
        // ハンドラを実行する
        do {
            try handler.perform([classificationRequest])
        } catch {
            fatalError("画像分類に失敗しました")
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack {
                    GeometryReader { bodyView in
                        LazyHStack(spacing: itemPadding) {
                            ForEach(0..<5) { idx in
                                let cityImage = pickupCityImage(cityName: cls[idx])
                                
                                VStack {
                                    Text("\(cls[idx])っぽさ  \(prb[idx])%")
                                       .frame(maxWidth: .infinity, alignment: .center)
                                       .font(.title)
                                       .foregroundColor(Color.black)
                                       .frame(width: bodyView.size.width * 0.8, height: 90)
                                       .border(Color.brown, width: 3)
                                       .padding(.leading, idx == 0 ? bodyView.size.width * 0.1 : 0)
                                    
                                    cityImage
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: bodyView.size.width * 0.8, height: bodyView.size.width * 0.8)
                                        .border(Color.gray, width:0.5)
                                        .clipped()
                                        .padding(.leading, idx == 0 ? bodyView.size.width * 0.1 : 0)
                                }
                                .onAppear {
                                    classifyImage(image: image)
                                }
                            }
                        }
                        .offset(x: self.dragOffset)
                        .offset(x: -CGFloat(self.currentIndex) * (bodyView.size.width * 0.8 + itemPadding))
                        .gesture(
                            DragGesture()
                                .updating(self.$dragOffset, body: { (value, state, _) in
                                    // 先頭・末尾ではスクロールする必要がないので、画面サイズの1/5までドラッグで制御する
                                    if self.currentIndex == 0, value.translation.width > 0 {
                                        state = value.translation.width / 5
                                    } else if self.currentIndex == (self.cls.count - 1), value.translation.width < 0 {
                                        state = value.translation.width / 5
                                    } else {
                                        state = value.translation.width
                                    }
                                })
                                .onEnded({ value in
                                    var newIndex = self.currentIndex
                                    // ドラッグ幅からページングを判定
                                    if abs(value.translation.width) > bodyView.size.width * 0.3 {
                                        newIndex = value.translation.width > 0 ? self.currentIndex - 1 : self.currentIndex + 1
                                    }

                                    // 最小ページ、最大ページを超えないようチェック
                                    if newIndex < 0 {
                                        newIndex = 0
                                    } else if newIndex > (self.cls.count - 1) {
                                        newIndex = self.cls.count - 1
                                    }

                                    self.currentIndex = newIndex
                                })
                        )
                    }
                    .animation(.interpolatingSpring(mass: 0.6, stiffness: 150, damping: 80, initialVelocity: 0.1))

                    Button(action: {
                        showSheet = false
                        finished = false
                    }) {
                        Text("ホーム")
                            .padding()
                            .frame(width: 200, height: 60)
                            .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.gray, lineWidth: 3))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.black)
                            .font(.title)
                    }
                     .padding()
                    Spacer(minLength: 130)
                }
            }
        }
    }
}

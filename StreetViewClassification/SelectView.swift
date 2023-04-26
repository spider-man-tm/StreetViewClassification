import SwiftUI

struct SelectView: View {
    @Binding var showSheet: Bool     // シートの開閉状態を管理
    @Binding var image: UIImage?     // 選択された写真
    @Binding var finished: Bool      // 画像分類処理へ進むかどうか
    @State var showImage: UIImage?   // 表示する写真
    @State var showIndicator = false
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack {
                    Spacer()
                    Image("01-bar-1")
                        .resizable()
                        .scaledToFit()
                    if let unwrapShowImage = showImage {
                        Image(uiImage: unwrapShowImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .border(Color.gray, width:0.5)
                            .padding()
                    }
                    Image("01-bar-2")
                        .resizable()
                        .scaledToFit()
                    Spacer()
                    // 選択した写真で画像分類に進む
                    Button(action: {
                        showIndicator = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            showSheet = true
                            finished = true
                        }
                    }) {
                        Text("スタート")
                            .padding()
                            .frame(width: 200, height: 60)
                            .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.gray, lineWidth: 3))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.black)
                            .font(.title)
                    }
                    .padding()
                    
                    .navigationBarItems(
                        leading: Button(action: {
                            showSheet = true
                            finished = false
                            image = nil
                        }) {
                            Image(systemName: "arrowshape.turn.up.left")
                                .font(.headline)
                                .foregroundColor(Color.black)
                        },
                        trailing: Button(action: {
                            showSheet = false
                            finished = false
                            image = nil
                        }) {
                            Text("ホーム")
                                .font(.headline)
                                .foregroundColor(Color.black)
                        }
                    )
                    Spacer(minLength: 130)
                }
                
                if showIndicator {
                    ProgressView()
                    CustomActivityIndicator()
                }
            }
        }
        // シートが表示されるときに実行される
        .onAppear {
            // 正方形にクロップ
            image = image!.cropping2square()
            showImage = image
        }
    }
}

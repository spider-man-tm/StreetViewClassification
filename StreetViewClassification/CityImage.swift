import SwiftUI

func pickupCityImage(cityName: String) -> Image {
    switch cityName {
    case "千代田区":
        return Image("chiyoda")
    case "中央区":
        return Image("chuo")
    case "港区":
        return Image("minato")
    case "新宿区":
        return Image("shinjuku")
    case "文京区":
        return Image("bunkyo")
    case "台東区":
        return Image("taito")
    case "墨田区":
        return Image("sumida")
    case "江東区":
        return Image("koto")
    case "品川区":
        return Image("shinagawa")
    case "目黒区":
        return Image("meguro")
    case "大田区":
        return Image("ota")
    case "世田谷区":
        return Image("setagaya")
    case "渋谷区":
        return Image("shibuya")
    case "中野区":
        return Image("nakano")
    case "杉並区":
        return Image("suginami")
    case "豊島区":
        return Image("toshima")
    case "北区":
        return Image("kita")
    case "荒川区":
        return Image("arakawa")
    case "板橋区":
        return Image("itabashi")
    case "練馬区":
        return Image("nerima")
    case "足立区":
        return Image("adachi")
    case "葛飾区":
        return Image("katsushika")
    case "江戸川区":
        return Image("edogawa")
    default:
        return Image("shibuya")
    }
}

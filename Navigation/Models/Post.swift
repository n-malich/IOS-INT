//
//  Post.swift
//  Navigation
//
//  Created by Natali Malich
//

import Foundation
import iOSIntPackage
import UIKit

struct Post {
    var id: UUID
    var author: String
    var description: String?
    var image: UIImage?
    var filter: ColorFilter?
    var likes: Int
    var views: Int
}

class Posts {
    var postsArray =
    [
        Post(id: UUID(),
             author: "Пикабу",
             description: "Во время уборки пляжа волонтеры и работники обычно собирают крупные отходы, например пластиковые бутылки или упаковку. Но песок часто захламляют более мелкими фрагментами пластика, окурками, обломками контейнеров и стаканчиков. Отсеивать такие кусочки пластика от песка — это гигантская задача. Новый робот под названием BeBot разработан, чтобы помочь собрать эти мелкие пластиковые отходы.",
             //image: "4ocean",
             image: UIImage(named: "4ocean"),
//             filter: .bloom(intensity: 0.8),
             filter: nil,
             likes: 166,
             views: 35000),
        Post(id: UUID(),
             author: "Rock Collections",
             description: "Scorpions — легендарная немецкая рок-группа, основана в 1965 году в Ганновере. Для стиля группы были характерны как классический рок, так и лирические гитарные баллады. Является cамой популярной рок-группой Германии и одной из самых известных групп на мировой рок- сцене, продавшей более 100 миллионов копий альбомов.",
             //image: "scorpions",
             image: UIImage(named: "scorpions"),
//             filter: .sepia(intensity: 0.8),
             filter: nil,
             likes: 47,
             views: 2000),
        Post(id: UUID(),
             author: "Лепра",
             description: "«Я пpocтo жapил pыбoв нa гpилe нa зaднeм двope, кaк вдpyг пoявилcя oн».",
             //image: "cat",
             image: UIImage(named: "cat"),
//             filter: .fade,
             filter: nil,
             likes: 2144,
             views: 89000),
        Post(id: UUID(),
             author: "BOOMTS - Мягкие игрушки",
             description: """
               Встречайте! Милый, нежный, голубоглазый baby-осьминожка. Он так и просится, чтобы его взяли на ручки.
               Создан с заботой и любовью из меха цвета «Сакура».У нас в наличии есть 20 штук безумно милых baby-осьминожек, которые растопят сердца даже самых брутальных парней.
               Не бойтесь потерять этого милашку из вида, ведь в его брюшко вшит магнит. С его помощью вы сможете прикреплять baby-осьминожку ко всем металлическим предметам. Так вы не упустите его из виду, а он в свою очередь будет радовать глаз и согревать сердца.
               Цена: 1490₽. Принимаем предзаказы на нежного baby-осьминожку в Direct.
               """,
             //image: "toy",
             image: UIImage(named: "toy"),
//             filter: .colorInvert,
             filter: nil,
             likes: 522,
             views: 27000)
    ]
}

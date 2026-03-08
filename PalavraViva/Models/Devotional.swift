import Foundation

nonisolated struct Devotional: Identifiable, Sendable {
    let id: String
    let title: String
    let scripture: String
    let scriptureReference: String
    let reflection: String
    let prayer: String
    let theme: String
}

nonisolated enum DevotionalProvider: Sendable {
    static func todaysDevotional() -> Devotional {
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let index = (dayOfYear - 1) % devotionals.count
        return devotionals[index]
    }

    static let devotionals: [Devotional] = [
        Devotional(
            id: "dev-1",
            title: "Confiando no Plano de Deus",
            scripture: "Porque eu bem sei os planos que tenho a vosso favor, diz o Senhor; planos de paz e no de mal, para vos dar o fim que desejais.",
            scriptureReference: "Jeremias 29:11",
            reflection: "Muitas vezes nos sentimos perdidos, sem saber qual caminho seguir. Mas Deus nos assegura que Ele tem um plano perfeito para cada um de ns. Mesmo quando as circunstncias parecem confusas, podemos descansar na certeza de que o Senhor est no controle. Seus planos so sempre de paz, nunca de mal. Ele deseja nos dar esperana e um futuro cheio de propsito. Hoje, entregue suas preocupaes a Ele e confie que cada passo est sendo guiado por mos amorosas.",
            prayer: "Senhor, ajuda-me a confiar nos Teus planos, mesmo quando no consigo enxergar o caminho. Sei que Tu s fiel e que cuidas de mim. Entrego meu futuro em Tuas mos. Amm.",
            theme: "Confiana"
        ),
        Devotional(
            id: "dev-2",
            title: "Fora na Fraqueza",
            scripture: "Tudo posso naquele que me fortalece.",
            scriptureReference: "Filipenses 4:13",
            reflection: "Paulo escreveu estas palavras de dentro de uma priso. Ele no estava em um momento de vitria visvel, mas de aparente derrota. Mesmo assim, declarou que tudo podia em Cristo. A fora de Deus se aperfeioa em nossa fraqueza. Quando voc sentir que no tem mais foras para continuar, lembre-se: no pela sua capacidade, mas pelo poder dAquele que vive em voc. Cada desafio  uma oportunidade para experimentar a suficincia da graa divina.",
            prayer: "Pai, quando me sentir fraco, lembra-me de que a Tua fora  perfeita em minha fraqueza. Que eu dependa de Ti em todos os momentos. Amm.",
            theme: "Fora"
        ),
        Devotional(
            id: "dev-3",
            title: "O Pastor que Cuida",
            scripture: "O Senhor  o meu pastor; nada me faltar. Ele me faz repousar em pastos verdejantes. Leva-me para junto das guas de descanso.",
            scriptureReference: "Salmos 23:1-2",
            reflection: "Imagine um pastor cuidando de suas ovelhas com carinho e dedicao. Assim  o nosso Deus conosco. Ele nos guia a lugares de descanso, nos alimenta e nos protege. Em meio  correria do dia a dia, muitas vezes esquecemos de parar e descansar na presena dEle. Hoje, permita-se ser cuidado pelo Bom Pastor. Ele conhece suas necessidades antes mesmo de voc express-las. Descanse nEle.",
            prayer: "Senhor, Tu s o meu Pastor. Guia-me aos pastos verdejantes e s guas tranquilas. Que eu encontre descanso em Tua presena hoje. Amm.",
            theme: "Descanso"
        ),
        Devotional(
            id: "dev-4",
            title: "No Tenha Medo",
            scripture: "No temas, porque eu sou contigo; no te assombres, porque eu sou o teu Deus; eu te fortaleo, e te ajudo, e te sustento com a minha destra fiel.",
            scriptureReference: "Isaas 41:10",
            reflection: "O medo  um dos maiores inimigos da f. Ele nos paralisa, rouba nossa paz e nos faz esquecer das promessas de Deus. Mas o Senhor nos diz com clareza: No temas. No  um pedido, mas uma ordem baseada em uma promessa - Ele est conosco. Sua mo direita de justia nos sustenta. Qualquer que seja o medo que voc carrega hoje, entregue-o ao Senhor. Ele  maior que qualquer circunstncia.",
            prayer: "Deus, remove todo medo do meu corao. Que eu sinta a Tua presena real e poderosa em cada momento de incerteza. Amm.",
            theme: "Coragem"
        ),
        Devotional(
            id: "dev-5",
            title: "Amor Inseparvel",
            scripture: "Porque eu estou bem certo de que nem a morte, nem a vida, nem os anjos, nem os principados, nem as coisas do presente, nem do porvir, nem os poderes, nem a altura, nem a profundidade, nem qualquer outra criatura poder separar-nos do amor de Deus, que est em Cristo Jesus, nosso Senhor.",
            scriptureReference: "Romanos 8:38-39",
            reflection: "Existe um amor que nunca falha, nunca desiste e nunca se cansa de ns. O amor de Deus  incondicional e eterno. Nada neste mundo - nenhuma circunstncia, nenhum erro, nenhuma fora -  capaz de nos separar desse amor. Nos dias em que voc se sentir indigno ou distante, lembre-se: o amor de Deus no depende do que voc faz, mas de quem Ele . E Ele  amor.",
            prayer: "Pai, obrigado pelo Teu amor incondicional. Que eu viva cada dia na certeza de que nada pode me separar de Ti. Amm.",
            theme: "Amor"
        ),
        Devotional(
            id: "dev-6",
            title: "Sabedoria do Alto",
            scripture: "Confia no Senhor de todo o teu corao e no te estribes no teu prprio entendimento. Reconhece-o em todos os teus caminhos, e ele endireitar as tuas veredas.",
            scriptureReference: "Provrbios 3:5-6",
            reflection: "Vivemos em um mundo que valoriza a autossuficincia e o conhecimento prprio. Mas a verdadeira sabedoria comea quando reconhecemos que precisamos de Deus. Confiar de todo o corao significa no reservar uma parte para o nosso controle. Quando entregamos completamente nossos caminhos ao Senhor, Ele promete direcionar nossos passos. Hoje, em cada deciso que tomar, pare e pergunte: Senhor, qual  o Teu caminho?",
            prayer: "Senhor, ensina-me a confiar inteiramente em Ti. Direciona meus passos e d-me sabedoria para cada deciso. Amm.",
            theme: "Sabedoria"
        ),
        Devotional(
            id: "dev-7",
            title: "O Amor que Transforma",
            scripture: "Porque Deus amou ao mundo de tal maneira que deu o seu Filho unignito, para que todo o que nele cr no perea, mas tenha a vida eterna.",
            scriptureReference: "Joo 3:16",
            reflection: "Este  talvez o versculo mais conhecido da Bblia, mas sua profundidade  inesgotvel. Deus no apenas nos amou com palavras - Ele demonstrou Seu amor com a maior ao possvel: deu Seu prprio Filho. Esse amor no  abstrato; ele  concreto, sacrificial e transformador. Quando voc meditar sobre este versculo hoje, deixe que a realidade do amor de Deus penetre cada rea da sua vida e transforme a forma como voc v a si mesmo e aos outros.",
            prayer: "Obrigado, Senhor, pelo sacrifcio do Teu Filho. Que o Teu amor transforme meu corao e transborde para as pessoas ao meu redor. Amm.",
            theme: "Graa"
        ),
    ]
}

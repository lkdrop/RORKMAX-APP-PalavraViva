import Foundation

nonisolated struct ReadingPlan: Identifiable, Sendable {
    let id: String
    let title: String
    let description: String
    let category: PlanCategory
    let totalDays: Int
    let days: [PlanDay]
    let rating: Double
    let imageURL: String?
    let author: String
}

nonisolated struct PlanDay: Identifiable, Sendable {
    let id: String
    let dayNumber: Int
    let tasks: [PlanTask]
}

nonisolated struct PlanTask: Identifiable, Sendable {
    let id: String
    let title: String
    let type: PlanTaskType
    let content: String
}

nonisolated enum PlanTaskType: String, Sendable {
    case devotional
    case scripture
}

nonisolated enum PlanCategory: String, CaseIterable, Sendable {
    case amor = "Amor"
    case cura = "Cura"
    case esperanca = "Esperança"
    case ansiedade = "Ansiedade"
    case raiva = "Raiva"
    case depressao = "Depressão"
    case fe = "Fé"
    case familia = "Família"
    case oracao = "Oração"

    var icon: String {
        switch self {
        case .amor: return "heart.fill"
        case .cura: return "cross.vial.fill"
        case .esperanca: return "sun.max.fill"
        case .ansiedade: return "wind"
        case .raiva: return "flame.fill"
        case .depressao: return "cloud.rain.fill"
        case .fe: return "sparkles"
        case .familia: return "figure.2.and.child.holdinghands"
        case .oracao: return "hands.sparkles.fill"
        }
    }

    var gradientColors: (start: String, end: String) {
        switch self {
        case .amor: return ("#E84855", "#C62839")
        case .cura: return ("#5BA88D", "#3D7A62")
        case .esperanca: return ("#F4A261", "#E07B3A")
        case .ansiedade: return ("#7B68AE", "#5A4B8A")
        case .raiva: return ("#D64045", "#A33035")
        case .depressao: return ("#6C7B95", "#4A5568")
        case .fe: return ("#D4A05A", "#B8862D")
        case .familia: return ("#4ECDC4", "#36B3AA")
        case .oracao: return ("#9B7ED8", "#7B5EB8")
        }
    }
}

nonisolated enum ReadingPlanProvider: Sendable {
    static func plans(for category: PlanCategory) -> [ReadingPlan] {
        switch category {
        case .amor:
            return amorPlans
        case .cura:
            return curaPlans
        case .esperanca:
            return esperancaPlans
        case .ansiedade:
            return ansiedadePlans
        case .raiva:
            return raivaPlans
        case .depressao:
            return depressaoPlans
        case .fe:
            return fePlans
        case .familia:
            return familiaPlans
        case .oracao:
            return oracaoPlans
        }
    }

    static let amorPlans: [ReadingPlan] = [
        makePlan(id: "amor-1", title: "O Amor que Nunca Falha", desc: "Descubra a profundidade do amor incondicional de Deus e como ele transforma relacionamentos.", category: .amor, days: 7, rating: 4.9, author: "Palavra Viva"),
        makePlan(id: "amor-2", title: "Amar Como Cristo Amou", desc: "Aprenda a amar como Jesus ensinou através de exemplos práticos.", category: .amor, days: 5, rating: 4.8, author: "Palavra Viva"),
        makePlan(id: "amor-3", title: "Restaurando Relacionamentos", desc: "Um guia bíblico para curar feridas e restaurar laços quebrados.", category: .amor, days: 10, rating: 5.0, author: "Palavra Viva"),
        makePlan(id: "amor-4", title: "Amor e Perdão", desc: "A conexão inseparável entre amar verdadeiramente e perdoar.", category: .amor, days: 4, rating: 4.7, author: "Palavra Viva"),
        makePlan(id: "amor-5", title: "O Maior Mandamento", desc: "Mergulhe no mandamento de amar a Deus sobre todas as coisas.", category: .amor, days: 6, rating: 4.9, author: "Palavra Viva"),
    ]

    static let curaPlans: [ReadingPlan] = [
        makePlan(id: "cura-1", title: "Cura Interior pela Palavra", desc: "Encontre restauração emocional e espiritual através das Escrituras.", category: .cura, days: 7, rating: 5.0, author: "Palavra Viva"),
        makePlan(id: "cura-2", title: "Do Pecado à Redenção", desc: "O caminho da cura começa com o reconhecimento e a graça.", category: .cura, days: 4, rating: 4.8, author: "Palavra Viva"),
        makePlan(id: "cura-3", title: "Restauração Completa", desc: "Deus quer curar cada área da sua vida – corpo, alma e espírito.", category: .cura, days: 6, rating: 4.9, author: "Palavra Viva"),
        makePlan(id: "cura-4", title: "Além das Feridas", desc: "Transforme suas cicatrizes em testemunhos de vitória.", category: .cura, days: 12, rating: 5.0, author: "Palavra Viva"),
        makePlan(id: "cura-5", title: "O Toque do Mestre", desc: "Jesus continua curando hoje. Descubra como receber Sua cura.", category: .cura, days: 7, rating: 4.7, author: "Palavra Viva"),
    ]

    static let esperancaPlans: [ReadingPlan] = [
        makePlan(id: "esp-1", title: "Esperança em Tempos Difíceis", desc: "Quando tudo parece perdido, a Palavra de Deus renova a esperança.", category: .esperanca, days: 7, rating: 5.0, author: "Palavra Viva"),
        makePlan(id: "esp-2", title: "Promessas de Deus", desc: "Cada promessa de Deus é sim e amém em Cristo Jesus.", category: .esperanca, days: 5, rating: 4.9, author: "Palavra Viva"),
        makePlan(id: "esp-3", title: "Um Novo Amanhã", desc: "As misericórdias do Senhor se renovam a cada manhã.", category: .esperanca, days: 3, rating: 4.8, author: "Palavra Viva"),
    ]

    static let ansiedadePlans: [ReadingPlan] = [
        makePlan(id: "ans-1", title: "Em Dias Difíceis", desc: "Encontre paz e serenidade quando a ansiedade bater à porta.", category: .ansiedade, days: 7, rating: 5.0, author: "Palavra Viva"),
        makePlan(id: "ans-2", title: "Paz que Excede o Entendimento", desc: "A paz de Deus guarda seu coração e mente em Cristo.", category: .ansiedade, days: 4, rating: 4.9, author: "Palavra Viva"),
        makePlan(id: "ans-3", title: "Confiando no Caminho", desc: "Aprenda a entregar suas preocupações nas mãos de Deus.", category: .ansiedade, days: 5, rating: 5.0, author: "Palavra Viva"),
        makePlan(id: "ans-4", title: "Descansando em Deus", desc: "O verdadeiro descanso vem quando confiamos plenamente no Senhor.", category: .ansiedade, days: 3, rating: 4.8, author: "Palavra Viva"),
        makePlan(id: "ans-5", title: "Blindando a Mente", desc: "Proteja seus pensamentos com a armadura de Deus.", category: .ansiedade, days: 7, rating: 4.9, author: "Palavra Viva"),
    ]

    static let raivaPlans: [ReadingPlan] = [
        makePlan(id: "rai-1", title: "Vencendo a Raiva", desc: "Estratégias bíblicas para lidar com a ira de forma saudável.", category: .raiva, days: 3, rating: 4.8, author: "Palavra Viva"),
        makePlan(id: "rai-2", title: "O Poder do Perdão", desc: "Liberte-se das correntes da amargura através do perdão.", category: .raiva, days: 5, rating: 5.0, author: "Palavra Viva"),
        makePlan(id: "rai-3", title: "Quando a Mágoa Aprisiona", desc: "Quebre as prisões emocionais que a mágoa constrói.", category: .raiva, days: 5, rating: 4.9, author: "Palavra Viva"),
        makePlan(id: "rai-4", title: "Lidando com as Frustrações", desc: "Aprenda a transformar frustrações em oportunidades de crescimento.", category: .raiva, days: 7, rating: 5.0, author: "Palavra Viva"),
    ]

    static let depressaoPlans: [ReadingPlan] = [
        makePlan(id: "dep-1", title: "Você Não Está Só", desc: "Deus está ao seu lado mesmo nos momentos mais escuros.", category: .depressao, days: 6, rating: 5.0, author: "Palavra Viva"),
        makePlan(id: "dep-2", title: "Fortalecendo a Mente", desc: "Renove seus pensamentos com a verdade das Escrituras.", category: .depressao, days: 7, rating: 4.9, author: "Palavra Viva"),
        makePlan(id: "dep-3", title: "Luz na Escuridão", desc: "Cristo é a luz que brilha mesmo nas trevas mais profundas.", category: .depressao, days: 5, rating: 5.0, author: "Palavra Viva"),
        makePlan(id: "dep-4", title: "Rejeitando as Migalhas", desc: "Você foi criado para viver em abundância, não em escassez.", category: .depressao, days: 5, rating: 4.8, author: "Palavra Viva"),
    ]

    static let fePlans: [ReadingPlan] = [
        makePlan(id: "fe-1", title: "Fé Inabalável", desc: "Construa uma fé que resiste às tempestades da vida.", category: .fe, days: 7, rating: 5.0, author: "Palavra Viva"),
        makePlan(id: "fe-2", title: "Heróis da Fé", desc: "Inspire-se nos grandes exemplos de fé da Bíblia.", category: .fe, days: 10, rating: 4.9, author: "Palavra Viva"),
        makePlan(id: "fe-3", title: "Primeiros Passos na Fé", desc: "Um guia para quem está começando sua jornada com Deus.", category: .fe, days: 15, rating: 5.0, author: "Palavra Viva"),
    ]

    static let familiaPlans: [ReadingPlan] = [
        makePlan(id: "fam-1", title: "Família Segundo o Coração de Deus", desc: "Princípios bíblicos para fortalecer os laços familiares.", category: .familia, days: 7, rating: 5.0, author: "Palavra Viva"),
        makePlan(id: "fam-2", title: "Educando com Sabedoria", desc: "Criando filhos à luz da Palavra de Deus.", category: .familia, days: 5, rating: 4.8, author: "Palavra Viva"),
        makePlan(id: "fam-3", title: "Casamento Abençoado", desc: "Fortalecendo o casamento através dos princípios de Deus.", category: .familia, days: 6, rating: 4.9, author: "Palavra Viva"),
    ]

    static let oracaoPlans: [ReadingPlan] = [
        makePlan(id: "ora-1", title: "Aprendendo a Orar", desc: "Desenvolva uma vida de oração poderosa e transformadora.", category: .oracao, days: 7, rating: 5.0, author: "Palavra Viva"),
        makePlan(id: "ora-2", title: "Orações que Tocam o Céu", desc: "Descubra o segredo das orações que movem o coração de Deus.", category: .oracao, days: 5, rating: 4.9, author: "Palavra Viva"),
        makePlan(id: "ora-3", title: "Jejum e Oração", desc: "O poder da combinação entre jejum e oração.", category: .oracao, days: 4, rating: 4.8, author: "Palavra Viva"),
    ]

    private static func makePlan(id: String, title: String, desc: String, category: PlanCategory, days: Int, rating: Double, author: String) -> ReadingPlan {
        let planDays = (1...days).map { dayNum in
            PlanDay(
                id: "\(id)-day-\(dayNum)",
                dayNumber: dayNum,
                tasks: makeTasksForDay(planId: id, dayNumber: dayNum, category: category)
            )
        }
        return ReadingPlan(
            id: id,
            title: title,
            description: desc,
            category: category,
            totalDays: days,
            days: planDays,
            rating: rating,
            imageURL: nil,
            author: author
        )
    }

    private static func makeTasksForDay(planId: String, dayNumber: Int, category: PlanCategory) -> [PlanTask] {
        let devotionalContent = devotionalContentFor(category: category, day: dayNumber)
        let scriptures = scripturesFor(category: category, day: dayNumber)

        var tasks: [PlanTask] = [
            PlanTask(
                id: "\(planId)-day\(dayNumber)-dev",
                title: "Devocional",
                type: .devotional,
                content: devotionalContent
            )
        ]

        for (index, scripture) in scriptures.enumerated() {
            tasks.append(PlanTask(
                id: "\(planId)-day\(dayNumber)-scr\(index)",
                title: scripture,
                type: .scripture,
                content: scripture
            ))
        }

        return tasks
    }

    private static func devotionalContentFor(category: PlanCategory, day: Int) -> String {
        switch category {
        case .amor:
            let contents = [
                "O amor de Deus é a base de toda a existência. Antes mesmo de formarmos nosso primeiro pensamento, Ele já nos amava com amor eterno. Jeremias 31:3 nos diz: \"Com amor eterno te amei; por isso, com benignidade te atraí.\" Esse amor não depende do que fazemos ou deixamos de fazer. É um amor que escolhe, que persiste, que nunca desiste.\n\nQuando entendemos a profundidade desse amor, nossa vida começa a se transformar de dentro para fora. Não precisamos mais buscar aprovação, porque já somos aprovados. Não precisamos mais temer rejeição, porque já somos aceitos.\n\nHoje, permita que essa verdade penetre cada área do seu coração: você é amado — não pelo que faz, mas por quem Deus é.",
                "Amar como Cristo amou exige entrega total. Em João 15:12-13, Jesus disse: \"O meu mandamento é este: Amem-se uns aos outros como eu os amei. Ninguém tem maior amor do que aquele que dá a sua vida pelos seus amigos.\"\n\nEsse amor não é apenas sentimento — é ação. É escolher servir quando queremos ser servidos. É perdoar quando a mágoa ainda dói. É estender a mão quando seria mais fácil virar as costas.\n\nPeça a Deus hoje para encher seu coração com Seu amor, para que você possa transbordar para aqueles ao seu redor.",
                "O amor verdadeiro cobre multidão de pecados. 1 Pedro 4:8 nos lembra: \"Sobretudo, tenham amor intenso uns pelos outros, porque o amor cobre uma multidão de pecados.\"\n\nIsso não significa ignorar o errado, mas escolher a graça acima do julgamento. Significa ver as pessoas como Deus as vê — com potencial, com propósito, com valor infinito.\n\nHoje, exercite esse olhar de amor. Olhe para aqueles ao seu redor não com olhos de crítica, mas com olhos de compaixão."
            ]
            return contents[(day - 1) % contents.count]
        case .ansiedade:
            let contents = [
                "Às vezes você se sente sobrecarregado? A ansiedade pode parecer um peso impossível de carregar. Mas Deus nos convida a lançar sobre Ele toda nossa ansiedade, porque Ele cuida de nós (1 Pedro 5:7).\n\nEssa não é uma promessa vazia — é um convite pessoal do Criador do universo. Ele, que sustenta galáxias e cuida de cada passarinho, quer cuidar de você.\n\nA ansiedade perde sua força quando nos lembramos de quem está no controle. Não é você. Não são as circunstâncias. É Deus — e Ele é bom, o tempo todo.\n\nHoje, respire fundo e declare: \"Senhor, eu confio em Ti. Eu entrego minha ansiedade em Tuas mãos.\"",
                "Filipenses 4:6-7 nos ensina: \"Não andem ansiosos por coisa alguma, mas em tudo, pela oração e súplicas, com ação de graças, apresentem seus pedidos a Deus. E a paz de Deus, que excede todo entendimento, guardará o coração e a mente de vocês em Cristo Jesus.\"\n\nA receita divina contra a ansiedade não é a ausência de problemas — é a presença de Deus. Quando oramos com gratidão, algo sobrenatural acontece: a paz de Deus vem e guarda nosso coração como um escudo.\n\nHoje, ao invés de se preocupar, transforme cada preocupação em oração. Agradeça pelas bênçãos que já tem e confie que Deus cuidará do resto.",
                "Jesus disse em Mateus 6:34: \"Não se preocupem com o amanhã, pois o amanhã trará as suas próprias preocupações. Basta a cada dia o seu próprio mal.\"\n\nA ansiedade nos rouba o presente ao nos forçar a viver no futuro. Mas Deus nos chama para viver um dia de cada vez, confiando que Ele já está no amanhã preparando o caminho.\n\nSua graça é suficiente para hoje. Amanhã, Ele dará graça nova. Viva o presente com fé e deixe o futuro nas mãos dAquele que conhece todos os seus dias."
            ]
            return contents[(day - 1) % contents.count]
        case .cura:
            let contents = [
                "Salmo 147:3 declara: \"Ele sara os de coração quebrantado e lhes pensa as feridas.\"\n\nDeus não é indiferente à sua dor. Ele vê cada lágrima, conhece cada cicatriz, e Seu desejo é trazer cura completa ao seu coração. A cura divina não apaga o passado, mas transforma a dor em propósito.\n\nHoje, permita que o Médico dos médicos toque as áreas mais profundas do seu ser. Ele é gentil, paciente, e Sua cura é completa.",
                "Isaías 53:5 profetiza sobre Cristo: \"Pelas suas pisaduras fomos sarados.\" A cura que Jesus conquistou na cruz não é apenas física — é emocional, espiritual e relacional.\n\nTalvez você carregue feridas que parecem impossíveis de curar. Talvez a dor já tenha se tornado tão familiar que você nem lembra como é viver sem ela. Mas Deus quer restaurar tudo.\n\nA cura é um processo, e cada passo dado em direção a Deus é um passo em direção à restauração. Confie no processo e confie no Curador."
            ]
            return contents[(day - 1) % contents.count]
        case .raiva:
            let contents = [
                "Efésios 4:26-27 nos ensina: \"Irem-se, mas não pequem. Não deixem que o sol se ponha estando vocês ainda irados, e não deem lugar ao diabo.\"\n\nA raiva em si não é pecado — é uma emoção humana. Mas o que fazemos com ela pode nos levar ao pecado ou ao crescimento. Deus nos dá uma janela para processar a ira: não deixe o sol se pôr sobre ela.\n\nIsso significa: não alimente a raiva. Não a deixe criar raízes. Processe, perdoe, libere. Quanto mais rápido você entregar a ira a Deus, mais rápido encontrará paz.",
                "Tiago 1:19-20 aconselha: \"Sejam prontos para ouvir, tardios para falar e tardios para se irar. Pois a ira do homem não produz a justiça de Deus.\"\n\nA sabedoria bíblica é contra-intuitiva: numa cultura que valoriza respostas rápidas e reações instantâneas, Deus nos chama a pausar. Ouvir primeiro. Pensar antes de falar. Controlar a ira antes que ela nos controle.\n\nHoje, pratique a pausa santa. Quando sentir a raiva surgir, respire e entregue o momento a Deus."
            ]
            return contents[(day - 1) % contents.count]
        case .depressao:
            let contents = [
                "Às vezes você se sente só? Você já parou para pensar se alguém lá fora se importa com o que você está passando?\n\nQuando se sente que não há ninguém ao redor, saiba que Deus sempre está aqui para você — mesmo agora neste momento. Em suas mais triunfantes vitórias e em seus mais sombrios clamores por ajuda, **Ele sempre está ao seu lado**. Ele nunca irá te deixar.\n\nDe fato, a Bíblia nos diz que nós nunca conseguimos ir tão longe de Deus ou fugir de Sua presença. Não importa quantas vezes você falhou, quantas vezes seus amigos te abandonaram, ou quão desamparada a vida pode parecer algumas vezes, Deus constantemente está ao seu redor.\n\nHoje, descanse nessa verdade: você nunca está verdadeiramente sozinho.",
                "Salmo 34:18 nos consola: \"Perto está o Senhor dos que têm o coração quebrantado e salva os de espírito abatido.\"\n\nDeus não foge da nossa dor — Ele se aproxima. Nos momentos mais escuros, quando sentimos que não temos forças para sequer orar, o Espírito Santo intercede por nós com gemidos inexprimíveis (Romanos 8:26).\n\nVocê não precisa ter as palavras certas. Não precisa fingir que está bem. Apenas venha como está — quebrado, cansado, confuso. Deus acolhe você exatamente assim."
            ]
            return contents[(day - 1) % contents.count]
        default:
            let contents = [
                "A Palavra de Deus é viva e eficaz. Hebreus 4:12 nos diz que ela é mais cortante que qualquer espada de dois gumes, penetrando até a divisão da alma e do espírito.\n\nQuando mergulhamos nas Escrituras, não estamos apenas lendo um livro — estamos encontrando o próprio Deus. Sua Palavra tem poder para transformar, curar, restaurar e direcionar.\n\nHoje, abra seu coração para que a Palavra cumpra seu propósito em sua vida. Permita que ela penetre nas áreas mais profundas e traga luz onde há escuridão.",
                "Josué 1:8 nos instrui: \"Não deixe de falar as palavras deste Livro da Lei. Medite nele de dia e de noite, para que você cumpra fielmente tudo o que nele está escrito. Só então os seus caminhos prosperarão e você será bem-sucedido.\"\n\nO segredo do sucesso espiritual não é complexo: meditar na Palavra dia e noite. Isso não significa apenas ler — significa mastigar, refletir, aplicar.\n\nFaça da Palavra sua companheira constante e veja como Deus transforma cada área da sua vida."
            ]
            return contents[(day - 1) % contents.count]
        }
    }

    private static func scripturesFor(category: PlanCategory, day: Int) -> [String] {
        switch category {
        case .amor:
            let refs: [[String]] = [
                ["1 Coríntios 13:4-7", "João 3:16"],
                ["Romanos 8:38-39", "1 João 4:19"],
                ["Efésios 5:25", "Cânticos 8:7"],
                ["João 15:12-13", "Gálatas 5:22"],
                ["1 João 4:7-8", "Romanos 13:10"],
            ]
            return refs[(day - 1) % refs.count]
        case .cura:
            let refs: [[String]] = [
                ["Salmos 147:3", "Isaías 53:5"],
                ["Jeremias 17:14", "Êxodo 15:26"],
                ["Marcos 5:34", "Salmos 30:2"],
                ["Mateus 11:28", "2 Crônicas 7:14"],
            ]
            return refs[(day - 1) % refs.count]
        case .ansiedade:
            let refs: [[String]] = [
                ["Filipenses 4:6-7", "1 Pedro 5:7"],
                ["Mateus 6:25-27", "Isaías 41:10"],
                ["Salmos 94:19", "Salmos 55:22"],
                ["João 14:27", "2 Timóteo 1:7"],
                ["Provérbios 12:25", "Mateus 11:28-30"],
            ]
            return refs[(day - 1) % refs.count]
        case .raiva:
            let refs: [[String]] = [
                ["Efésios 4:26-27", "Provérbios 15:1"],
                ["Tiago 1:19-20", "Colossenses 3:8"],
                ["Provérbios 29:11", "Eclesiastes 7:9"],
            ]
            return refs[(day - 1) % refs.count]
        case .depressao:
            let refs: [[String]] = [
                ["Isaías 41:10", "Salmos 139:7", "Josué 1:9"],
                ["Salmos 34:18", "Romanos 8:26"],
                ["Salmos 42:11", "2 Coríntios 4:8-9"],
                ["Mateus 11:28", "Salmos 23:4"],
            ]
            return refs[(day - 1) % refs.count]
        default:
            let refs: [[String]] = [
                ["Hebreus 4:12", "Josué 1:8"],
                ["Salmos 119:105", "2 Timóteo 3:16"],
                ["Romanos 15:4", "Isaías 40:8"],
            ]
            return refs[(day - 1) % refs.count]
        }
    }
}

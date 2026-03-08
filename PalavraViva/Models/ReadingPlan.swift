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
        case .amor: return amorPlans
        case .cura: return curaPlans
        case .esperanca: return esperancaPlans
        case .ansiedade: return ansiedadePlans
        case .raiva: return raivaPlans
        case .depressao: return depressaoPlans
        case .fe: return fePlans
        case .familia: return familiaPlans
        case .oracao: return oracaoPlans
        }
    }

    static let allPlans: [ReadingPlan] = {
        PlanCategory.allCases.flatMap { plans(for: $0) }
    }()

    static func plan(byId id: String) -> ReadingPlan? {
        allPlans.first { $0.id == id }
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
                title: "Devocional do Dia \(dayNumber)",
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

    // MARK: - Devotional Content Per Category

    private static func devotionalContentFor(category: PlanCategory, day: Int) -> String {
        let contents = devotionalBank[category] ?? defaultDevotionals
        return contents[(day - 1) % contents.count]
    }

    private static let devotionalBank: [PlanCategory: [String]] = [
        .amor: [
            "O amor de Deus é a base de toda a existência. Antes mesmo de formarmos nosso primeiro pensamento, Ele já nos amava com amor eterno. Jeremias 31:3 nos diz: \"Com amor eterno te amei; por isso, com benignidade te atraí.\" Esse amor não depende do que fazemos ou deixamos de fazer. É um amor que escolhe, que persiste, que nunca desiste.\n\nQuando entendemos a profundidade desse amor, nossa vida começa a se transformar de dentro para fora. Não precisamos mais buscar aprovação, porque já somos aprovados. Não precisamos mais temer rejeição, porque já somos aceitos.\n\nHoje, permita que essa verdade penetre cada área do seu coração: você é amado — não pelo que faz, mas por quem Deus é.",

            "Amar como Cristo amou exige entrega total. Em João 15:12-13, Jesus disse: \"O meu mandamento é este: Amem-se uns aos outros como eu os amei. Ninguém tem maior amor do que aquele que dá a sua vida pelos seus amigos.\"\n\nEsse amor não é apenas sentimento — é ação. É escolher servir quando queremos ser servidos. É perdoar quando a mágoa ainda dói. É estender a mão quando seria mais fácil virar as costas.\n\nPeça a Deus hoje para encher seu coração com Seu amor, para que você possa transbordar para aqueles ao seu redor.",

            "O amor verdadeiro cobre multidão de pecados. 1 Pedro 4:8 nos lembra: \"Sobretudo, tenham amor intenso uns pelos outros, porque o amor cobre uma multidão de pecados.\"\n\nIsso não significa ignorar o errado, mas escolher a graça acima do julgamento. Significa ver as pessoas como Deus as vê — com potencial, com propósito, com valor infinito.\n\nHoje, exercite esse olhar de amor. Olhe para aqueles ao seu redor não com olhos de crítica, mas com olhos de compaixão.",

            "O apóstolo Paulo nos deixou o mais belo retrato do amor em 1 Coríntios 13. \"O amor é paciente, o amor é bondoso. Não inveja, não se vangloria, não se orgulha. Não maltrata, não procura seus interesses, não se ira facilmente, não guarda rancor.\"\n\nCada uma dessas características é um desafio diário. O amor verdadeiro não é um sentimento que vai e vem — é uma decisão constante. É acordar todos os dias e escolher ser paciente quando queremos explodir, ser bondoso quando queremos revidar.\n\nHoje, escolha uma dessas características e pratique-a intencionalmente em seus relacionamentos.",

            "Deus demonstrou Seu amor de forma suprema ao enviar Seu Filho ao mundo. 1 João 4:9-10 declara: \"Foi assim que Deus manifestou o seu amor entre nós: enviou o seu Filho unigênito ao mundo, para que pudéssemos viver por meio dele.\"\n\nO amor de Deus não ficou no campo das ideias — tornou-se carne, caminhou entre nós, sentiu nossas dores e morreu em nosso lugar. Esse é o padrão do amor divino: sacrificial, prático e transformador.\n\nVocê já experimentou esse amor pessoalmente? Hoje, abra seu coração para recebê-lo em toda a sua plenitude.",

            "O amor ao próximo é inseparável do amor a Deus. Jesus disse que o segundo maior mandamento é \"Amarás o teu próximo como a ti mesmo\" (Marcos 12:31). Não podemos dizer que amamos a Deus e ao mesmo tempo ignorar as necessidades daqueles ao nosso redor.\n\nO amor prático se manifesta em gestos simples: um ouvido atento, uma palavra de encorajamento, uma ajuda inesperada. Não é preciso fazer grandes coisas — basta fazer pequenas coisas com grande amor.\n\nHoje, busque uma oportunidade prática de demonstrar amor a alguém.",

            "O amor perfeito lança fora todo medo. 1 João 4:18 nos ensina que \"No amor não há medo; pelo contrário, o perfeito amor lança fora o medo.\" Quando estamos firmados no amor de Deus, o medo perde sua força sobre nós.\n\nMedo de rejeição? O amor de Deus nos aceita. Medo do futuro? O amor de Deus nos guia. Medo da morte? O amor de Deus nos dá vida eterna. Cada medo encontra sua resposta no amor perfeito do Pai.\n\nDeclare hoje: \"Sou amado por Deus e nada pode mudar isso.\" Deixe essa verdade dissolver cada temor.",

            "O perdão é uma das mais puras expressões do amor. Colossenses 3:13 nos instrui: \"Suportem-se uns aos outros e perdoem as queixas que tiverem uns contra os outros. Perdoem como o Senhor lhes perdoou.\"\n\nPerdoar não é aprovar o que fizeram contra nós — é libertar nosso coração da prisão do ressentimento. Quando perdoamos, não estamos fazendo um favor ao outro, mas a nós mesmos. O perdão nos liberta para amar novamente.\n\nExiste alguém que você precisa perdoar hoje? Entregue essa pessoa a Deus e permita que Seu amor cure essa ferida.",

            "O amor de Deus nos persegue mesmo quando fugimos dEle. A parábola do filho pródigo (Lucas 15:11-32) mostra um pai que espera ansiosamente pelo filho que partiu. Quando o vê de longe, corre ao seu encontro, abraça-o e o restaura completamente.\n\nAssim é o nosso Deus. Não importa o quão longe tenhamos ido, Ele está esperando de braços abertos. Não há pecado grande demais, erro grave demais ou distância longa demais para o amor do Pai.\n\nSe você se sente distante de Deus hoje, saiba que Ele está correndo ao seu encontro.",

            "\"Amados, amemo-nos uns aos outros, porque o amor procede de Deus; e todo aquele que ama é nascido de Deus e conhece a Deus\" (1 João 4:7). O amor não é apenas algo que Deus faz — é quem Ele é. E quando amamos genuinamente, revelamos a natureza de Deus ao mundo.\n\nCada ato de amor é uma pregação silenciosa do evangelho. Quando amamos os difíceis de amar, quando servimos sem esperar retorno, quando escolhemos a bondade, estamos mostrando Cristo ao mundo.\n\nHoje, seja um reflexo do amor de Deus para alguém que precisa desesperadamente vê-Lo."
        ],

        .ansiedade: [
            "A ansiedade pode parecer um peso impossível de carregar. Mas Deus nos convida a lançar sobre Ele toda nossa ansiedade, porque Ele cuida de nós (1 Pedro 5:7).\n\nEssa não é uma promessa vazia — é um convite pessoal do Criador do universo. Ele, que sustenta galáxias e cuida de cada passarinho, quer cuidar de você.\n\nA ansiedade perde sua força quando nos lembramos de quem está no controle. Não é você. Não são as circunstâncias. É Deus — e Ele é bom, o tempo todo.\n\nHoje, respire fundo e declare: \"Senhor, eu confio em Ti. Eu entrego minha ansiedade em Tuas mãos.\"",

            "Filipenses 4:6-7 nos ensina: \"Não andem ansiosos por coisa alguma, mas em tudo, pela oração e súplicas, com ação de graças, apresentem seus pedidos a Deus. E a paz de Deus, que excede todo entendimento, guardará o coração e a mente de vocês em Cristo Jesus.\"\n\nA receita divina contra a ansiedade não é a ausência de problemas — é a presença de Deus. Quando oramos com gratidão, algo sobrenatural acontece: a paz de Deus vem e guarda nosso coração como um escudo.\n\nHoje, ao invés de se preocupar, transforme cada preocupação em oração.",

            "Jesus disse em Mateus 6:34: \"Não se preocupem com o amanhã, pois o amanhã trará as suas próprias preocupações. Basta a cada dia o seu próprio mal.\"\n\nA ansiedade nos rouba o presente ao nos forçar a viver no futuro. Mas Deus nos chama para viver um dia de cada vez, confiando que Ele já está no amanhã preparando o caminho.\n\nSua graça é suficiente para hoje. Amanhã, Ele dará graça nova. Viva o presente com fé e deixe o futuro nas mãos dAquele que conhece todos os seus dias.",

            "\"Vinde a mim, todos os que estais cansados e oprimidos, e eu vos aliviarei\" (Mateus 11:28). Jesus não nos convida a nos esforçar mais, a ser mais fortes ou a resolver tudo sozinhos. Ele nos convida a ir até Ele — exatamente como estamos, com todo o peso.\n\nO alívio que Jesus oferece não é temporário como o que o mundo promete. É um descanso profundo da alma, que permanece mesmo quando as circunstâncias não mudam.\n\nHoje, aceite o convite de Jesus. Pare, respire e vá até Ele com suas cargas.",

            "Salmos 94:19 declara: \"Quando me sentia assolado pela ansiedade, o teu consolo trouxe alívio à minha alma.\" O salmista não fingiu que a ansiedade não existia — ele a sentiu, foi assolado por ela. Mas encontrou algo mais forte: o consolo de Deus.\n\nDeus não espera que você seja imune à ansiedade. Ele sabe que somos humanos. O que Ele nos oferece é Seu consolo no meio dela. Sua presença não elimina imediatamente toda preocupação, mas nos dá forças para atravessá-la.\n\nBusque o consolo de Deus hoje — Ele está mais perto do que você imagina.",

            "\"Entrega o teu caminho ao Senhor; confia nele, e ele tudo fará\" (Salmos 37:5). A ansiedade muitas vezes surge quando tentamos controlar o incontrolável. Queremos garantias, queremos certezas, queremos saber cada passo do caminho.\n\nMas Deus nos pede algo diferente: entregar. Não é passividade — é um ato de fé. É dizer: \"Senhor, eu não sei o que vai acontecer, mas confio que Tu sabes e que farás o melhor.\"\n\nO que você está tentando controlar hoje? Entregue nas mãos de Deus e descanse.",

            "\"Deus é o nosso refúgio e fortaleza, socorro bem presente na angústia\" (Salmos 46:1). Quando a ansiedade apertar, lembre-se: Deus não é um socorro distante ou demorado. Ele é um socorro bem presente — aqui, agora, neste exato momento.\n\nVocê não precisa esperar até estar calmo para buscar a Deus. Vá até Ele no auge da ansiedade, com o coração acelerado e a mente turbulenta. Ele recebe você assim e Sua fortaleza se torna a sua.\n\nDeclare: \"Deus é meu refúgio. Neste momento, eu corro para Ele.\""
        ],

        .cura: [
            "Salmo 147:3 declara: \"Ele sara os de coração quebrantado e lhes pensa as feridas.\"\n\nDeus não é indiferente à sua dor. Ele vê cada lágrima, conhece cada cicatriz, e Seu desejo é trazer cura completa ao seu coração. A cura divina não apaga o passado, mas transforma a dor em propósito.\n\nHoje, permita que o Médico dos médicos toque as áreas mais profundas do seu ser. Ele é gentil, paciente, e Sua cura é completa.",

            "Isaías 53:5 profetiza sobre Cristo: \"Pelas suas pisaduras fomos sarados.\" A cura que Jesus conquistou na cruz não é apenas física — é emocional, espiritual e relacional.\n\nTalvez você carregue feridas que parecem impossíveis de curar. Talvez a dor já tenha se tornado tão familiar que você nem lembra como é viver sem ela. Mas Deus quer restaurar tudo.\n\nA cura é um processo, e cada passo dado em direção a Deus é um passo em direção à restauração. Confie no processo e confie no Curador.",

            "Jeremias 17:14 clama: \"Cura-me, Senhor, e serei curado; salva-me, e serei salvo; porque tu és o meu louvor.\" O profeta entendeu algo fundamental: a cura verdadeira vem exclusivamente de Deus.\n\nPodemos buscar ajuda humana — e devemos — mas a fonte última de toda cura é o Senhor. Ele cura de dentro para fora, começando pela raiz da dor, não apenas pelos sintomas.\n\nHoje, apresente suas feridas ao Senhor com honestidade. Ele não se assusta com sua dor — Ele já a carregou na cruz.",

            "A mulher que tocou a borda do manto de Jesus (Marcos 5:25-34) havia sofrido por doze anos. Tinha gasto tudo com médicos e nada melhorava. Mas bastou um toque de fé em Jesus para ser completamente curada.\n\nSua fé não precisou ser perfeita — precisou ser direcionada ao lugar certo. Ela tocou em Jesus. E Jesus disse: \"Filha, a tua fé te salvou; vai em paz, e sê curada deste teu mal.\"\n\nQual é a ferida que você carrega há muito tempo? Hoje, estenda sua mão de fé e toque em Jesus.",

            "\"Vinde a mim, todos os que estais cansados e oprimidos, e eu vos aliviarei. Tomai sobre vós o meu jugo, e aprendei de mim, que sou manso e humilde de coração, e encontrareis descanso para a vossa alma\" (Mateus 11:28-29).\n\nJesus oferece descanso para a alma — o tipo de cura que vai além do corpo. É a restauração do mais íntimo do nosso ser. O jugo dEle é leve porque Ele carrega o peso junto conosco.\n\nPermita que o descanso de Cristo alcance as áreas mais cansadas da sua vida.",

            "Êxodo 15:26 revela um dos nomes de Deus: \"Eu sou o Senhor que te sara\" (Jeová Rafá). Deus não apenas pode curar — curar faz parte de quem Ele é. É Sua natureza.\n\nQuando você clama por cura, está apelando para a própria essência do caráter de Deus. Ele não precisa ser convencido a curar — esse é Seu desejo profundo para você.\n\nDeclare sobre sua vida hoje: \"O Senhor é meu curador. Ele restaura minha saúde, minha mente e meu coração.\"",

            "\"Ele mesmo levou em seu corpo os nossos pecados sobre o madeiro, para que morrêssemos para os pecados e vivêssemos para a justiça; por suas feridas vocês foram curados\" (1 Pedro 2:24).\n\nA cura que Cristo oferece é completa e definitiva. Cada ferida que Ele sofreu na cruz carrega o poder de curar uma ferida sua. Suas chagas por nossa cura — esse é o intercâmbio da graça.\n\nVocê não precisa carregar essas dores sozinho. Cristo já as carregou. Entregue cada uma delas a Ele.",

            "O Salmo 30:2 testemunha: \"Senhor meu Deus, clamei a ti, e tu me saraste.\" A cura muitas vezes começa com um clamor. Não um clamor perfeito ou eloquente, mas um grito honesto do coração.\n\nDeus responde ao clamor sincero. Ele não exige que você tenha as palavras certas ou a fé perfeita. Ele pede apenas que você venha — com sua dor, sua confusão, sua fragilidade.\n\nHoje, clame ao Senhor. Abra seu coração sem filtros. Ele está ouvindo e Sua mão curadora já se estende em sua direção.",

            "A cura é um processo, não um evento instantâneo. Assim como uma ferida física precisa de tempo para cicatrizar, as feridas da alma também precisam. Provérbios 4:20-22 nos instrui: \"Meu filho, atente para o que digo; preste atenção às minhas palavras... pois são vida para quem as encontra e saúde para todo o seu corpo.\"\n\nA Palavra de Deus é remédio diário para a alma. Não é uma dose única, mas um tratamento contínuo. Cada versículo lido, cada promessa meditada, cada verdade abraçada traz um pouco mais de cura.\n\nContinue tomando o remédio da Palavra — a cura está acontecendo.",

            "\"Assim diz o Senhor: Eis que lhe trarei saúde e cura, e os sararei, e lhes revelarei abundância de paz e verdade\" (Jeremias 33:6). Deus não promete apenas cura isolada — Ele promete cura acompanhada de paz e verdade.\n\nA cura divina traz paz onde havia tormento e verdade onde havia mentiras do inimigo. Você não apenas será curado — será restaurado a um estado melhor do que antes.\n\nReceba hoje não apenas cura, mas a paz e a verdade que a acompanham. Deus está fazendo uma obra completa em você.",

            "A história de Naamã (2 Reis 5) nos ensina que às vezes a cura vem de formas inesperadas. Naamã esperava algo espetacular, mas Deus pediu algo simples: mergulhar sete vezes no Jordão. Só quando obedeceu, foi curado.\n\nÀs vezes resistimos à cura porque ela não vem do jeito que esperamos. Deus pode curar através de um conselho, uma mudança de hábito, uma conversa difícil, um período de espera. O importante é confiar e obedecer.\n\nHoje, esteja aberto ao modo como Deus quer trazer cura à sua vida — mesmo que seja diferente do que você imaginou.",

            "\"Mas para vós que temeis o meu nome, nascerá o sol da justiça, trazendo cura nas suas asas\" (Malaquias 4:2). Assim como o sol nasce trazendo luz e calor após uma noite escura, Cristo — o Sol da Justiça — traz cura completa.\n\nA escuridão da dor não durará para sempre. Um novo amanhecer está chegando. A cura está em Suas asas, pronta para alcançar cada área ferida da sua vida.\n\nDeclare com fé: um novo dia está nascendo sobre minha vida, e com ele vem a cura do Senhor."
        ],

        .raiva: [
            "Efésios 4:26-27 nos ensina: \"Irem-se, mas não pequem. Não deixem que o sol se ponha estando vocês ainda irados, e não deem lugar ao diabo.\"\n\nA raiva em si não é pecado — é uma emoção humana. Mas o que fazemos com ela pode nos levar ao pecado ou ao crescimento. Deus nos dá uma janela para processar a ira: não deixe o sol se pôr sobre ela.\n\nIsso significa: não alimente a raiva. Não a deixe criar raízes. Processe, perdoe, libere.",

            "Tiago 1:19-20 aconselha: \"Sejam prontos para ouvir, tardios para falar e tardios para se irar. Pois a ira do homem não produz a justiça de Deus.\"\n\nA sabedoria bíblica é contra-intuitiva: numa cultura que valoriza respostas rápidas, Deus nos chama a pausar. Ouvir primeiro. Pensar antes de falar. Controlar a ira antes que ela nos controle.\n\nHoje, pratique a pausa santa. Quando sentir a raiva surgir, respire e entregue o momento a Deus.",

            "\"A resposta branda desvia o furor, mas a palavra dura suscita a ira\" (Provérbios 15:1). O poder de uma resposta gentil é subestimado. Quando alguém nos ataca com palavras duras, nossa tendência natural é revidar na mesma moeda. Mas Deus nos mostra um caminho superior.\n\nA resposta branda não é fraqueza — é força sob controle. É escolher conscientemente não escalar o conflito. É refletir o caráter de Cristo na tensão.\n\nHoje, quando for provocado, experimente a resposta branda. Você vai se surpreender com o resultado.",

            "\"Não te deixes vencer do mal, mas vence o mal com o bem\" (Romanos 12:21). A raiva frequentemente nos tenta a responder ao mal com mais mal. Mas Paulo nos desafia a quebrar o ciclo respondendo com bem.\n\nIsso é revolucionário. É contra-cultural. E é profundamente libertador. Quando respondemos ao mal com bondade, quebramos as correntes que a raiva tenta colocar em nós.\n\nPense em uma situação que te causou raiva recentemente. Como você poderia responder com bem? Peça sabedoria a Deus para isso.",

            "\"Melhor é o longânimo do que o herói da guerra, e o que domina o seu espírito, do que o que toma uma cidade\" (Provérbios 16:32). Na cultura antiga, conquistar cidades era o auge da força. Mas Salomão diz que dominar a si mesmo é ainda maior.\n\nO autodomínio — especialmente sobre a raiva — é uma das maiores demonstrações de força espiritual. Não é reprimir a emoção, mas canalizá-la de forma saudável através da graça de Deus.\n\nHoje, exercite o domínio próprio. Com a ajuda do Espírito Santo, você pode ser mais forte que qualquer guerreiro.",

            "A história de Moisés nos ensina sobre as consequências da raiva descontrolada. Em Números 20, Deus o instruiu a falar à rocha, mas Moisés, tomado pela ira contra o povo, golpeou a rocha duas vezes. A água saiu, mas Moisés perdeu a entrada na Terra Prometida.\n\nA raiva pode nos custar bênçãos preciosas. Mesmo quando temos razão para estar irados, a forma como respondemos importa. Deus nos dá instruções específicas — e espera que as sigamos, mesmo quando a emoção é forte.\n\nAntes de agir por impulso, pergunte: qual é a instrução de Deus para este momento?",

            "\"Amados, nunca procurem vingar-se, mas deixem com Deus a ira, pois está escrito: 'A mim me pertence a vingança; eu retribuirei', diz o Senhor\" (Romanos 12:19).\n\nA raiva muitas vezes vem acompanhada do desejo de vingança. Queremos que quem nos machucou pague pelo que fez. Mas Deus nos pede para confiar nEle para fazer justiça.\n\nIsso nos liberta do peso de ser juiz e executor. Quando entregamos a situação a Deus, podemos finalmente seguir em frente, livres da amargura.\n\nEntregue hoje a Deus toda sede de vingança. Deixe que Ele cuide da justiça."
        ],

        .depressao: [
            "Você já se sentiu completamente sozinho? Quando parece que ninguém se importa com o que você está passando, saiba que Deus sempre está aqui — mesmo agora neste momento. Em suas mais triunfantes vitórias e em seus mais sombrios clamores por ajuda, Ele sempre está ao seu lado. Ele nunca irá te deixar.\n\nA Bíblia nos diz que nunca conseguimos ir tão longe de Deus ou fugir de Sua presença. Não importa quantas vezes você falhou, quantas vezes seus amigos te abandonaram, ou quão desamparada a vida pode parecer, Deus constantemente está ao seu redor.\n\nHoje, descanse nessa verdade: você nunca está verdadeiramente sozinho.",

            "Salmo 34:18 nos consola: \"Perto está o Senhor dos que têm o coração quebrantado e salva os de espírito abatido.\"\n\nDeus não foge da nossa dor — Ele se aproxima. Nos momentos mais escuros, quando sentimos que não temos forças para sequer orar, o Espírito Santo intercede por nós com gemidos inexprimíveis (Romanos 8:26).\n\nVocê não precisa ter as palavras certas. Não precisa fingir que está bem. Apenas venha como está — quebrado, cansado, confuso. Deus acolhe você exatamente assim.",

            "\"Por que estás abatida, ó minha alma? Por que te perturbas dentro de mim? Espera em Deus, pois ainda o louvarei, a ele, meu auxílio e meu Deus\" (Salmos 42:11). O salmista fala consigo mesmo — ele confronta sua própria alma com a verdade.\n\nÀs vezes precisamos pregar para nós mesmos. Precisamos lembrar nossa alma do que é verdade, mesmo quando os sentimentos dizem o contrário. A esperança não é um sentimento — é uma decisão baseada em quem Deus é.\n\nHoje, diga à sua alma: \"Espera em Deus. Ele não te abandonou. Ainda O louvarei.\"",

            "\"Estamos aflitos de todo modo, mas não encurralados; perplexos, mas não desesperados; perseguidos, mas não abandonados; abatidos, mas não destruídos\" (2 Coríntios 4:8-9).\n\nPaulo conhecia a aflição profundamente. Mas ele encontrou uma verdade libertadora: embora possamos ser abalados, não seremos destruídos. A depressão pode nos fazer sentir que estamos no fim, mas Deus diz que não é o fim.\n\nVocê pode estar abatido, mas não está destruído. Pode estar aflito, mas não está encurralado. Há uma saída, e Deus a conhece.",

            "Elias, um dos maiores profetas de Israel, experimentou profunda depressão (1 Reis 19). Depois de uma grande vitória espiritual, ele fugiu com medo e pediu a morte. Mas Deus não o repreendeu. Enviou um anjo com pão e água e o deixou descansar.\n\nDeus entende que às vezes nosso corpo e mente precisam de cuidado básico antes de qualquer palavra espiritual. Descanso, alimentação, hidratação — estas também são formas de graça.\n\nSe você está exausto hoje, não se culpe. Descanse. Deus está cuidando de você, assim como cuidou de Elias.",

            "\"Pois os seus instantes de ira duram só um momento, mas sua benevolência dura a vida inteira; o choro pode persistir uma noite, mas de manhã irrompe a alegria\" (Salmos 30:5).\n\nA noite pode ser longa e dolorosa, mas ela não é eterna. A manhã vem. A alegria vem. Essa é uma promessa de Deus. Mesmo que agora pareça impossível, um novo dia está chegando.\n\nSegure firme nesta promessa: a noite vai passar. A alegria da manhã está mais perto do que você pensa.",

            "\"O Senhor é quem vai adiante de ti; ele será contigo, não te deixará, nem te desamparará; não temas, nem te espantes\" (Deuteronômio 31:8).\n\nQuando a depressão nos diz que estamos sozinhos e desamparados, Deus fala mais alto: \"Eu vou adiante de você. Eu estou com você. Eu nunca vou te deixar.\"\n\nTrês promessas poderosas em um único versículo. Deus vai à frente preparando o caminho, caminha ao seu lado dando forças, e nunca, jamais te abandona.\n\nRepita essas promessas até que elas penetrem mais fundo que a dor."
        ],

        .fe: [
            "Hebreus 11:1 define a fé: \"Ora, a fé é o firme fundamento das coisas que se esperam e a prova das coisas que se não veem.\" A fé não é crer no que podemos ver — é confiar no que ainda não vemos, baseados em quem Deus é.\n\nA fé é como plantar uma semente: você não vê nada acontecendo por baixo da terra, mas a vida está crescendo. Cada oração, cada ato de obediência, cada escolha de confiar em Deus está plantando sementes de um futuro abençoado.\n\nHoje, exercite sua fé. Confie em Deus mesmo sem ver o resultado.",

            "Abraão é chamado o pai da fé. Em Gênesis 12, Deus pediu que ele deixasse tudo — família, terra natal, segurança — e fosse para um lugar que nem sabia onde era. E Abraão foi.\n\nA fé às vezes exige que deixemos o familiar para abraçar o desconhecido com Deus. Não é fácil, mas é nessas jornadas de fé que Deus faz suas maiores obras.\n\nO que Deus está te pedindo para soltar hoje? Que passo de fé Ele está te chamando a dar?",

            "\"Porque andamos por fé e não por vista\" (2 Coríntios 5:7). Viver por fé significa tomar decisões baseadas nas promessas de Deus, não nas circunstâncias visíveis.\n\nÉ fácil confiar quando tudo vai bem. A verdadeira fé se manifesta quando as circunstâncias dizem uma coisa e Deus diz outra — e escolhemos acreditar em Deus.\n\nA fé não nega a realidade, mas se recusa a ser limitada por ela. Deus é maior que qualquer circunstância. Ande por fé hoje.",

            "Pedro andou sobre as águas quando manteve os olhos em Jesus (Mateus 14:29-31). Mas quando olhou para as ondas ao redor, começou a afundar. Jesus estendeu a mão e o segurou.\n\nNossa fé vacila quando tiramos os olhos de Jesus e focamos nos problemas. As ondas da vida são reais, mas Jesus é mais real ainda. E mesmo quando nossa fé fraqueja, Ele estende a mão.\n\nMantenha seus olhos em Jesus hoje. Ele é a âncora da sua fé.",

            "\"Se tiverdes fé como um grão de mostarda, direis a este monte: Passa daqui para acolá — e há de passar; e nada vos será impossível\" (Mateus 17:20). Jesus não disse que precisamos de grande fé — disse que fé pequena direcionada ao Deus grande é suficiente.\n\nSua fé não precisa ser perfeita. Não precisa ser gigante. Só precisa ser real e estar direcionada a Jesus. A menor fé no maior Deus move montanhas.\n\nQual montanha está diante de você? Dirija sua fé — por menor que seja — a Jesus.",

            "A fé cresce quando é exercitada. Romanos 10:17 nos diz: \"A fé vem pelo ouvir, e o ouvir pela palavra de Deus.\" Quanto mais nos alimentamos da Palavra, mais nossa fé se fortalece.\n\nAssim como um músculo se desenvolve com exercício regular, a fé se fortalece com uso constante. Cada vez que confiamos em Deus em uma situação difícil, nossa fé cresce para a próxima.\n\nAlimente sua fé hoje com a Palavra de Deus. Ela é o combustível que mantém a chama acesa.",

            "\"Olhando para Jesus, autor e consumador da fé\" (Hebreus 12:2). Jesus não é apenas o exemplo da fé — Ele é seu autor e consumador. Ele começou a obra de fé em nós e Ele a completará.\n\nNos dias em que sua fé parecer fraca, lembre-se: não depende apenas de você. Jesus está ativamente trabalhando para fortalecer e aperfeiçoar sua fé. Ele não começou algo que não vai terminar.\n\nDescanse nessa verdade: Aquele que começou a boa obra em você vai completá-la.",

            "Davi enfrentou Golias com cinco pedras e uma fé inabalável no Deus de Israel (1 Samuel 17). Enquanto todo o exército tremia de medo, um jovem pastor se levantou porque conhecia seu Deus.\n\nA fé não depende do tamanho da pessoa, mas do tamanho do Deus em quem confia. Davi não era o mais forte, o mais experiente ou o mais preparado. Mas ele conhecia a Deus.\n\nQual é o Golias na sua vida? Enfrente-o não com sua própria força, mas com a fé no Deus que nunca perde uma batalha.",

            "\"Sem fé é impossível agradar a Deus, pois quem dele se aproxima precisa crer que ele existe e que recompensa aqueles que o buscam\" (Hebreus 11:6).\n\nA fé agrada o coração de Deus. Quando escolhemos confiar nEle, mesmo sem entender tudo, Seu coração se alegra. E Ele promete recompensar os que O buscam com fé.\n\nA recompensa da fé nem sempre é imediata, mas é certa. Deus é fiel para cumprir cada promessa. Continue buscando, continue crendo — a recompensa está a caminho.",

            "José foi vendido pelos irmãos, injustamente preso e esquecido — mas nunca perdeu a fé (Gênesis 37-50). No final, ele disse: \"Vocês planejaram o mal contra mim, mas Deus o tornou em bem.\"\n\nA fé nos permite ver a mão de Deus mesmo nas situações mais injustas. O que parece destruição pode ser Deus preparando algo maior. José não perdeu a fé no processo, e o processo o levou ao palácio.\n\nSe você está no meio de um processo difícil, mantenha a fé. Deus está escrevendo uma história linda com sua vida."
        ],

        .familia: [
            "\"Quanto a mim e à minha casa, serviremos ao Senhor\" (Josué 24:15). Josué fez uma declaração de fé que ecoou por gerações. Ele decidiu que, independente do que outros escolhessem, sua família seria dedicada a Deus.\n\nEssa decisão começa com cada membro da família, mas especialmente com quem lidera. Liderar uma família nos caminhos de Deus não exige perfeição — exige compromisso.\n\nHoje, renove seu compromisso de guiar sua família na fé. Deus honra essa decisão.",

            "\"Instruí o menino no caminho em que deve andar, e até quando envelhecer não se desviará dele\" (Provérbios 22:6). A instrução espiritual dos filhos é um dos maiores investimentos que podemos fazer.\n\nNão se trata apenas de levá-los à igreja — é viver a fé diante deles. Crianças aprendem mais pelo exemplo do que pelas palavras. Quando veem os pais orando, servindo e amando, absorvem esses valores.\n\nComo você está modelando a fé para sua família? Hoje, seja intencional em viver Cristo diante de quem ama.",

            "\"Maridos, amai vossas mulheres, como também Cristo amou a igreja e a si mesmo se entregou por ela\" (Efésios 5:25). O modelo de casamento bíblico é radical: é um amor sacrificial, que coloca o outro antes de si.\n\nIsso vale para ambos os cônjuges. Um casamento forte se constrói com amor que serve, perdoa e se entrega diariamente. Não é um sentimento passageiro — é uma aliança sustentada pela graça.\n\nOre pelo seu casamento ou futuro casamento hoje. Peça a Deus para fortalecê-lo com Seu amor.",

            "\"Filhos, obedecei a vossos pais no Senhor, pois isto é justo\" (Efésios 6:1). A família é o primeiro laboratório de fé. É onde aprendemos obediência, respeito, amor e perdão.\n\nSe há conflitos em sua família, saiba que Deus se especializa em restauração. Ele pode curar feridas familiares que parecem impossíveis. O primeiro passo é sempre a humildade — escolher o amor acima do orgulho.\n\nPeça a Deus hoje para restaurar e fortalecer os laços da sua família.",

            "\"Eis que herança do Senhor são os filhos; o fruto do ventre, seu galardão\" (Salmos 127:3). Filhos são presentes de Deus — uma herança preciosa confiada ao nosso cuidado.\n\nCriar filhos é desafiador, mas é também uma das maiores honras. Cada momento de paciência, cada conversa, cada abraço está formando uma vida. Você está plantando sementes que produzirão frutos por gerações.\n\nHoje, ore por seus filhos (ou pelos filhos da sua família). Cubra-os com oração e declare as promessas de Deus sobre eles.",

            "\"Honra a teu pai e a tua mãe, para que se prolonguem os teus dias na terra que o Senhor, teu Deus, te dá\" (Êxodo 20:12). Este é o primeiro mandamento com promessa. Honrar os pais é tão importante para Deus que Ele vinculou uma bênção específica a esse ato.\n\nHonrar não significa concordar com tudo, mas tratar com respeito, gratidão e amor. Mesmo quando o relacionamento é difícil, podemos escolher honrar.\n\nComo você pode honrar seus pais hoje? Um telefonema, uma palavra de gratidão, uma oração pode fazer toda a diferença.",

            "\"É melhor serem dois do que um, porque têm melhor paga do seu trabalho. Se um cair, o outro levanta o seu companheiro\" (Eclesiastes 4:9-10). Deus nos criou para viver em comunidade, e a família é a primeira comunidade.\n\nNos momentos de queda, é a família que nos levanta. Nos momentos de alegria, é a família que celebra conosco. Fortaleça esses laços — eles são um dos maiores tesouros que Deus nos deu.\n\nHoje, demonstre apreço por alguém da sua família. Um gesto simples de amor pode transformar o dia."
        ],

        .oracao: [
            "Jesus ensinou Seus discípulos a orar com o Pai Nosso (Mateus 6:9-13). Nessa oração simples mas profunda, encontramos todos os elementos essenciais: adoração, submissão, pedido, perdão e proteção.\n\nA oração não precisa ser longa ou eloquente. Precisa ser sincera. Deus não se impressiona com palavras bonitas — Ele se move com corações honestos.\n\nHoje, use o Pai Nosso como guia para sua oração. Medite em cada frase e deixe que o Espírito Santo aprofunde seu significado.",

            "\"Orai sem cessar\" (1 Tessalonicenses 5:17). Como é possível orar o tempo todo? A oração sem cessar não significa estar de joelhos 24 horas — significa manter uma consciência constante da presença de Deus.\n\nÉ conversar com Ele enquanto dirige, agradecer durante o almoço, pedir sabedoria antes de uma reunião, louvá-Lo ao ver o pôr do sol. A oração é uma conversa contínua com o Pai.\n\nHoje, pratique a presença de Deus em cada momento. Fale com Ele como fala com um amigo íntimo.",

            "\"Se o meu povo, que se chama pelo meu nome, se humilhar, e orar, e buscar a minha face, e se converter dos seus maus caminhos, então eu ouvirei dos céus, e perdoarei os seus pecados, e sararei a sua terra\" (2 Crônicas 7:14).\n\nA oração combinada com humildade tem poder transformador — não apenas individual, mas coletivo. Deus promete ouvir, perdoar e curar quando Seu povo ora com coração humilde.\n\nHoje, ore não apenas por si, mas por sua família, sua cidade, sua nação. Suas orações têm alcance eterno.",

            "Daniel orava três vezes ao dia — e nem mesmo um decreto real proibindo a oração pôde impedi-lo (Daniel 6:10). Sua disciplina de oração era tão forte que ele preferiu enfrentar leões a abandoná-la.\n\nA disciplina na oração não é legalismo — é prioridade. É dizer: \"Meu tempo com Deus é inegociável.\" Quando fazemos da oração uma prioridade, tudo mais na vida se organiza.\n\nVocê tem um horário dedicado à oração? Se não, comece hoje. Mesmo 10 minutos diários podem transformar sua vida.",

            "\"Confessai as vossas culpas uns aos outros e orai uns pelos outros, para que sareis. A oração feita por um justo pode muito em seus efeitos\" (Tiago 5:16).\n\nA oração intercessória — orar pelos outros — é uma das formas mais poderosas de amor. Quando oramos por alguém, estamos trazendo essa pessoa diante do trono de Deus e pedindo Sua intervenção.\n\nHá poder real na oração. Não subestime o impacto que suas orações têm na vida de outros. Hoje, ore especificamente por alguém que precisa.",

            "Jesus, nos momentos mais críticos de Sua vida, orou. No Getsêmani, antes da cruz, Ele se prostrou e disse: \"Pai, se queres, passa de mim este cálice; todavia não se faça a minha vontade, mas a tua\" (Lucas 22:42).\n\nA oração mais madura é aquela que submete nossa vontade à vontade de Deus. Não é fácil — Jesus suou gotas de sangue nesse processo. Mas é nessa rendição que encontramos a verdadeira paz.\n\nHoje, em suas orações, acrescente: \"Não a minha vontade, mas a Tua, Senhor.\"",

            "\"Chegai-vos a Deus, e ele se chegará a vós\" (Tiago 4:8). A oração é uma via de mão dupla. Quando nos aproximamos de Deus, Ele se aproxima de nós. Não é um Deus distante ou indiferente — é um Pai que anseia por tempo com Seus filhos.\n\nCada momento de oração é um encontro. Não apenas palavras ao ar, mas uma conversa real com o Deus vivo. Ele ouve, responde e se alegra quando buscamos Sua face.\n\nHoje, aproxime-se de Deus com expectativa. Ele está se aproximando de você."
        ],

        .esperanca: [
            "\"Porque eu bem sei os pensamentos que penso de vós, diz o Senhor; pensamentos de paz e não de mal, para vos dar o fim que esperais\" (Jeremias 29:11). Em meio ao exílio, quando tudo parecia perdido, Deus assegurou ao Seu povo que Ele tinha planos de esperança.\n\nA esperança bíblica não é um otimismo vazio — é uma confiança sólida baseada no caráter de Deus. Ele é fiel, Ele é bom, e Ele tem planos de paz para você.\n\nMesmo que hoje pareça um exílio, Deus não esqueceu de você. Seus planos continuam de pé.",

            "\"As misericórdias do Senhor são a causa de não sermos consumidos; porque as suas misericórdias não têm fim. Novas são cada manhã; grande é a tua fidelidade\" (Lamentações 3:22-23).\n\nCada amanhecer é uma declaração de esperança. As misericórdias de Deus não são recicladas do dia anterior — são completamente novas. Isso significa que não importa como foi ontem; hoje é uma nova oportunidade.\n\nQuando tudo parecer escuro, espere pela manhã. A fidelidade de Deus garante que ela virá.",

            "\"Ora, o Deus de esperança vos encha de todo o gozo e paz em crença, para que abundeis em esperança pela virtude do Espírito Santo\" (Romanos 15:13).\n\nDeus é chamado de \"Deus de esperança\". Isso significa que a esperança não é algo que precisamos produzir por conta própria — é algo que recebemos dEle. O Espírito Santo é quem faz a esperança transbordar em nós.\n\nSe sua esperança está baixa hoje, peça ao Espírito Santo para enchê-lo. Ele é generoso e fará transbordar.",

            "A história de José (Gênesis 37-50) é uma das mais poderosas sobre esperança. Vendido pelos irmãos, escravizado, preso injustamente — mas no final, elevado ao segundo posto mais alto do Egito.\n\nNos piores momentos, a esperança parecia impossível. Mas Deus estava trabalhando nos bastidores o tempo todo. O que os homens planejaram para o mal, Deus transformou em bem.\n\nSe você está no capítulo difícil da sua história, não feche o livro. Os melhores capítulos ainda estão por vir.",

            "\"Bendito o homem que confia no Senhor e cuja esperança é o Senhor. Porque ele é como a árvore plantada junto às águas\" (Jeremias 17:7-8).\n\nA árvore plantada junto às águas não teme a seca. Suas raízes alcançam a fonte, e por isso permanece verde e frutífera mesmo nos tempos difíceis.\n\nQuando sua esperança está ancorada em Deus, as circunstâncias não determinam seu estado. Você pode permanecer firme, verde e frutífero porque sua fonte nunca seca.\n\nAncore sua esperança em Deus hoje — Ele é a fonte que nunca falha."
        ]
    ]

    private static let defaultDevotionals: [String] = [
        "A Palavra de Deus é viva e eficaz. Hebreus 4:12 nos diz que ela é mais cortante que qualquer espada de dois gumes, penetrando até a divisão da alma e do espírito.\n\nQuando mergulhamos nas Escrituras, não estamos apenas lendo um livro — estamos encontrando o próprio Deus. Sua Palavra tem poder para transformar, curar, restaurar e direcionar.\n\nHoje, abra seu coração para que a Palavra cumpra seu propósito em sua vida.",

        "Josué 1:8 nos instrui: \"Não deixe de falar as palavras deste Livro da Lei. Medite nele de dia e de noite, para que você cumpra fielmente tudo o que nele está escrito. Só então os seus caminhos prosperarão e você será bem-sucedido.\"\n\nO segredo do sucesso espiritual não é complexo: meditar na Palavra dia e noite. Isso não significa apenas ler — significa mastigar, refletir, aplicar.\n\nFaça da Palavra sua companheira constante.",

        "\"Toda a Escritura é inspirada por Deus e útil para o ensino, para a repreensão, para a correção e para a instrução na justiça\" (2 Timóteo 3:16).\n\nA Bíblia não é apenas um livro de histórias ou conselhos — é a Palavra inspirada do Deus vivo. Ela ensina, corrige e nos instrui no caminho da justiça.\n\nQuando lemos a Bíblia, estamos ouvindo a voz de Deus falando diretamente conosco. Hoje, leia com ouvidos atentos.",

        "\"Para sempre, ó Senhor, a tua palavra permanece no céu\" (Salmos 119:89). Em um mundo de mudanças constantes, onde tendências vão e vem, onde opiniões mudam a cada dia, a Palavra de Deus permanece inabalável.\n\nEla é a rocha firme sobre a qual podemos construir nossas vidas. Tudo mais pode falhar, mas a Palavra de Deus nunca falhará.\n\nConstrua sua vida sobre essa fundação eterna e inabalável.",

        "\"Lâmpada para os meus pés é a tua palavra e luz para o meu caminho\" (Salmos 119:105). Em momentos de incerteza e confusão, a Palavra de Deus é nosso GPS espiritual.\n\nEla não mostra o caminho inteiro de uma vez — ilumina o suficiente para o próximo passo. E isso é tudo que precisamos. Passo a passo, luz a luz, Deus nos guia.\n\nConfie na Palavra como sua guia hoje. O próximo passo está iluminado.",

        "\"Seca-se a erva, e cai a flor, porém a palavra de nosso Deus subsiste eternamente\" (Isaías 40:8). As flores mais belas murcham, as estrelas mais brilhantes se apagam, mas a Palavra de Deus permanece para sempre.\n\nInvestir tempo na Palavra é investir na eternidade. Cada versículo memorizado, cada promessa abraçada, cada verdade aplicada é um tesouro que não pode ser roubado.\n\nDedique-se hoje à Palavra eterna — ela é seu maior patrimônio espiritual.",

        "\"Não só de pão viverá o homem, mas de toda a palavra que sai da boca de Deus\" (Mateus 4:4). Assim como nosso corpo precisa de alimento diário, nosso espírito precisa da Palavra de Deus.\n\nPular a leitura bíblica é como pular refeições — a princípio não sentimos falta, mas com o tempo ficamos fracos e vulneráveis.\n\nAlimente sua alma hoje. Abra a Palavra e deixe que ela nutra cada área da sua vida."
    ]

    // MARK: - Scripture References Per Category

    private static func scripturesFor(category: PlanCategory, day: Int) -> [String] {
        let refs = scriptureBank[category] ?? defaultScriptures
        return refs[(day - 1) % refs.count]
    }

    private static let scriptureBank: [PlanCategory: [[String]]] = [
        .amor: [
            ["1 Coríntios 13:4-7", "João 3:16"],
            ["Romanos 8:38-39", "1 João 4:19"],
            ["Efésios 5:25", "Cânticos 8:7"],
            ["João 15:12-13", "Gálatas 5:22"],
            ["1 João 4:7-8", "Romanos 13:10"],
            ["Colossenses 3:14", "1 Pedro 4:8"],
            ["Marcos 12:30-31", "Provérbios 10:12"],
            ["1 João 3:16-18", "Deuteronômio 7:9"],
            ["Salmos 136:1", "Jeremias 31:3"],
            ["Mateus 22:37-39", "Romanos 5:8"],
        ],
        .cura: [
            ["Salmos 147:3", "Isaías 53:5"],
            ["Jeremias 17:14", "Êxodo 15:26"],
            ["Marcos 5:34", "Salmos 30:2"],
            ["Mateus 11:28", "2 Crônicas 7:14"],
            ["1 Pedro 2:24", "Salmos 103:2-3"],
            ["Isaías 57:18-19", "Jeremias 33:6"],
            ["Malaquias 4:2", "Provérbios 4:20-22"],
            ["Salmos 41:3", "Lucas 4:18"],
            ["3 João 1:2", "Isaías 58:8"],
            ["Salmos 6:2", "Marcos 10:52"],
            ["Salmos 107:20", "Tiago 5:14-15"],
            ["Apocalipse 21:4", "Isaías 61:1-3"],
        ],
        .ansiedade: [
            ["Filipenses 4:6-7", "1 Pedro 5:7"],
            ["Mateus 6:25-27", "Isaías 41:10"],
            ["Salmos 94:19", "Salmos 55:22"],
            ["João 14:27", "2 Timóteo 1:7"],
            ["Provérbios 12:25", "Mateus 11:28-30"],
            ["Salmos 46:1-2", "Romanos 8:28"],
            ["Salmos 37:5", "Isaías 26:3"],
        ],
        .raiva: [
            ["Efésios 4:26-27", "Provérbios 15:1"],
            ["Tiago 1:19-20", "Colossenses 3:8"],
            ["Provérbios 29:11", "Eclesiastes 7:9"],
            ["Romanos 12:21", "Provérbios 16:32"],
            ["Mateus 5:22-24", "Gálatas 5:19-21"],
            ["Salmos 37:8", "Provérbios 19:11"],
            ["Romanos 12:19", "Efésios 4:31-32"],
        ],
        .depressao: [
            ["Isaías 41:10", "Salmos 139:7-10", "Josué 1:9"],
            ["Salmos 34:18", "Romanos 8:26"],
            ["Salmos 42:11", "2 Coríntios 4:8-9"],
            ["Mateus 11:28", "Salmos 23:4"],
            ["1 Reis 19:4-8", "Salmos 40:1-3"],
            ["Salmos 30:5", "Isaías 61:3"],
            ["Deuteronômio 31:8", "Salmos 27:13-14"],
        ],
        .fe: [
            ["Hebreus 11:1", "Romanos 10:17"],
            ["Gênesis 12:1-4", "Hebreus 11:8"],
            ["2 Coríntios 5:7", "Marcos 11:22-24"],
            ["Mateus 14:29-31", "Hebreus 12:2"],
            ["Mateus 17:20", "Lucas 17:5-6"],
            ["Romanos 10:17", "Tiago 2:17"],
            ["Hebreus 12:1-2", "1 João 5:4"],
            ["1 Samuel 17:45-47", "Salmos 27:1"],
            ["Hebreus 11:6", "Habacuque 2:4"],
            ["Gênesis 50:20", "Romanos 8:28"],
        ],
        .familia: [
            ["Josué 24:15", "Salmos 128:1-4"],
            ["Provérbios 22:6", "Deuteronômio 6:6-7"],
            ["Efésios 5:25-28", "1 Pedro 3:7"],
            ["Efésios 6:1-4", "Colossenses 3:20-21"],
            ["Salmos 127:3-5", "Provérbios 17:6"],
            ["Êxodo 20:12", "Provérbios 23:22"],
            ["Eclesiastes 4:9-12", "Rute 1:16-17"],
        ],
        .oracao: [
            ["Mateus 6:9-13", "Lucas 11:1-4"],
            ["1 Tessalonicenses 5:17", "Efésios 6:18"],
            ["2 Crônicas 7:14", "Jeremias 33:3"],
            ["Daniel 6:10", "Salmos 55:17"],
            ["Tiago 5:16", "Filipenses 4:6"],
            ["Lucas 22:42", "Mateus 26:39"],
            ["Tiago 4:8", "Salmos 145:18"],
        ],
        .esperanca: [
            ["Jeremias 29:11", "Salmos 71:5"],
            ["Lamentações 3:22-23", "Isaías 40:31"],
            ["Romanos 15:13", "1 Pedro 1:3"],
            ["Gênesis 50:20", "Romanos 8:28"],
            ["Jeremias 17:7-8", "Salmos 33:18"],
        ]
    ]

    private static let defaultScriptures: [[String]] = [
        ["Hebreus 4:12", "Josué 1:8"],
        ["Salmos 119:105", "2 Timóteo 3:16"],
        ["Romanos 15:4", "Isaías 40:8"],
        ["Mateus 4:4", "Salmos 119:89"],
        ["João 17:17", "Provérbios 30:5"],
        ["Salmos 19:7-8", "Colossenses 3:16"],
        ["Deuteronômio 8:3", "1 Pedro 1:25"],
    ]
}

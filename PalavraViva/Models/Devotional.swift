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

    static func devotional(for date: Date) -> Devotional {
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: date) ?? 1
        let index = (dayOfYear - 1) % devotionals.count
        return devotionals[index]
    }

    static func recentDevotionals(count: Int = 7) -> [Devotional] {
        let calendar = Calendar.current
        let today = Date()
        return (0..<count).compactMap { offset in
            guard let date = calendar.date(byAdding: .day, value: -offset, to: today) else { return nil }
            return devotional(for: date)
        }
    }

    static let devotionals: [Devotional] = [
        Devotional(
            id: "dev-1",
            title: "Confiando no Plano de Deus",
            scripture: "Porque eu bem sei os planos que tenho a vosso favor, diz o Senhor; planos de paz e não de mal, para vos dar o fim que desejais.",
            scriptureReference: "Jeremias 29:11",
            reflection: "Muitas vezes nos sentimos perdidos, sem saber qual caminho seguir. Mas Deus nos assegura que Ele tem um plano perfeito para cada um de nós. Mesmo quando as circunstâncias parecem confusas, podemos descansar na certeza de que o Senhor está no controle. Seus planos são sempre de paz, nunca de mal. Ele deseja nos dar esperança e um futuro cheio de propósito. Hoje, entregue suas preocupações a Ele e confie que cada passo está sendo guiado por mãos amorosas.",
            prayer: "Senhor, ajuda-me a confiar nos Teus planos, mesmo quando não consigo enxergar o caminho. Sei que Tu és fiel e que cuidas de mim. Entrego meu futuro em Tuas mãos. Amém.",
            theme: "Confiança"
        ),
        Devotional(
            id: "dev-2",
            title: "Força na Fraqueza",
            scripture: "Tudo posso naquele que me fortalece.",
            scriptureReference: "Filipenses 4:13",
            reflection: "Paulo escreveu estas palavras de dentro de uma prisão. Ele não estava em um momento de vitória visível, mas de aparente derrota. Mesmo assim, declarou que tudo podia em Cristo. A força de Deus se aperfeiçoa em nossa fraqueza. Quando você sentir que não tem mais forças para continuar, lembre-se: não é pela sua capacidade, mas pelo poder dAquele que vive em você. Cada desafio é uma oportunidade para experimentar a suficiência da graça divina.",
            prayer: "Pai, quando me sentir fraco, lembra-me de que a Tua força é perfeita em minha fraqueza. Que eu dependa de Ti em todos os momentos. Amém.",
            theme: "Força"
        ),
        Devotional(
            id: "dev-3",
            title: "O Pastor que Cuida",
            scripture: "O Senhor é o meu pastor; nada me faltará. Ele me faz repousar em pastos verdejantes. Leva-me para junto das águas de descanso.",
            scriptureReference: "Salmos 23:1-2",
            reflection: "Imagine um pastor cuidando de suas ovelhas com carinho e dedicação. Assim é o nosso Deus conosco. Ele nos guia a lugares de descanso, nos alimenta e nos protege. Em meio à correria do dia a dia, muitas vezes esquecemos de parar e descansar na presença dEle. Hoje, permita-se ser cuidado pelo Bom Pastor. Ele conhece suas necessidades antes mesmo de você expressá-las. Descanse nEle.",
            prayer: "Senhor, Tu és o meu Pastor. Guia-me aos pastos verdejantes e às águas tranquilas. Que eu encontre descanso em Tua presença hoje. Amém.",
            theme: "Descanso"
        ),
        Devotional(
            id: "dev-4",
            title: "Não Tenha Medo",
            scripture: "Não temas, porque eu sou contigo; não te assombres, porque eu sou o teu Deus; eu te fortaleço, e te ajudo, e te sustento com a minha destra fiel.",
            scriptureReference: "Isaías 41:10",
            reflection: "O medo é um dos maiores inimigos da fé. Ele nos paralisa, rouba nossa paz e nos faz esquecer das promessas de Deus. Mas o Senhor nos diz com clareza: Não temas. Não é um pedido, mas uma ordem baseada em uma promessa — Ele está conosco. Sua mão direita de justiça nos sustenta. Qualquer que seja o medo que você carrega hoje, entregue-o ao Senhor. Ele é maior que qualquer circunstância.",
            prayer: "Deus, remove todo medo do meu coração. Que eu sinta a Tua presença real e poderosa em cada momento de incerteza. Amém.",
            theme: "Coragem"
        ),
        Devotional(
            id: "dev-5",
            title: "Amor Inseparável",
            scripture: "Porque eu estou bem certo de que nem a morte, nem a vida, nem os anjos, nem os principados, nem as coisas do presente, nem do porvir, nem os poderes, nem a altura, nem a profundidade, nem qualquer outra criatura poderá separar-nos do amor de Deus, que está em Cristo Jesus, nosso Senhor.",
            scriptureReference: "Romanos 8:38-39",
            reflection: "Existe um amor que nunca falha, nunca desiste e nunca se cansa de nós. O amor de Deus é incondicional e eterno. Nada neste mundo — nenhuma circunstância, nenhum erro, nenhuma força — é capaz de nos separar desse amor. Nos dias em que você se sentir indigno ou distante, lembre-se: o amor de Deus não depende do que você faz, mas de quem Ele é. E Ele é amor.",
            prayer: "Pai, obrigado pelo Teu amor incondicional. Que eu viva cada dia na certeza de que nada pode me separar de Ti. Amém.",
            theme: "Amor"
        ),
        Devotional(
            id: "dev-6",
            title: "Sabedoria do Alto",
            scripture: "Confia no Senhor de todo o teu coração e não te estribes no teu próprio entendimento. Reconhece-o em todos os teus caminhos, e ele endireitará as tuas veredas.",
            scriptureReference: "Provérbios 3:5-6",
            reflection: "Vivemos em um mundo que valoriza a autossuficiência e o conhecimento próprio. Mas a verdadeira sabedoria começa quando reconhecemos que precisamos de Deus. Confiar de todo o coração significa não reservar uma parte para o nosso controle. Quando entregamos completamente nossos caminhos ao Senhor, Ele promete direcionar nossos passos. Hoje, em cada decisão que tomar, pare e pergunte: Senhor, qual é o Teu caminho?",
            prayer: "Senhor, ensina-me a confiar inteiramente em Ti. Direciona meus passos e dá-me sabedoria para cada decisão. Amém.",
            theme: "Sabedoria"
        ),
        Devotional(
            id: "dev-7",
            title: "O Amor que Transforma",
            scripture: "Porque Deus amou ao mundo de tal maneira que deu o seu Filho unigênito, para que todo o que nele crê não pereça, mas tenha a vida eterna.",
            scriptureReference: "João 3:16",
            reflection: "Este é talvez o versículo mais conhecido da Bíblia, mas sua profundidade é inesgotável. Deus não apenas nos amou com palavras — Ele demonstrou Seu amor com a maior ação possível: deu Seu próprio Filho. Esse amor não é abstrato; ele é concreto, sacrificial e transformador. Quando você meditar sobre este versículo hoje, deixe que a realidade do amor de Deus penetre cada área da sua vida e transforme a forma como você vê a si mesmo e aos outros.",
            prayer: "Obrigado, Senhor, pelo sacrifício do Teu Filho. Que o Teu amor transforme meu coração e transborde para as pessoas ao meu redor. Amém.",
            theme: "Graça"
        ),
        Devotional(
            id: "dev-8",
            title: "Renovação Diária",
            scripture: "As misericórdias do Senhor são a causa de não sermos consumidos; porque as suas misericórdias não têm fim. Novas são cada manhã; grande é a tua fidelidade.",
            scriptureReference: "Lamentações 3:22-23",
            reflection: "Cada novo dia é uma oportunidade de recomeço. As misericórdias de Deus não são recicladas — elas são completamente novas a cada manhã. Independente do que aconteceu ontem, dos erros que cometemos ou das dores que sentimos, hoje é um dia novo. A fidelidade de Deus não tem prazo de validade. Ela se renova constantemente, nos lembrando de que sempre há esperança, sempre há uma nova chance. Abrace o dia de hoje como um presente da graça divina.",
            prayer: "Senhor, obrigado por Tuas misericórdias que se renovam a cada manhã. Ajuda-me a viver este dia com gratidão e esperança renovada. Amém.",
            theme: "Renovação"
        ),
        Devotional(
            id: "dev-9",
            title: "Luz no Caminho",
            scripture: "Lâmpada para os meus pés é a tua palavra e luz para o meu caminho.",
            scriptureReference: "Salmos 119:105",
            reflection: "Em tempos de incerteza, a Palavra de Deus funciona como um farol que ilumina nossos passos. Ela não nos mostra o caminho inteiro de uma vez — como uma lâmpada, ilumina apenas o suficiente para o próximo passo. E isso é tudo que precisamos. Passo a passo, Deus nos guia através de Sua Palavra. Quando o caminho parece escuro e confuso, abra a Bíblia. Nela você encontrará direção, conforto e a certeza de que não caminha sozinho.",
            prayer: "Pai, que a Tua Palavra ilumine cada passo que eu der hoje. Guia-me em Tua verdade e não me deixes tropeçar. Amém.",
            theme: "Direção"
        ),
        Devotional(
            id: "dev-10",
            title: "A Paz que Guarda",
            scripture: "Não andem ansiosos por coisa alguma, mas em tudo, pela oração e súplicas, com ação de graças, apresentem seus pedidos a Deus. E a paz de Deus, que excede todo o entendimento, guardará o coração e a mente de vocês em Cristo Jesus.",
            scriptureReference: "Filipenses 4:6-7",
            reflection: "A ansiedade é o ladrão silencioso da nossa paz. Mas Deus nos oferece um antídoto poderoso: a oração com gratidão. Quando transformamos nossas preocupações em orações e nossas angústias em ações de graças, algo sobrenatural acontece — a paz de Deus, que vai além de toda lógica humana, vem e guarda nosso coração. Essa paz não depende das circunstâncias; ela depende de quem está no controle. E Deus está no controle.",
            prayer: "Senhor, troco minhas ansiedades por Tua paz. Guarda meu coração e minha mente em Cristo Jesus. Amém.",
            theme: "Paz"
        ),
        Devotional(
            id: "dev-11",
            title: "Tempo de Espera",
            scripture: "Mas os que esperam no Senhor renovam as suas forças, sobem com asas como águias, correm e não se cansam, caminham e não se fatigam.",
            scriptureReference: "Isaías 40:31",
            reflection: "Esperar é uma das coisas mais difíceis da vida cristã. Vivemos em um mundo de respostas instantâneas, mas Deus opera em Seu tempo perfeito. A espera no Senhor não é passividade — é confiança ativa. É acreditar que Deus está trabalhando mesmo quando não vemos nada acontecendo. E a promessa é clara: os que esperam no Senhor terão suas forças renovadas. Não apenas mantidas, mas renovadas — como a águia que voa acima das tempestades.",
            prayer: "Deus, ensina-me a esperar em Ti com paciência e confiança. Renova minhas forças enquanto aguardo Teu agir perfeito. Amém.",
            theme: "Paciência"
        ),
        Devotional(
            id: "dev-12",
            title: "Identidade em Cristo",
            scripture: "Assim que, se alguém está em Cristo, nova criatura é: as coisas velhas já passaram; eis que tudo se fez novo.",
            scriptureReference: "2 Coríntios 5:17",
            reflection: "Muitos de nós carregamos rótulos que o mundo colocou sobre nós — fracassado, insuficiente, indigno. Mas quando estamos em Cristo, recebemos uma nova identidade. O velho ficou para trás. Somos nova criatura, com um novo propósito, uma nova história e um novo destino. Você não é definido pelos seus erros passados, pelas opiniões dos outros ou pelas circunstâncias. Você é definido por quem Deus diz que você é: amado, escolhido, perdoado e transformado.",
            prayer: "Senhor, ajuda-me a viver na minha verdadeira identidade em Cristo. Que eu não me defina pelos meus erros, mas pela Tua graça. Amém.",
            theme: "Identidade"
        ),
        Devotional(
            id: "dev-13",
            title: "O Fruto do Espírito",
            scripture: "Mas o fruto do Espírito é: amor, alegria, paz, longanimidade, benignidade, bondade, fidelidade, mansidão, domínio próprio.",
            scriptureReference: "Gálatas 5:22-23",
            reflection: "O fruto do Espírito não é algo que produzimos por esforço próprio — é o resultado natural de uma vida conectada a Deus. Assim como uma árvore não força seus frutos a crescer, nós não precisamos forçar essas qualidades em nossas vidas. Elas brotam naturalmente quando permanecemos em Cristo. Amor, alegria, paz, paciência — todas essas características se desenvolvem à medida que nos rendemos ao Espírito Santo. Hoje, permita que o Espírito flua livremente em você.",
            prayer: "Espírito Santo, produz em mim Teu fruto. Que minha vida reflita o Teu caráter em cada atitude e palavra. Amém.",
            theme: "Espírito"
        ),
        Devotional(
            id: "dev-14",
            title: "Perdão Libertador",
            scripture: "Antes sede uns para com os outros benignos, misericordiosos, perdoando-vos uns aos outros, como também Deus vos perdoou em Cristo.",
            scriptureReference: "Efésios 4:32",
            reflection: "O perdão é um dos atos mais libertadores que podemos praticar. Quando perdoamos, não estamos dizendo que o que aconteceu foi aceitável — estamos nos libertando da prisão da amargura. O ressentimento é como um veneno que tomamos esperando que o outro sofra. Mas Deus nos chama a perdoar como Ele nos perdoou: completamente, sem guardar registro. Perdoar não é fácil, mas é possível com a graça de Deus. E a liberdade que vem depois é indescritível.",
            prayer: "Pai, dá-me a graça de perdoar como Tu me perdoaste. Liberta-me de toda amargura e ressentimento. Amém.",
            theme: "Perdão"
        ),
        Devotional(
            id: "dev-15",
            title: "Armadura de Deus",
            scripture: "Revesti-vos de toda a armadura de Deus, para que possais estar firmes contra as astutas ciladas do diabo.",
            scriptureReference: "Efésios 6:11",
            reflection: "Vivemos uma batalha espiritual real, mas não estamos desprotegidos. Deus nos oferece uma armadura completa: o cinto da verdade, a couraça da justiça, os calçados do evangelho da paz, o escudo da fé, o capacete da salvação e a espada do Espírito. Cada peça tem um propósito específico e todas são essenciais. Hoje, vista-se espiritualmente para enfrentar os desafios do dia. Com a armadura de Deus, você está preparado para vencer qualquer batalha.",
            prayer: "Senhor, reveste-me com Tua armadura completa. Que eu esteja firme em Ti contra toda investida do inimigo. Amém.",
            theme: "Proteção"
        ),
        Devotional(
            id: "dev-16",
            title: "O Poder da Gratidão",
            scripture: "Em tudo dai graças, porque esta é a vontade de Deus em Cristo Jesus para convosco.",
            scriptureReference: "1 Tessalonicenses 5:18",
            reflection: "A gratidão transforma a maneira como vemos a vida. Quando agradecemos em todas as circunstâncias — não por todas, mas em todas — algo muda dentro de nós. A gratidão nos tira do foco nos problemas e nos direciona para as bênçãos. É uma disciplina espiritual que treina nosso coração a reconhecer a bondade de Deus mesmo nos dias difíceis. Hoje, faça uma lista de pelo menos cinco coisas pelas quais você é grato. Você vai se surpreender como isso muda sua perspectiva.",
            prayer: "Senhor, ensina-me a ser grato em todas as circunstâncias. Abre meus olhos para ver Tuas bênçãos que me cercam a cada dia. Amém.",
            theme: "Gratidão"
        ),
        Devotional(
            id: "dev-17",
            title: "Montanhas e Vales",
            scripture: "Ainda que eu ande pelo vale da sombra da morte, não temerei mal algum, porque tu estás comigo; a tua vara e o teu cajado me consolam.",
            scriptureReference: "Salmos 23:4",
            reflection: "A vida cristã não é vivida apenas nos topos das montanhas — muitas vezes estamos caminhando pelos vales. Mas o salmista nos ensina algo poderoso: mesmo no vale mais escuro, não há motivo para temer. Por quê? Porque Deus está conosco. Ele não nos abandona nos vales; na verdade, é nos vales que Sua presença se torna mais real e palpável. Os vales são temporários, mas a presença de Deus é eterna. Continue caminhando — a montanha está logo adiante.",
            prayer: "Senhor, mesmo nos vales, eu confio em Ti. Tua presença é meu maior consolo. Caminha comigo hoje e sempre. Amém.",
            theme: "Consolo"
        ),
        Devotional(
            id: "dev-18",
            title: "Sede de Deus",
            scripture: "Como a corça anseia por águas correntes, assim a minha alma anseia por ti, ó Deus. A minha alma tem sede de Deus, do Deus vivo.",
            scriptureReference: "Salmos 42:1-2",
            reflection: "Existe uma sede que nenhuma conquista, relacionamento ou prazer terreno pode saciar — a sede da alma por Deus. Fomos criados para um relacionamento íntimo com nosso Criador, e quando tentamos preencher esse vazio com qualquer outra coisa, continuamos sedentos. Somente em Deus encontramos satisfação plena. Hoje, em vez de buscar satisfação em coisas passageiras, busque a presença dAquele que é água viva. Ele satisfaz completamente.",
            prayer: "Deus, minha alma tem sede de Ti. Satisfaz meu coração com Tua presença. Que nada neste mundo tome o Teu lugar em minha vida. Amém.",
            theme: "Busca"
        ),
        Devotional(
            id: "dev-19",
            title: "O Bom Combate",
            scripture: "Combati o bom combate, acabei a carreira, guardei a fé.",
            scriptureReference: "2 Timóteo 4:7",
            reflection: "A vida cristã é descrita como um combate — não contra pessoas, mas contra tudo aquilo que nos afasta de Deus. Paulo, ao final de sua jornada, pôde declarar com confiança que havia lutado bem, terminado a corrida e mantido a fé. Essa é a meta de todo cristão. Não se trata de perfeição, mas de perseverança. Os tropeços fazem parte do caminho, mas o que importa é continuar correndo, continuar lutando, continuar crendo. Não desista — a linha de chegada vale cada esforço.",
            prayer: "Senhor, dá-me forças para combater o bom combate e manter a fé até o fim. Que eu persevere com coragem e determinação. Amém.",
            theme: "Perseverança"
        ),
        Devotional(
            id: "dev-20",
            title: "Vasos de Barro",
            scripture: "Temos, porém, este tesouro em vasos de barro, para que a excelência do poder seja de Deus e não de nós.",
            scriptureReference: "2 Coríntios 4:7",
            reflection: "Deus escolheu colocar Seu tesouro mais precioso — o evangelho, Seu Espírito, Sua glória — em vasos de barro. Em nós, frágeis e imperfeitos. Isso não é por acidente. É para que fique claro que o poder extraordinário vem de Deus, não de nós. Suas fraquezas não desqualificam você para ser usado por Deus — na verdade, elas destacam ainda mais o poder dEle. Hoje, não se concentre em suas limitações. Concentre-se no tesouro que habita em você.",
            prayer: "Pai, obrigado por usar este vaso imperfeito para manifestar Tua glória. Que o Teu poder se revele através de mim. Amém.",
            theme: "Humildade"
        ),
        Devotional(
            id: "dev-21",
            title: "Porta Estreita",
            scripture: "Entrai pela porta estreita, porque larga é a porta e espaçoso o caminho que conduz à perdição, e muitos são os que entram por ela.",
            scriptureReference: "Mateus 7:13",
            reflection: "Jesus nos convida a escolher o caminho menos popular, mas o único que leva à vida. A porta estreita exige renúncia, disciplina e fé. O caminho largo é confortável e atraente, mas não conduz onde realmente queremos estar. Seguir a Cristo nem sempre será fácil, nem sempre será compreendido pelos outros, mas é a decisão mais importante que podemos tomar. Escolha hoje o caminho estreito. Ele pode parecer difícil agora, mas o destino é eterno.",
            prayer: "Jesus, dá-me coragem para escolher a porta estreita. Que eu não me deixe seduzir pela facilidade do caminho largo. Amém.",
            theme: "Decisão"
        ),
        Devotional(
            id: "dev-22",
            title: "Sal e Luz",
            scripture: "Vós sois o sal da terra. Vós sois a luz do mundo. Não se pode esconder uma cidade edificada sobre um monte.",
            scriptureReference: "Mateus 5:13-14",
            reflection: "Jesus não disse que devemos tentar ser sal e luz — Ele disse que já somos. Somos sal que preserva e dá sabor a um mundo insípido. Somos luz que brilha nas trevas. Essa é nossa identidade e missão. No trabalho, na família, entre amigos, nas redes sociais — onde quer que estejamos, devemos influenciar para o bem. Não precisamos forçar; apenas precisamos ser quem Deus nos criou para ser. Brilhe hoje. O mundo precisa da sua luz.",
            prayer: "Senhor, que eu seja sal e luz onde quer que eu esteja. Que minha vida aponte outros para Ti. Amém.",
            theme: "Propósito"
        ),
        Devotional(
            id: "dev-23",
            title: "O Oleiro e o Barro",
            scripture: "Mas agora, ó Senhor, tu és nosso Pai; nós somos o barro e tu o nosso oleiro; e todos nós obra das tuas mãos.",
            scriptureReference: "Isaías 64:8",
            reflection: "Deus é o Oleiro e nós somos o barro em Suas mãos. O processo de moldar o barro envolve pressão, água e fogo — não é confortável, mas é necessário. Cada dificuldade, cada desafio, cada lágrima faz parte do processo de nos tornarmos a obra-prima que Deus planejou. Não resista ao trabalho do Oleiro. Ele sabe exatamente o que está fazendo. O resultado final será algo muito mais bonito do que você pode imaginar agora.",
            prayer: "Senhor, eu me rendo às Tuas mãos. Molda-me conforme a Tua vontade. Confio no Teu processo. Amém.",
            theme: "Transformação"
        ),
        Devotional(
            id: "dev-24",
            title: "Rio de Água Viva",
            scripture: "Quem crer em mim, como diz a Escritura, do seu interior fluirão rios de água viva.",
            scriptureReference: "João 7:38",
            reflection: "Jesus promete que daqueles que creem nEle fluirão rios de água viva — o Espírito Santo. Não é um fio de água, não é uma gota, são rios. Abundância de vida, de poder, de transformação. Essa água viva não é apenas para nós — ela deve fluir de nós para abençoar outros. Quando estamos cheios do Espírito, a vida que está em nós transborda naturalmente. Abra-se hoje para ser inundado pela presença de Deus e deixe que Sua vida flua através de você.",
            prayer: "Espírito Santo, enche-me de tal maneira que rios de água viva fluam do meu interior para abençoar todos ao meu redor. Amém.",
            theme: "Plenitude"
        ),
        Devotional(
            id: "dev-25",
            title: "Tempo para Tudo",
            scripture: "Tudo tem o seu tempo determinado, e há tempo para todo o propósito debaixo do céu.",
            scriptureReference: "Eclesiastes 3:1",
            reflection: "Há um tempo para rir e um tempo para chorar. Um tempo para plantar e um tempo para colher. Deus organizou a vida em estações, e cada uma tem seu propósito. Se você está em uma estação de dor, saiba que ela não durará para sempre. Se está em uma estação de alegria, desfrute com gratidão. A sabedoria está em discernir qual estação você está vivendo e cooperar com o que Deus quer fazer em cada uma delas. Confie no tempo de Deus — Ele nunca se atrasa.",
            prayer: "Senhor, ajuda-me a discernir Teus tempos e estações. Dá-me paciência nas esperas e gratidão nas conquistas. Amém.",
            theme: "Tempo"
        ),
        Devotional(
            id: "dev-26",
            title: "A Videira e os Ramos",
            scripture: "Eu sou a videira, vós as varas; quem está em mim, e eu nele, esse dá muito fruto, porque sem mim nada podeis fazer.",
            scriptureReference: "João 15:5",
            reflection: "Um ramo separado da videira seca e morre. Da mesma forma, quando nos desconectamos de Cristo, perdemos nossa fonte de vida e energia espiritual. Permanecer em Cristo não é apenas ir à igreja ou ler a Bíblia — é manter uma conexão viva e constante com Ele através da oração, da adoração e da obediência. Quando permanecemos nEle, o fruto vem naturalmente. Não por esforço, mas por conexão. Hoje, verifique: você está conectado à Videira?",
            prayer: "Jesus, quero permanecer em Ti em todos os momentos. Que eu nunca me desconecte da minha fonte de vida. Amém.",
            theme: "Comunhão"
        ),
        Devotional(
            id: "dev-27",
            title: "Servo Fiel",
            scripture: "Bem está, servo bom e fiel. Sobre o pouco foste fiel, sobre muito te colocarei; entra no gozo do teu senhor.",
            scriptureReference: "Mateus 25:21",
            reflection: "Deus não nos pede para ser bem-sucedidos aos olhos do mundo — Ele nos pede para ser fiéis. Fidelidade no pouco é o que abre as portas para o muito. Talvez hoje você sinta que suas responsabilidades são pequenas, que seu impacto é limitado. Mas Deus vê sua fidelidade nos detalhes. Cada ato de obediência, cada gesto de amor, cada momento de dedicação é registrado e recompensado. Seja fiel onde você está — Deus está preparando o próximo nível para você.",
            prayer: "Senhor, ajuda-me a ser fiel nas pequenas coisas. Que eu honre cada oportunidade que Tu me dás. Amém.",
            theme: "Fidelidade"
        ),
        Devotional(
            id: "dev-28",
            title: "Castelo Forte",
            scripture: "O nome do Senhor é torre forte; os justos correm para ela e estão seguros.",
            scriptureReference: "Provérbios 18:10",
            reflection: "Em tempos antigos, a torre forte era o refúgio mais seguro durante um ataque. Era para lá que todos corriam quando o perigo se aproximava. O nome do Senhor é essa torre para nós. Quando as tempestades da vida nos atingem, não precisamos correr para o medo, para a ansiedade ou para soluções humanas. Podemos correr para o nome de Jesus — e lá encontramos segurança completa. Não importa o tamanho da ameaça; a torre é sempre maior, sempre mais forte.",
            prayer: "Senhor, Tu és minha torre forte. Corro para Ti em todo momento de necessidade. Em Ti estou seguro. Amém.",
            theme: "Refúgio"
        ),
        Devotional(
            id: "dev-29",
            title: "Vencendo o Mundo",
            scripture: "No mundo tereis aflições, mas tende bom ânimo; eu venci o mundo.",
            scriptureReference: "João 16:33",
            reflection: "Jesus foi honesto conosco: neste mundo teremos aflições. Ele não prometeu uma vida sem problemas. Mas Ele acrescentou algo que muda tudo: 'Tende bom ânimo, eu venci o mundo.' A vitória já foi conquistada. As batalhas que enfrentamos hoje já foram vencidas na cruz. Isso não significa ausência de lutas, mas a certeza de que nenhuma luta tem o poder de nos derrotar. Em Cristo, somos mais que vencedores. Enfrente o dia de hoje com essa confiança.",
            prayer: "Jesus, obrigado por já ter vencido o mundo. Dá-me ânimo para enfrentar cada desafio com a certeza da Tua vitória. Amém.",
            theme: "Vitória"
        ),
        Devotional(
            id: "dev-30",
            title: "Tesouros no Céu",
            scripture: "Mas ajuntai tesouros no céu, onde nem a traça nem a ferrugem consomem, e onde os ladrões não minam nem roubam.",
            scriptureReference: "Mateus 6:20",
            reflection: "Vivemos em uma cultura que mede o sucesso por acumulação de bens materiais. Mas Jesus nos convida a ter uma perspectiva eterna. Os tesouros deste mundo são temporários — podem ser roubados, estragados ou perdidos. Mas os tesouros do céu são eternos. Cada ato de bondade, cada oração, cada gesto de generosidade, cada momento dedicado a Deus é um investimento eterno. Reavalie suas prioridades hoje: onde estão seus verdadeiros tesouros?",
            prayer: "Senhor, ajuda-me a investir no que é eterno. Que meu coração esteja onde estão os tesouros do céu. Amém.",
            theme: "Eternidade"
        ),
        Devotional(
            id: "dev-31",
            title: "Águia Renovada",
            scripture: "Ele renova a tua mocidade como a da águia.",
            scriptureReference: "Salmos 103:5",
            reflection: "A águia é uma das aves mais poderosas da natureza. Mas mesmo ela precisa passar por um processo de renovação para continuar voando alto. Da mesma forma, Deus nos renova continuamente. Quando nos sentimos cansados, desgastados pela rotina ou pelas lutas, Ele restaura nossas forças. Sua renovação vai além do físico — Ele renova nossa mente, nosso espírito e nossa esperança. Você pode estar se sentindo exausto hoje, mas Deus promete renovar suas forças. Confie nEle e prepare-se para voar novamente.",
            prayer: "Pai, renova minhas forças como as da águia. Que eu voe acima das tempestades e alcance novas alturas em Ti. Amém.",
            theme: "Renovação"
        ),
    ]
}

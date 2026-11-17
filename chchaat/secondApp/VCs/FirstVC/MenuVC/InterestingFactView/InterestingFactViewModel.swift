import UIKit

struct InterestingFactViewModel {
    let itemTitle: String
    let imageName: String
    
    struct Section {
        let heading: String
        let body: String
        let isHighlighted: Bool
        let quote: String?
    }
    
    var headerTitle: String {
        return itemTitle
    }
    
    var badgeText: String {
        return "Exclusive Insights"
    }
    
    var categoryBadge: String {
        return "Runway & Backstage Insights"
    }
    
    var introText: String {
        switch itemTitle {
        case "Paris Fashion Week Casting":
            return "An exclusive behind-the-scenes look at the rigorous selection procedures, elite aesthetic standards, and high-pressure environment defining Paris Fashion Week run-ups."
        case "Milano Editorial Shoot":
            return "A deep dive into Italian luxury magazine productions, exploring how photographers, stylists, and top-tier models create timeless editorial narratives."
        case "New York Brand Showcase":
            return "Unlocking the fast-paced world of commercial streetwear campaigns in New York, where urban culture meets high-end retail execution."
        case "Tokyo Avant-Garde Show":
            return "An exploration of futuristic conceptual styling and experimental design aesthetics unique to the Tokyo fashion vanguard."
        case "London Haute Couture":
            return "Discovering how London's visionary designers push boundary-breaking concepts into reality through immaculate craftsmanship and portfolio expansion."
        case "Classic Runway":
            return "Mastering the foundational rhythm, posture, and poise required to deliver an unforgettable performance on the global runway."
        case "Editorial Posing":
            return "Unlocking the geometric synergy between body lines, camera angles, and high-impact studio lighting for legendary print features."
        case "High-End Makeup":
            return "Exploring the meticulous skin prep, chemical balance, and professional endurance required during hours in the luxury makeup chair."
        case "Commercial Acting":
            return "Bridging the gap between silent runway presence and expressive on-camera dialogue, micro-expressions, and brand storytelling."
        case "Vogue Masterclass":
            return "Decoding decades of runway evolution, elite stage command, and iconic gaze techniques taught by legendary fashion directors."
        case "Portfolio Building":
            return "Curating a powerful visual resume that balances high fashion editorials, clean beauty shots, and commercial lifestyle frames."
        case "Brand Etiquette":
            return "Navigating public relations, red carpets, media interviews, and digital ambassador conduct with unshakeable poise."
        case "Fitness & Tone":
            return "Designing sustainable body conditioning, core stability, and athletic recovery regimens tailored for grueling international fashion weeks."
        case "Wardrobe Styling":
            return "Mastering fashion history, fabric drapery, and garment care to understand the deep language of designer collections."
        case "Runway Choreography":
            return "Executing complex multi-model formations, precise spacing cues, and synchronized pacing timed to runway soundtracks."
        case "Digital Modeling":
            return "Stepping into motion capture suits, 3D body scanning, and metaverse fashion shows where physical laws transform."
        case "Commercial Print":
            return "Maintaining rapid-fire pacing and relatable consumer appeal across hundreds of high-volume catalog and e-commerce looks."
        case "Lingerie & Swim":
            return "Achieving peak physical definition and absolute stage confidence while carrying minimalist luxury garments under harsh lights."
        case "Haute Couture Art":
            return "Carrying museum-grade sculptural garments that blur the line between fashion collections and live gallery installations."
        case "Global Agency Prep":
            return "Mastering international contracts, mother agency relations, and multi-market strategies across Paris, Milan, New York, and Tokyo."
        default:
            return "A comprehensive master guide exploring core industry techniques, professional standards, and advanced methodologies required for elite career growth."
        }
    }
    
    var sections: [Section] {
        switch itemTitle {
        case "Paris Fashion Week Casting":
            return [
                .init(
                    heading: "The Haute Couture Standard",
                    body: "Paris Fashion Week represents the pinnacle of global fashion artistry. Castings here are notoriously selective, demanding strict adherence to designer specifications, precise height-to-weight proportions, and an unmistakable runway presence that effortlessly complements experimental, avant-garde garments.",
                    isHighlighted: false,
                    quote: nil
                ),
                .init(
                    heading: "Navigating the Capital Circuit",
                    body: "Models face grueling daily schedules, rushing across the French capital from the Marais district to the Grand Palais. Absolute time management, composure under extreme pressure, and maintaining impeccable personal grooming are essential survival traits during peak casting season.",
                    isHighlighted: true,
                    quote: "In Paris, every step on the runway is a direct translation of architectural design into dynamic human motion."
                ),
                .init(
                    heading: "The Rigorous Fitting Process",
                    body: "Once an option or confirmation is secured, fittings can span several hours. Master designers and head stylists mold, pin, and adjust garments directly on the model's physique. Unwavering physical endurance and professional patience are tested to the absolute limit here.",
                    isHighlighted: false,
                    quote: nil
                ),
                .init(
                    heading: "Backstage Choreography & Tempo",
                    body: "Minutes before the lights go up, backstage resembles a controlled storm of hair stylists, makeup artists, dressers, and lead producers. Models must remain hyper-alert, calm, and fully prepared to execute rapid, seamless outfit changes without a single flaw.",
                    isHighlighted: false,
                    quote: nil
                )
            ]
            
        case "Milano Editorial Shoot":
            return [
                .init(
                    heading: "The Italian Heritage of Elegance",
                    body: "Milano editorial productions are steeped in a rich legacy of leathercraft, opulent tailoring, and dramatic visual storytelling. Shoots in this fashion capital prioritize rich textures, high-contrast lighting, and commanding emotional expression from the talent.",
                    isHighlighted: false,
                    quote: nil
                ),
                .init(
                    heading: "Translating Mood Boards to Lens",
                    body: "Unlike fast-paced runway shows, editorial shoots require deep collaboration with the photographer and creative director. Models must understand body angles, micro-expressions, and how fabric interacts with natural and studio lighting setups.",
                    isHighlighted: true,
                    quote: "An editorial image isn't just a photograph; it's a silent film captured in a single fraction of a second."
                ),
                .init(
                    heading: "The Art of Non-Verbal Direction",
                    body: "Top Italian photographers often communicate through subtle cues and physical direction. Developing an intuitive reaction to the camera lens allows a model to deliver high-impact magazine covers that stand out on global newsstands.",
                    isHighlighted: false,
                    quote: nil
                ),
                .init(
                    heading: "Post-Production & Selection Standards",
                    body: "The workflow doesn't end when the shutter stops. Understanding raw image selection, retouching guidelines, and brand alignment helps models build a versatile portfolio that attracts international luxury houses.",
                    isHighlighted: false,
                    quote: nil
                )
            ]
            
        case "New York Brand Showcase":
            return [
                .init(
                    heading: "The Energy of Commercial Streetwear",
                    body: "New York brand showcases blend energetic urban lifestyle with cutting-edge commercial viability. The atmosphere is electric, fast-moving, and driven by digital-first marketing strategies and viral social media moments.",
                    isHighlighted: false,
                    quote: nil
                ),
                .init(
                    heading: "Dynamic Movement & Energy",
                    body: "Unlike traditional static runway walks, streetwear showcases often demand high-energy movement, dynamic pacing, and interactive stage presence that reflects youth culture and modern lifestyle trends.",
                    isHighlighted: true,
                    quote: "Streetwear is the voice of the streets amplified on the global runway."
                ),
                .init(
                    heading: "Commercial Appeal & Brand Identity",
                    body: "Models in this sector must embody the approachable yet aspirational lifestyle of the brand's target demographic, making consumer connection and relatable charisma key assets.",
                    isHighlighted: false,
                    quote: nil
                )
            ]
            
        case "Tokyo Avant-Garde Show":
            return [
                .init(
                    heading: "Defying Conventional Silhouettes",
                    body: "Tokyo's fashion scene is globally celebrated for pushing architectural boundaries, asymmetrical cuts, and conceptual styling that challenges traditional definitions of human form and clothing structure.",
                    isHighlighted: false,
                    quote: nil
                ),
                .init(
                    heading: "The Zen of Controlled Performance",
                    body: "Walking in an avant-garde show requires precise internal timing and intense focus, often while wearing massive sculptural garments or heavy platform footwear that alters natural gravity.",
                    isHighlighted: true,
                    quote: "In avant-garde fashion, silence and posture speak louder than words."
                ),
                .init(
                    heading: "Cultural Fusion & Modernity",
                    body: "Bridging historical Japanese craftsmanship with futuristic cyberpunk subcultures, models act as living canvases for groundbreaking artistic statements.",
                    isHighlighted: false,
                    quote: nil
                )
            ]
            
        case "London Haute Couture":
            return [
                .init(
                    heading: "Rebellious Craftsmanship",
                    body: "London is renowned for nurturing eccentric genius paired with immaculate tailoring traditions. Haute couture here celebrates unconventional textiles, provocative narratives, and uncompromising creative freedom.",
                    isHighlighted: false,
                    quote: nil
                ),
                .init(
                    heading: "Portfolio Expansion & Artistic Vision",
                    body: "Working with London designers allows emerging and established models to showcase incredible versatility, proving their ability to carry historical weight and modern rebellion simultaneously.",
                    isHighlighted: true,
                    quote: "London fashion dares you to be unforgettable."
                )
            ]
            
        case "Classic Runway":
            return [
                .init(
                    heading: "Mastering the Traditional Walk",
                    body: "The classic runway walk is the foundational bedrock of all high fashion presentation. Every step requires absolute equilibrium, balanced core engagement, and steady rhythm timed perfectly to the runway soundtrack.",
                    isHighlighted: false,
                    quote: nil
                ),
                .init(
                    heading: "Posture, Alignment, and Grace",
                    body: "Eliminating shoulder tension while maintaining an elongated spine creates the effortless floating illusion expected by top tier directors.",
                    isHighlighted: true,
                    quote: "True elegance on the runway is the art of making the difficult look completely effortless."
                )
            ]
            
        case "Editorial Posing":
            return [
                .init(
                    heading: "Understanding Camera Angles & Lenses",
                    body: "Different focal lengths distort or enhance body lines. Editorial posing requires real-time geometry awareness to ensure limbs appear elongated and compositions look harmonious.",
                    isHighlighted: false,
                    quote: nil
                ),
                .init(
                    heading: "Creating Tension and Fluidity",
                    body: "Static poses often look lifeless. Successful editorial work relies on continuous micro-movement between shutter clicks, balancing muscular tension with fluid grace.",
                    isHighlighted: true,
                    quote: "The camera captures not just how you look, but the exact energy you emit."
                )
            ]
            
        case "High-End Makeup":
            return [
                .init(
                    heading: "Skin Health & Canvas Preparation",
                    body: "Working with heavy luxury cosmetics requires meticulous daily skincare regimens. Professional models treat their skin as a pristine canvas, ensuring flawless product adherence under harsh studio lights.",
                    isHighlighted: false,
                    quote: nil
                ),
                .init(
                    heading: "Patience in the Makeup Chair",
                    body: "Master makeup artists can spend hours crafting intricate runway looks. Maintaining absolute stillness and composure during extended beauty sessions is a crucial professional skill.",
                    isHighlighted: true,
                    quote: "Beauty styling is chemistry meeting fine art on the human face."
                )
            ]
            
        case "Commercial Acting":
            return [
                .init(
                    heading: "Beyond the Runway: Acting for TV",
                    body: "Commercial acting requires models to transition from silent runway motion to expressive dialogue, character embodiment, and natural performance on camera. Directors look for authentic charm and quick script adaptation.",
                    isHighlighted: false,
                    quote: nil
                ),
                .init(
                    heading: "Micro-Expressions & Voice Projection",
                    body: "Conveying emotion without overacting is a delicate craft. Controlled breathing, vocal clarity, and genuine facial reactions make commercial spots memorable and commercially effective.",
                    isHighlighted: true,
                    quote: "A great commercial performance sells not just a product, but a lifestyle dream."
                )
            ]
            
        case "Vogue Masterclass":
            return [
                .init(
                    heading: "Elite Technique & Legacy",
                    body: "Masterclasses led by industry legends decode decades of runway evolution. Models learn how to command space, manipulate dramatic lighting, and execute iconic poses passed down through generations of fashion icons.",
                    isHighlighted: false,
                    quote: nil
                ),
                .init(
                    heading: "The Power of the Iconic Gaze",
                    body: "Understanding eye contact, facial tension release, and locking focus with the front-row camera pit distinguishes an average model from a legendary cover star.",
                    isHighlighted: true,
                    quote: "Mastering your craft means turning every second on stage into an unforgettable statement."
                )
            ]
            
        case "Portfolio Building":
            return [
                .init(
                    heading: "Curating a Versatile Portfolio",
                    body: "A model's book is their visual resume. Building a powerhouse portfolio requires balancing high fashion editorials, clean beauty shots, commercial lifestyle frames, and raw digital polaroids.",
                    isHighlighted: false,
                    quote: nil
                ),
                .init(
                    heading: "Collaboration with Creative Teams",
                    body: "Working alongside visionary photographers, makeup artists, and stylists during test shoots hones a model's ability to take creative direction and deliver diverse results.",
                    isHighlighted: true,
                    quote: "Your portfolio should tell a diverse story of who you can become on demand."
                )
            ]
            
        case "Brand Etiquette":
            return [
                .init(
                    heading: "Professional PR & Media Relations",
                    body: "In the digital age, a model represents multi-million dollar brands both on and off the runway. Navigating red carpets, press interviews, and public appearances requires poise, tact, and media training.",
                    isHighlighted: false,
                    quote: nil
                ),
                .init(
                    heading: "Digital Presence & Ambassador Conduct",
                    body: "Maintaining professional integrity across social media platforms safeguards long-term relationships with global fashion houses and luxury conglomerates.",
                    isHighlighted: true,
                    quote: "Reputation is built over years of consistent professionalism and lost in a single second."
                )
            ]
            
        case "Fitness & Tone":
            return [
                .init(
                    heading: "Sustainable Body Conditioning",
                    body: "High-end modeling demands rigorous stamina, core stability, and lean muscle tone tailored to specific market requirements rather than extreme crash diets.",
                    isHighlighted: false,
                    quote: nil
                ),
                .init(
                    heading: "Recovery, Nutrition, and Longevity",
                    body: "Balancing intense workout regimes with proper sports nutrition, hydration, and restful sleep ensures models can sustain multi-city fashion week tours without burnout.",
                    isHighlighted: true,
                    quote: "Physical fitness is the engine that powers your professional endurance."
                )
            ]
            
        case "Wardrobe Styling":
            return [
                .init(
                    heading: "Understanding Fashion Theory & Silhouettes",
                    body: "A deep appreciation of fashion history, fabric drapery, and seasonal color palettes allows models to understand why garments move and fit the way they do.",
                    isHighlighted: false,
                    quote: nil
                ),
                .init(
                    heading: "Accessorizing & Garment Care",
                    body: "Treating archival designer pieces with absolute respect during fittings and shows is a non-negotiable hallmark of a seasoned professional.",
                    isHighlighted: true,
                    quote: "To wear clothes well, you must understand the language of the designer."
                )
            ]
            
        case "Runway Choreography":
            return [
                .init(
                    heading: "Synchronized Stage Movement",
                    body: "Complex runway shows often feature intricate multi-model choreography, precise spacing cues, and synchronized pacing timed down to the exact second of the soundtrack.",
                    isHighlighted: false,
                    quote: nil
                ),
                .init(
                    heading: "Pivoting and Finale Formations",
                    body: "Executing flawless turns at the end of the runway and holding formation for the finale designer walk requires spatial awareness and cool-headed precision.",
                    isHighlighted: true,
                    quote: "Choreography turns individual steps into a unified visual masterpiece."
                )
            ]
            
        case "Digital Modeling":
            return [
                .init(
                    heading: "The Rise of Virtual Avatars & CGI",
                    body: "Digital modeling introduces motion capture suits, 3D body scanning, and metaverse fashion shows where physical laws no longer apply to digital garments.",
                    isHighlighted: false,
                    quote: nil
                ),
                .init(
                    heading: "Adapting to Digital Ecosystems",
                    body: "Models now collaborate with tech engineers and game developers to map their likeness, expressions, and runway walks into cutting-edge virtual reality environments.",
                    isHighlighted: true,
                    quote: "The future of fashion exists at the intersection of human grace and digital innovation."
                )
            ]
            
        case "Commercial Print":
            return [
                .init(
                    heading: "Catalog & E-Commerce Efficiency",
                    body: "Commercial print work requires rapid-fire pacing, consistency across hundreds of garment changes per day, and maintaining high energy under bright studio lights.",
                    isHighlighted: false,
                    quote: nil
                ),
                .init(
                    heading: "Selling Through Simplicity",
                    body: "E-commerce success relies on clean, relatable poses that showcase garment fit, fabric texture, and wearability for everyday consumers.",
                    isHighlighted: true,
                    quote: "Commercial print is where aesthetic perfection meets high-volume retail reality."
                )
            ]
            
        case "Lingerie & Swim":
            return [
                .init(
                    heading: "Specialized Fit & Stage Confidence",
                    body: "Lingerie and swimwear presentations demand rigorous physical conditioning, absolute body confidence, and specialized skin preparation under intense stage lighting.",
                    isHighlighted: false,
                    quote: nil
                ),
                .init(
                    heading: "Poise Under Minimalist Attire",
                    body: "Carrying high-impact swimwear or intricate lingerie requires unmatched posture, stage presence, and unwavering self-assurance.",
                    isHighlighted: true,
                    quote: "True confidence shines brightest when you have nothing to hide behind."
                )
            ]
            
        case "Haute Couture Art":
            return [
                .init(
                    heading: "Wearing Museum-Grade Sculptures",
                    body: "Haute couture art pieces often weigh dozens of pounds or feature delicate, hand-stitched elements that require specialized walking techniques and extreme caution.",
                    isHighlighted: false,
                    quote: nil
                ),
                .init(
                    heading: "Performance Art on the Runway",
                    body: "These shows blur the line between fashion and gallery installations, requiring models to embody abstract concepts and avant-garde storytelling.",
                    isHighlighted: true,
                    quote: "Haute couture is wearable sculpture crafted by human imagination."
                )
            ]
            
        case "Global Agency Prep":
            return [
                .init(
                    heading: "Contract Mastery & International Markets",
                    body: "Preparing for global agency placement involves understanding international visa regulations, board expectations in Paris, Milan, New York, and Tokyo, and financial literacy.",
                    isHighlighted: false,
                    quote: nil
                ),
                .init(
                    heading: "Navigating Mother Agencies",
                    body: "Building a solid foundation with your mother agency ensures long-term career protection, mentorship, and strategic international placements.",
                    isHighlighted: true,
                    quote: "A successful international career is built on smart strategy and professional discipline."
                )
            ]
        default:
            return [
                .init(
                    heading: "Core Principles of \(itemTitle)",
                    body: "This comprehensive module focuses on essential technical mastery, industry discipline, and professional etiquette required to excel in this specific domain.",
                    isHighlighted: false,
                    quote: nil
                ),
                .init(
                    heading: "Advanced Execution & Practice",
                    body: "Consistent execution, habit building, and rigorous self-evaluation elevate standard performance to world-class professional standards.",
                    isHighlighted: true,
                    quote: "Excellence is not an act, but a consistent daily habit."
                )
            ]
        }
    }
}

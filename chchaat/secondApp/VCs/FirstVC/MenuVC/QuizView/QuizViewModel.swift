import Foundation

// MARK: - Models
struct Question {
    let text: String
    let options: [String]
    let correctIndex: Int
    let explanation: String
}

struct QuizResultItem {
    let questionText: String
    let selectedAnswer: String
    let correctAnswer: String
    let isCorrect: Bool
    let explanation: String
}

// MARK: - Quiz ViewModel
final class QuizViewModel {
    let itemTitle: String
    
    private(set) var questions: [Question] = []
    var currentIndex = 0
    var userAnswers: [Int: Int] = [:] // [questionIndex: selectedOptionIndex]
    
    var progressText: String {
        return "Question \(currentIndex + 1) of \(questions.count)"
    }
    
    var progressValue: Float {
        guard !questions.isEmpty else { return 0 }
        return Float(currentIndex + 1) / Float(questions.count)
    }
    
    init(itemTitle: String) {
        self.itemTitle = itemTitle
        loadQuestions()
    }
    
    private func loadQuestions() {
        // 1. Paris Fashion Week Casting & Classic Runway & Casting
        if itemTitle.contains("Paris Fashion Week") || itemTitle.contains("Classic Runway") || itemTitle.contains("Casting") {
            questions = [
                Question(
                    text: "What is the primary focus during a high-fashion runway casting?",
                    options: [
                        "Showing off heavy commercial makeup",
                        "Neutral walk, posture, and strong presence",
                        "Talking extensively with the lead designer",
                        "Wearing the loudest streetwear possible"
                    ],
                    correctIndex: 1,
                    explanation: "Runway casting directors look for a neutral, confident walk and strong posture so the clothes stand out."
                ),
                Question(
                    text: "How should models typically prepare their skin and hair for a casting call?",
                    options: [
                        "Heavy theatrical makeup and elaborate hairstyles",
                        "Clean, fresh skin and simple, natural hair",
                        "Complete face paint for artistic impression",
                        "No washing for 3 days to preserve texture"
                    ],
                    correctIndex: 1,
                    explanation: "Casting teams prefer a 'clean canvas' look to easily envision the model in various designer styles."
                ),
                Question(
                    text: "What footwear is standard to bring for a women's fashion week casting?",
                    options: [
                        "Comfortable running sneakers",
                        "Simple high heels (usually pumps or strappy sandals)",
                        "Platform boots with LED lights",
                        "Traditional slippers"
                    ],
                    correctIndex: 1,
                    explanation: "Simple, classic high heels allow casting panels to evaluate your runway walk properly."
                ),
                Question(
                    text: "What documents or digital items should a professional model always carry to a casting?",
                    options: [
                        "Printed physical portfolio, digital comp cards, and ID",
                        "Only a personal diary and autograph book",
                        "Printed school certificates and tax returns",
                        "A collection of physical fashion magazines"
                    ],
                    correctIndex: 0,
                    explanation: "Comp cards and a solid portfolio (or direct tablet/digital access) are essential professional requirements."
                ),
                Question(
                    text: "How should you react if a casting director gives you harsh or unexpected feedback?",
                    options: [
                        "Argue back and defend your personal style",
                        "Stay polite, professional, and accept it gracefully",
                        "Walk out of the room immediately",
                        "Start crying and ask for a second chance"
                    ],
                    correctIndex: 1,
                    explanation: "Professionalism and a positive attitude under pressure are valued just as much as your look."
                ),
                Question(
                    text: "What is a digital comp card often referred to as in modern agency standards?",
                    options: [
                        "A social media meme",
                        "A zed card or digital portfolio link",
                        "A bank routing document",
                        "An airplane boarding pass"
                    ],
                    correctIndex: 1,
                    explanation: "A zed card (comp card) features your best portfolio shots and vital measurements."
                ),
                Question(
                    text: "Why is punctuality critical when arriving at a major fashion week casting?",
                    options: [
                        "Schedules are extremely tight and hundreds of models are waiting",
                        "It doesn't matter, designers always wait for top talent",
                        "So you can spend hours eating free catering",
                        "To chat with other models in the waiting area"
                    ],
                    correctIndex: 0,
                    explanation: "Casting slots run on strict minute-by-minute schedules; being late usually means missing out entirely."
                ),
                Question(
                    text: "What is standard attire for attending a model casting call?",
                    options: [
                        "Baggy oversized hoodies and loose sweatpants",
                        "Form-fitting basics like skinny jeans/leggings and a simple tank top",
                        "Formal evening gowns or tuxedos",
                        "Random vintage costumes"
                    ],
                    correctIndex: 1,
                    explanation: "Fitted basics allow the casting panel to clearly see your body proportions and silhouette."
                ),
                Question(
                    text: "What should you do immediately after finishing your walk in front of the casting panel?",
                    options: [
                        "Ask the designer for a selfie",
                        "Smile, thank them politely, and exit calmly",
                        "Turn around and do a second bonus routine unasked",
                        "Ask about your potential salary on the spot"
                    ],
                    correctIndex: 1,
                    explanation: "A polite thank you and a clean exit leave a professional final impression."
                ),
                Question(
                    text: "How do major agencies verify your height and measurements during initial sign-ins?",
                    options: [
                        "They guess by looking at you from afar",
                        "They measure you accurately with a stadiometer and tape measure in person",
                        "They trust whatever number you type on Instagram",
                        "They check your driver's license only"
                    ],
                    correctIndex: 1,
                    explanation: "Agency bookers always take exact, verified measurements because client requirements are strict."
                )
            ]
        }
        
        // 2. Milano Editorial Shoot
        else if itemTitle.contains("Milano Editorial Shoot") || itemTitle.contains("Editorial Posing") {
            questions = [
                Question(
                    text: "What defines an editorial fashion shoot compared to a commercial lookbook?",
                    options: [
                        "Focus on storytelling, artistic expression, and high concept",
                        "Strict focus on making clothing look wearable for everyday shoppers",
                        "Shooting exclusively indoors using smartphone cameras",
                        "Avoiding any makeup or lighting effects"
                    ],
                    correctIndex: 0,
                    explanation: "Editorial photography prioritizes artistic storytelling and mood over direct retail sales."
                ),
                Question(
                    text: "How should a model work with the camera lens during an editorial session?",
                    options: [
                        "Stare blankly at the floor the entire time",
                        "Vary angles, micro-expressions, and body geometry dynamically",
                        "Freeze in one single pose for 30 minutes",
                        "Keep your eyes completely closed for mystery"
                    ],
                    correctIndex: 1,
                    explanation: "Dynamic movement and control over micro-expressions create engaging editorial frames."
                ),
                Question(
                    text: "What role does wardrobe and styling play in a Milanese high-end editorial?",
                    options: [
                        "It is secondary to casual street clothes",
                        "It drives the narrative, texture, and visual mood of the story",
                        "It is chosen entirely by the model",
                        "It consists of standard corporate office wear"
                    ],
                    correctIndex: 1,
                    explanation: "High-end editorial styling is curated meticulously to tell a powerful visual story."
                ),
                Question(
                    text: "Why is hand placement crucial when posing for magazine covers?",
                    options: [
                        "Hands can distract or frame the face and body lines effectively",
                        "Hands should always be hidden inside pockets",
                        "Hands are never visible in professional photography",
                        "It prevents circulation issues"
                    ],
                    correctIndex: 0,
                    explanation: "Expressive, graceful hands enhance the elegance and composition of a high-fashion shot."
                ),
                Question(
                    text: "What is 'contrapposto' in the context of modeling poses?",
                    options: [
                        "A fast running technique on the runway",
                        "An asymmetric body posture where weight rests on one foot, creating a natural curve",
                        "A specific type of eye makeup application",
                        "A lighting setup used in dark studios"
                    ],
                    correctIndex: 1,
                    explanation: "Contrapposto creates dynamic lines and curves, making static poses look alive and organic."
                ),
                Question(
                    text: "How do you maintain energy during a grueling 10-hour editorial shoot in Milan?",
                    options: [
                        "Drink excessive amounts of sugary energy drinks",
                        "Pace yourself, stay hydrated, and rest your eyes during lighting setups",
                        "Complain loudly to the photographer",
                        "Skip breaks to finish faster"
                    ],
                    correctIndex: 1,
                    explanation: "Pacing and hydration keep your skin fresh and energy high throughout long production days."
                ),
                Question(
                    text: "What is the primary responsibility of the fashion stylist on set?",
                    options: [
                        "Managing the catering and coffee break",
                        "Maintaining garments, pinning fits, and completing the visual aesthetic",
                        "Directing the photographer's camera settings",
                        "Doing hair and makeup"
                    ],
                    correctIndex: 1,
                    explanation: "The stylist ensures clothes look flawless, pinned to perfection, and fit the mood board."
                ),
                Question(
                    text: "How should you interpret a photographer telling you 'less is more'?",
                    options: [
                        "Take off all your clothes immediately",
                        "Simplify your movements and rely on subtle, powerful tension instead of over-posing",
                        "Stop moving and fall asleep",
                        "Speak less on set"
                    ],
                    correctIndex: 1,
                    explanation: "'Less is more' means avoiding frantic shifting and focusing on subtle, intense micro-adjustments."
                ),
                Question(
                    text: "What lighting technique is frequently used in moody Italian editorial spreads?",
                    options: [
                        "Flat fluorescent office lighting",
                        "Dramatic chiaroscuro / directional shadow play",
                        "Direct blinding sunlight with no reflectors",
                        "Green laser lights"
                    ],
                    correctIndex: 1,
                    explanation: "Chiaroscuro creates deep shadows and striking highlights, adding dramatic cinematic depth."
                ),
                Question(
                    text: "What is the best way to review your performance after an editorial shoot?",
                    options: [
                        "Delete all RAW files immediately",
                        "Look at tethered monitor shots on set with the team to adjust angles in real-time",
                        "Wait 6 months until the magazine prints",
                        "Ask friends on Instagram"
                    ],
                    correctIndex: 1,
                    explanation: "Tethered shooting allows the model and photographer to collaborate and refine poses instantly."
                )
            ]
        }
        
        // 3. New York Brand Showcase
        else if itemTitle.contains("New York Brand Showcase") || itemTitle.contains("High-End Makeup") {
            questions = [
                Question(
                    text: "What characterizes a New York streetwear and commercial brand showcase?",
                    options: [
                        "Urban energy, versatile attitude, and modern youth culture vibe",
                        "Strict 18th-century royal court etiquette",
                        "Underwater photography exclusively",
                        "Strictly classical ballet movements"
                    ],
                    correctIndex: 0,
                    explanation: "New York showcases emphasize urban cool, contemporary street culture, and high-energy attitude."
                ),
                Question(
                    text: "How does runway pacing differ in a dynamic New York commercial show compared to haute couture?",
                    options: [
                        "It is much faster, punchier, and energetic to match upbeat music",
                        "It is painfully slow like a funeral march",
                        "Models are required to dance hip-hop routines",
                        "Models must stop and pose for 2 minutes per look"
                    ],
                    correctIndex: 0,
                    explanation: "Commercial and streetwear shows feature a brisk, confident rhythm synchronized with modern beats."
                ),
                Question(
                    text: "Why is skincare especially vital when working with heavy avant-garde or commercial makeup teams?",
                    options: [
                        "To prevent breakouts and ensure smooth product application and removal",
                        "So you don't have to wash your face for a week",
                        "It has no impact on makeup whatsoever",
                        "To change your natural eye color"
                    ],
                    correctIndex: 0,
                    explanation: "Clean, hydrated skin serves as a healthy base for frequent makeup applications and harsh lighting."
                ),
                Question(
                    text: "What is a 'fit session' in the context of brand showcases?",
                    options: [
                        "A gym workout class with the designer",
                        "A pre-show meeting where garments are fitted and altered precisely to your measurements",
                        "A test to see how many pushups you can do",
                        "A running competition"
                    ],
                    correctIndex: 1,
                    explanation: "Fit sessions ensure clothes sit perfectly on your specific frame before show day."
                ),
                Question(
                    text: "How should you handle wardrobe malfunctions (e.g., loose shoes or tearing seams) during a show?",
                    options: [
                        "Scream and stop the show immediately",
                        "Stay calm, maintain your composure, and finish the walk professionally",
                        "Take the clothes off on stage",
                        "Sit down on the runway"
                    ],
                    correctIndex: 1,
                    explanation: "Professional composure under pressure is a hallmark of top-tier runway talent."
                ),
                Question(
                    text: "What is the significance of the 'finale walk'?",
                    options: [
                        "It's when all models return together, led or closed by the top star/designer",
                        "It is a punishment for being late",
                        "It happens before the show even starts",
                        "It means you can run backstage"
                    ],
                    correctIndex: 0,
                    explanation: "The finale is the grand group walk where the designer takes their bow."
                ),
                Question(
                    text: "How should you treat backstage crew, dressers, and makeup artists?",
                    options: [
                        "With absolute respect, kindness, and collaboration",
                        "Ignore them completely as they are below your status",
                        "Boss them around to show authority",
                        "Complain about every single outfit"
                    ],
                    correctIndex: 0,
                    explanation: "Backstage runs on teamwork; treating crew with respect is vital for industry reputation."
                ),
                Question(
                    text: "What is a 'lookbook' shoot usually used for by New York brands?",
                    options: [
                        "Selling wholesale collections to buyers and department stores",
                        "Decorating the designer's personal bedroom",
                        "Wrapping fragile items for shipping",
                        "A bedtime story book"
                    ],
                    correctIndex: 0,
                    explanation: "Lookbooks serve as a commercial catalog for retail buyers and digital e-commerce."
                ),
                Question(
                    text: "What type of facial expression is most common in modern streetwear showcases?",
                    options: [
                        "An exaggerated cartoon smile",
                        "A cool, neutral, or confident 'resting fierce' face",
                        "Crying tears of joy",
                        "Wide-eyed panic"
                    ],
                    correctIndex: 1,
                    explanation: "Streetwear focuses on effortless coolness rather than traditional pageant smiling."
                ),
                Question(
                    text: "How do you prep your hair to prevent static and frizz before a hair-styling session?",
                    options: [
                        "Wash and condition cleanly as instructed by the lead stylist without heavy heavy oils",
                        "Pour olive oil all over it",
                        "Burn the ends slightly",
                        "Never comb it for a month"
                    ],
                    correctIndex: 0,
                    explanation: "Following lead hairstylist prep instructions ensures they can mold your hair easily."
                )
            ]
        }
        
        // 4. Tokyo Avant-Garde Show
        else if itemTitle.contains("Tokyo Avant-Garde") || itemTitle.contains("Commercial Acting") {
            questions = [
                Question(
                    text: "What defines Tokyo's avant-garde fashion and performance style?",
                    options: [
                        "Conceptual boundaries-pushing design, theatrical movement, and futuristic aesthetics",
                        "Boring corporate business suits only",
                        "Traditional beachwear from the 1950s",
                        "Strictly minimalist grey uniforms"
                    ],
                    correctIndex: 0,
                    explanation: "Tokyo avant-garde thrives on artistic rebellion, conceptual silhouettes, and theatrical presentation."
                ),
                Question(
                    text: "How should a model adapt when asked to wear heavy sculptural headpieces or oversized garments?",
                    options: [
                        "Panic and refuse to walk",
                        "Adjust your balance, center of gravity, and spatial awareness to accommodate the weight",
                        "Run as fast as possible down the runway",
                        "Close your eyes and hope for the best"
                    ],
                    correctIndex: 1,
                    explanation: "Sculptural pieces require specialized balance and poise to prevent tipping over."
                ),
                Question(
                    text: "What is the cultural importance of precision and detail in Japanese fashion productions?",
                    options: [
                        "Punctuality, meticulousness, and deep reverence for the craft are paramount",
                        "Chaos and being 2 hours late is expected",
                        "Details do not matter at all",
                        "Rushing through work is encouraged"
                    ],
                    correctIndex: 0,
                    explanation: "Japanese fashion culture places immense value on precision, respect, and meticulous execution."
                ),
                Question(
                    text: "How do you handle directional audio or experimental soundscapes during an avant-garde show?",
                    options: [
                        "Match your internal rhythm and pacing to the emotional arc of the sound design",
                        "Plug your ears with cotton",
                        "Sing along out loud to the music",
                        "Stop walking until the music stops"
                    ],
                    correctIndex: 0,
                    explanation: "Experimental shows use avant-garde soundscapes to guide the model's emotional pacing."
                ),
                Question(
                    text: "What does 'ma' (negative space) mean in Japanese artistic and modeling philosophy?",
                    options: [
                        "A type of spicy noodle dish",
                        "The powerful use of pause, stillness, and empty space in performance",
                        "Running without stopping",
                        "Speaking non-stop on stage"
                    ],
                    correctIndex: 1,
                    explanation: "'Ma' represents the deliberate appreciation of stillness and negative space in art."
                ),
                Question(
                    text: "How should you prepare for quick-changes backstage during a complex conceptual show?",
                    options: [
                        "Panic and hide your clothes",
                        "Stay calm, cooperate closely with dressers, and keep your limbs relaxed",
                        "Run away from the backstage area",
                        "Fall asleep on the floor"
                    ],
                    correctIndex: 1,
                    explanation: "Smooth quick-changes require teamwork, calm focus, and trust in the dresser crew."
                ),
                Question(
                    text: "What kind of footwear is frequently experimented with in Tokyo runway shows?",
                    options: [
                        "Platform geta, tabi boots, or architectural sculptural heels",
                        "Standard muddy rubber boots",
                        "Fuzzy slippers",
                        "Barefoot in snow always"
                    ],
                    correctIndex: 0,
                    explanation: "Tokyo designers often feature traditional-meets-futuristic footwear like tabi boots and platform geta."
                ),
                Question(
                    text: "Why is spatial awareness critical when sharing the runway with other performers in conceptual shows?",
                    options: [
                        "To avoid crashing into props, dancers, or fellow models during intricate choreography",
                        "So you can race past other models",
                        "It isn't important at all",
                        "To steal someone else's spotlight"
                    ],
                    correctIndex: 0,
                    explanation: "Complex staging requires precise timing and spatial coordination to maintain safety and flow."
                ),
                Question(
                    text: "How should you approach expressing a futuristic persona on stage?",
                    options: [
                        "Act like a robotic machine without any emotional depth",
                        "Blend sleek cybernetic stiffness with organic, fluid human grace",
                        "Smile like a pageant contestant",
                        "Cry continuously"
                    ],
                    correctIndex: 1,
                    explanation: "The best avant-garde performances merge robotic precision with striking human emotion."
                ),
                Question(
                    text: "What is the primary goal of participating in an international avant-garde showcase?",
                    options: [
                        "Building a high-profile artistic portfolio and gaining global editorial recognition",
                        "Getting free airplane tickets only",
                        "Avoiding work entirely",
                        "Collecting free shoes"
                    ],
                    correctIndex: 0,
                    explanation: "Avant-garde shows elevate your artistic credibility and position you as a high-fashion chameleon."
                )
            ]
        }
        // 5. London Haute Couture
        else if itemTitle.contains("London Haute Couture") || itemTitle.contains("Vogue Masterclass") {
            questions = [
                Question(
                    text: "What defines London's unique approach to haute couture and design?",
                    options: [
                        "An edgy blend of historic tailoring heritage and rebellious punk-inspired creativity",
                        "Strict adherence to boring corporate office uniforms",
                        "Exclusively wearing sportswear on red carpets",
                        "Avoiding all handmade embroidery and luxury fabrics"
                    ],
                    correctIndex: 0,
                    explanation: "London fashion brilliantly bridges centuries-old Savile Row tailoring with fearless avant-garde rebellion."
                ),
                Question(
                    text: "How should a model present heavily structured and bespoke couture garments?",
                    options: [
                        "With absolute poise, respecting the weight and craftsmanship of the piece",
                        "Rushing down the runway as fast as possible",
                        "Treating the designer dress like a cheap casual t-shirt",
                        "Slouching to look more relaxed"
                    ],
                    correctIndex: 0,
                    explanation: "Bespoke couture requires immense respect, careful posture, and graceful control of heavy fabrics."
                ),
                Question(
                    text: "What is the role of traditional hand-embroidery in haute couture presentations?",
                    options: [
                        "It adds unique texture, luxury, and artistic value that machines cannot replicate",
                        "It is only used to make clothes heavier",
                        "It is completely outdated and banned in London shows",
                        "It serves as a reflector for studio lights"
                    ],
                    correctIndex: 0,
                    explanation: "Hand-embroidery represents the pinnacle of artisan craftsmanship in high-end fashion."
                ),
                Question(
                    text: "How do you maintain proper posture during a lengthy London salon presentation?",
                    options: [
                        "Engage your core, keep shoulders relaxed and back, and maintain steady breathing",
                        "Lean heavily against a wall or pillar for support",
                        "Slump your shoulders to ease back tension",
                        "Cross your arms tightly across your chest"
                    ],
                    correctIndex: 0,
                    explanation: "Core stability and upright posture prevent fatigue during static presentations and slow walks."
                ),
                Question(
                    text: "What is a 'salon-style' runway presentation?",
                    options: [
                        "An intimate, close-up runway show where buyers and press sit inches from the models",
                        "A hair-washing competition backstage",
                        "A show held inside a public hair salon",
                        "An outdoor mud marathon"
                    ],
                    correctIndex: 0,
                    explanation: "Salon shows are intimate gatherings where details of couture garments can be examined up close."
                ),
                Question(
                    text: "Why is emotional restraint important when modeling luxury bespoke collections?",
                    options: [
                        "The clothes and craftsmanship should command the primary attention of the audience",
                        "Models are forbidden from having facial expressions",
                        "So you don't start laughing on stage",
                        "It helps you walk faster"
                    ],
                    correctIndex: 0,
                    explanation: "Controlled, serene expressions ensure the audience focuses on the intricate artistry of the garment."
                ),
                Question(
                    text: "How should you handle delicate silk or tulle gowns backstage?",
                    options: [
                        "With extreme care, avoiding sharp jewelry, long unfiled nails, or snagging",
                        "Pulling them roughly over your head",
                        "Dropping them directly onto the floor",
                        "Spraying them with heavy perfume"
                    ],
                    correctIndex: 0,
                    explanation: "Couture fabrics are fragile and require meticulous handling to prevent costly tears."
                ),
                Question(
                    text: "What makes London fashion week events distinct in terms of venue selection?",
                    options: [
                        "Historic landmarks, subterranean vaults, art galleries, and iconic architectural sites",
                        "Only standard white hospital rooms",
                        "Exclusively fast-food parking lots",
                        "Inside commercial office cubicles"
                    ],
                    correctIndex: 0,
                    explanation: "London designers love staging shows in historic, moody, and unconventional architectural spaces."
                ),
                Question(
                    text: "What is the best way to showcase a sweeping long train on a couture gown?",
                    options: [
                        "A graceful slight pivot or kick at the turn to let the fabric follow naturally",
                        "Kicking the train behind you aggressively with your heel",
                        "Bunching it up in your hands while walking",
                        "Stopping completely and waiting for a dresser"
                    ],
                    correctIndex: 0,
                    explanation: "A smooth pivot allows long trains and heavy skirts to cascade fluidly around your silhouette."
                ),
                Question(
                    text: "How do international model scouts view experience in London haute couture?",
                    options: [
                        "As a prestigious stamp of high-fashion versatility, elegance, and professionalism",
                        "As irrelevant to commercial modeling",
                        "As a sign that you only know how to walk slowly",
                        "As an entry-level test for kids"
                    ],
                    correctIndex: 0,
                    explanation: "Couture experience proves a model can handle high-end pressure, luxury clients, and sophisticated styling."
                )
            ]
        }
        
        // 6. Classic Runway & Posture & Walk
        else if itemTitle.contains("Classic Runway") || itemTitle.contains("Posture & Walk") {
            questions = [
                Question(
                    text: "What is the foundational rule of the classic runway walk (e.g., foot placement)?",
                    options: [
                        "Placing one foot directly in front of the other in a straight centerline (the 'foot-in-front' method)",
                        "Walking like a duck with toes pointing far outward",
                        "Shuffling your feet without lifting them off the ground",
                        "Hopping on alternate feet"
                    ],
                    correctIndex: 0,
                    explanation: "The centerline step creates the iconic rhythmic hip sway required in classic runway modeling."
                ),
                Question(
                    text: "How should a model's arms move during a standard fashion runway walk?",
                    options: [
                        "Natural, relaxed, minimal swing with soft, non-stiff hands",
                        "Swinging wildly like windmill blades",
                        "Stuck rigidly to your sides like a soldier",
                        "Crossed in front of your chest"
                    ],
                    correctIndex: 0,
                    explanation: "Subtle, fluid arm movement balances the body and keeps the focus centered on the clothing."
                ),
                Question(
                    text: "What is 'the turn' at the end of the runway, and why is it critical?",
                    options: [
                        "A crisp, confident pivot that showcases the back of the garment before heading back",
                        "A gymnastics backflip to entertain guests",
                        "A slow 10-minute spinning routine",
                        "Failing to turn and walking off the stage into the crowd"
                    ],
                    correctIndex: 0,
                    explanation: "A clean, sharp turn marks the transition between your outgoing and returning walk."
                ),
                Question(
                    text: "How do you eliminate bouncing or heavy stomping while walking in heels?",
                    options: [
                        "Roll smoothly from heel to toe while engaging your core stability",
                        "Land heavily on your toes every single step",
                        "Bend your knees deeply like a skier",
                        "Wear double socks"
                    ],
                    correctIndex: 0,
                    explanation: "Heel-to-toe rolling action absorbs shock and creates an elegant, floating glide effect."
                ),
                Question(
                    text: "What is 'posture alignment' when checking your stance in front of a mirror?",
                    options: [
                        "Ears aligned over shoulders, shoulders over hips, chest open, chin parallel to floor",
                        "Slumping forward with rounded upper back",
                        "Tidying your hair while leaning sideways",
                        "Bending your knees backward"
                    ],
                    correctIndex: 0,
                    explanation: "Proper vertical alignment prevents back strain and projects unwavering confidence."
                ),
                Question(
                    text: "How should you deal with uneven or slippery runway surfaces?",
                    options: [
                        "Shorten your stride slightly, test the grip, and stay balanced over your center of gravity",
                        "Run as fast as you can to get it over with",
                        "Take off your heels and walk barefoot",
                        "Close your eyes and lean backward"
                    ],
                    correctIndex: 0,
                    explanation: "Adjusting stride length on tricky surfaces prevents slips and maintains graceful composure."
                ),
                Question(
                    text: "What role does eye contact play during a runway presentation?",
                    options: [
                        "Looking just above the heads of the front row (horizon gaze) or connecting with key editors",
                        "Staring intensely into the eyes of a random guest in the front row",
                        "Staring strictly at your own shoes",
                        "Looking up at the ceiling lights"
                    ],
                    correctIndex: 0,
                    explanation: "A horizon gaze projects authority and prevents you from looking timid or distracted."
                ),
                Question(
                    text: "Why is breath control important right before stepping out onto the runway?",
                    options: [
                        "It lowers heart rate, eases pre-show anxiety, and centers your posture",
                        "It inflates your lungs to look bigger",
                        "It makes you dizzy",
                        "It is completely unnecessary"
                    ],
                    correctIndex: 0,
                    explanation: "Deep diaphragmatic breathing calms the nervous system and relaxes tension in the neck and shoulders."
                ),
                Question(
                    text: "What does 'speed pacing' mean for different types of fashion shows?",
                    options: [
                        "Matching your walking tempo to the beat and mood of the soundtrack",
                        "Walking as fast as humanly possible for every show",
                        "Stopping to chat with photographers midway",
                        "Walking at random speeds"
                    ],
                    correctIndex: 0,
                    explanation: "Music sets the pulse; understanding tempo ensures you never rush or lag behind the music."
                ),
                Question(
                    text: "How can practicing with books on your head help improve your runway walk?",
                    options: [
                        "It forces perfect head balance, neck elongation, and upright spinal alignment",
                        "It strengthens your hair roots",
                        "It teaches you how to read while walking",
                        "It is just an old myth with no benefit"
                    ],
                    correctIndex: 0,
                    explanation: "Balancing objects is a classic training drill that trains core stability and posture instantly."
                )
            ]
        }
        
        // 7. Editorial Posing & Camera Angles
        else if itemTitle.contains("Editorial Posing") || itemTitle.contains("Camera Angles") {
            questions = [
                Question(
                    text: "What is 'triangulation' in modeling poses?",
                    options: [
                        "Creating geometric negative spaces with bent elbows and knees (forming triangles)",
                        "Standing like a straight vertical stick",
                        "Shooting photos with three cameras at once",
                        "Drawing triangles on your face with makeup"
                    ],
                    correctIndex: 0,
                    explanation: "Creating angles and triangles with your limbs breaks up stiffness and adds dynamic shape to photos."
                ),
                Question(
                    text: "How do you prevent your arms from looking 'stiff' or 'dead' in photos?",
                    options: [
                        "Keep wrists soft, fingers expressive, and avoid pressing arms flat against your torso",
                        "Glue your arms to your sides",
                        "Punch the air repeatedly",
                        "Keep your fists clenched tightly"
                    ],
                    correctIndex: 0,
                    explanation: "Soft wrists and slight separation from the body create slender, elegant silhouettes."
                ),
                Question(
                    text: "What is the effect of shooting from a low angle (worm's-eye view) on a model?",
                    options: [
                        "It elongates the legs and adds powerful heroic presence and drama",
                        "It makes the model look short and distorted",
                        "It flattens facial features completely",
                        "It has no visual effect"
                    ],
                    correctIndex: 0,
                    explanation: "Low angles emphasize height, stature, and dramatic proportions."
                ),
                Question(
                    text: "How should you angle your face to define your jawline for the camera?",
                    options: [
                        "Slightly push your face forward and tilt your chin down or angle toward the light source",
                        "Tilt your head straight back toward the ceiling",
                        "Press your chin flat against your collarbone",
                        "Look completely sideways"
                    ],
                    correctIndex: 0,
                    explanation: "Pushing the face forward and angling down accentuates bone structure and slims the jaw."
                ),
                Question(
                    text: "What does 'squinch' mean in professional beauty and portrait photography?",
                    options: [
                        "Narrowing your upper eyelids slightly to project confidence and intensity in your gaze",
                        "Closing both eyes tightly in pain",
                        "Crossing your eyes",
                        "Winking constantly"
                    ],
                    correctIndex: 0,
                    explanation: "A 'squinch' eliminates the look of fear or wide-eyed deer-in-headlights vulnerability."
                ),
                Question(
                    text: "Why is weight distribution important when posing standing up?",
                    options: [
                        "Shifting weight to one hip creates an organic S-curve rather than a rigid box shape",
                        "It prevents you from falling over",
                        "Both feet must always bear equal weight",
                        "It has no impact on body lines"
                    ],
                    correctIndex: 0,
                    explanation: "Asymmetrical weight distribution brings life, curves, and natural flow to static poses."
                ),
                Question(
                    text: "How do you work effectively with wind machines on an outdoor editorial shoot?",
                    options: [
                        "Turn your face slightly into or across the airflow, controlling hair movement so it frames your face",
                        "Stand with your back to the wind and close your eyes",
                        "Fight the wind by standing rigidly still",
                        "Cover your face with your hands"
                    ],
                    correctIndex: 0,
                    explanation: "Controlling hair in the wind adds cinematic movement and high-fashion drama."
                ),
                Question(
                    text: "What is the purpose of tethered shooting during a high-end studio session?",
                    options: [
                        "Instantly reviewing high-res captures on a large computer screen to check focus and angles",
                        "Tethering the model to a chair with ropes for safety",
                        "Connecting your smartphone to Wi-Fi",
                        "Charging camera batteries"
                    ],
                    correctIndex: 0,
                    explanation: "Tethering allows the entire creative team to inspect micro-details and adjust poses in real time."
                ),
                Question(
                    text: "How do you express emotion with your body when your face is partially hidden?",
                    options: [
                        "Through posture tension, spinal arching, hand gestures, and shoulder angles",
                        "By shouting instructions to the photographer",
                        "By standing completely limp",
                        "By jumping up and down"
                    ],
                    correctIndex: 0,
                    explanation: "When the face is concealed, body language and posture become your primary storytelling tools."
                ),
                Question(
                    text: "What is the golden rule of transitioning between poses during a continuous shoot?",
                    options: [
                        "Moving slowly and fluidly like a slow-motion video so the photographer catches intermediate frames",
                        "Jumping abruptly from one frozen pose to another like a robot",
                        "Stopping after every shot to check your makeup",
                        "Turning your back to the camera between frames"
                    ],
                    correctIndex: 0,
                    explanation: "Fluid transitions give the photographer usable transitional frames full of genuine motion."
                )
            ]
        }
        
        // 8. High-End Makeup & Beauty Styling
        else if itemTitle.contains("High-End Makeup") || itemTitle.contains("Beauty Styling") {
            questions = [
                Question(
                    text: "What is the key preparation step before sitting in a professional makeup artist's chair?",
                    options: [
                        "Arriving with clean, freshly washed, exfoliated, and lightly moisturized skin",
                        "Applying thick heavy foundation over old makeup",
                        "Skipping all skincare for a week",
                        "Applying permanent face paint"
                    ],
                    correctIndex: 0,
                    explanation: "Clean, prepped skin allows beauty products to blend seamlessly and last longer under studio lights."
                ),
                Question(
                    text: "How do studio lighting conditions affect professional beauty makeup application?",
                    options: [
                        "Lighting washes out colors, so makeup often needs to be more defined and structured",
                        "Studio lights make makeup disappear completely",
                        "Lighting has zero effect on cosmetics",
                        "Lighting turns all makeup neon green"
                    ],
                    correctIndex: 0,
                    explanation: "Powerful flash and studio strobes neutralize contrast, requiring precise contouring and definition."
                ),
                Question(
                    text: "What is the primary goal of editorial beauty close-up photography?",
                    options: [
                        "Showcasing skin texture, intricate makeup artistry, and facial symmetry flawlessly",
                        "Hiding the model's face entirely",
                        "Focusing only on the background scenery",
                        "Testing camera flash durability"
                    ],
                    correctIndex: 0,
                    explanation: "Beauty close-ups highlight micro-details like skin finish, lip gloss precision, and eye makeup symmetry."
                ),
                Question(
                    text: "How should you care for sensitive eyes when wearing heavy false eyelashes or lash extensions?",
                    options: [
                        "Avoid rubbing your eyes, use oil-free removers, and handle delicate lash bands with care",
                        "Pull them off forcefully at the end of the day",
                        "Apply mascara directly over heavy glue",
                        "Swim in chlorinated pools immediately"
                    ],
                    correctIndex: 0,
                    explanation: "Proper lash care preserves natural eyelashes and keeps professional extensions intact."
                ),
                Question(
                    text: "What is 'baking' in modern professional makeup techniques?",
                    options: [
                        "Letting translucent powder sit on the skin for a few minutes to set foundation using body heat",
                        "Baking makeup in an actual kitchen oven",
                        "Applying sunscreen under hot lamps",
                        "Sweating heavily under studio lights"
                    ],
                    correctIndex: 0,
                    explanation: "Baking locks in concealer and foundation for a flawless, crease-free matte finish."
                ),
                Question(
                    text: "Why is hydration crucial for models during multi-look beauty campaign days?",
                    options: [
                        "Dehydrated skin flakes, absorbs makeup poorly, and looks tired under high-res lenses",
                        "It prevents you from getting hungry",
                        "It has no impact on skin appearance",
                        "Water is only needed after work"
                    ],
                    correctIndex: 0,
                    explanation: "Internal hydration plumps skin cells, ensuring a luminous, smooth canvas for cosmetics."
                ),
                Question(
                    text: "How should a model pose for a profile beauty shot (side view)?",
                    options: [
                        "Elongating the neck, relaxing the jaw, and aligning the chin and nose profile cleanly",
                        "Slumping your chin onto your chest",
                        "Staring cross-eyed at your nose",
                        "Turning your head completely backward"
                    ],
                    correctIndex: 0,
                    explanation: "Profile shots rely on clean neck lines and precise head tilt to highlight jaw and nose contours."
                ),
                Question(
                    text: "What is the role of hair styling in a comprehensive beauty campaign?",
                    options: [
                        "Framing the face, balancing facial proportions, and supporting the mood of the makeup",
                        "Covering up the model's ears completely",
                        "Keeping the head warm in cold studios",
                        "Replacing the need for makeup"
                    ],
                    correctIndex: 0,
                    explanation: "Hair and makeup work in unison to frame features and establish the aesthetic narrative."
                ),
                Question(
                    text: "How do you handle accidental makeup smudges on designer clothes during a shoot?",
                    options: [
                        "Inform the stylist or dresser immediately instead of trying to rub it out with water",
                        "Try to hide it with your hand",
                        "Ignore it and hope nobody notices",
                        "Tear the garment off"
                    ],
                    correctIndex: 0,
                    explanation: "Dressers have specialized solvents and tools to remove makeup stains without ruining luxury fabrics."
                ),
                Question(
                    text: "What is the significance of skin undertones (warm, cool, neutral) in beauty shoots?",
                    options: [
                        "Matching foundation and color palettes correctly to prevent skin from looking grey or ash",
                        "Determining your natural hair color",
                        "Choosing what shoes to wear",
                        "Checking your body temperature"
                    ],
                    correctIndex: 0,
                    explanation: "Understanding undertones ensures makeup artists select foundations that look natural and radiant."
                )
            ]
        }
        // 9. Commercial Acting & TV
        else if itemTitle.contains("Commercial Acting") || itemTitle.contains("Fitness & Tone") {
            questions = [
                Question(
                    text: "What is the main objective of commercial acting in video campaigns?",
                    options: [
                        "Selling a product or lifestyle through relatable emotion, facial expressions, and natural delivery",
                        "Reciting Shakespearean monologues in a dramatic tone",
                        "Standing completely motionless like a statue",
                        "Avoiding eye contact with the camera lens"
                    ],
                    correctIndex: 0,
                    explanation: "Commercial acting focuses on commercial appeal, emotional connection, and product storytelling."
                ),
                Question(
                    text: "How should you deliver spoken dialogue in a TV commercial casting?",
                    options: [
                        "Naturally, conversationally, and with genuine enthusiasm as if talking to a friend",
                        "In a loud, robotic monotone shout",
                        "Whispering so quietly nobody can hear",
                        "As fast as humanly possible without breathing"
                    ],
                    correctIndex: 0,
                    explanation: "Casting directors look for authentic, conversational delivery rather than theatrical overacting."
                ),
                Question(
                    text: "What is a 'slate' in a video casting audition?",
                    options: [
                        "A brief introduction where you state your name, agency, and turn to show your profile",
                        "A chalkboard used to write notes",
                        "A type of shoe worn on set",
                        "A special lighting filter"
                    ],
                    correctIndex: 0,
                    explanation: "The slate is your introduction card on video, letting casting teams identify you instantly."
                ),
                Question(
                    text: "How do you project energy and warmth in front of a camera lens?",
                    options: [
                        "By smiling with your eyes ('smizing') and maintaining open, relaxed body language",
                        "By crossing your arms and frowning",
                        "By staring blankly at the microphone",
                        "By jumping up and down continuously"
                    ],
                    correctIndex: 0,
                    explanation: "Warmth and approachability translate instantly through genuine eye expression and posture."
                ),
                Question(
                    text: "What should you do if you stumble on a line during a commercial take?",
                    options: [
                        "Smile naturally, stay in character, and continue or wait for director instruction",
                        "Stop, scream, and storm out of the studio",
                        "Burst into tears",
                        "Blame the camera operator"
                    ],
                    correctIndex: 0,
                    explanation: "Grace under pressure and quick recovery show professional experience on set."
                ),
                Question(
                    text: "Why is physical conditioning and muscle tone important for commercial models?",
                    options: [
                        "It ensures clothes fit impeccably and maintains stamina during long active shoot days",
                        "So you can lift heavy studio equipment",
                        "It has no relevance to commercial modeling",
                        "To qualify for weightlifting competitions"
                    ],
                    correctIndex: 0,
                    explanation: "Good muscle tone and fitness provide the stamina and silhouette required for commercial fitness and apparel."
                ),
                Question(
                    text: "How should you interact with prop products (like a beverage can or phone) on camera?",
                    options: [
                        "Keep labels facing toward the camera lens naturally without blocking your face",
                        "Hide the product behind your back",
                        "Shake the product violently",
                        "Drop it on the floor"
                    ],
                    correctIndex: 0,
                    explanation: "Product placement discipline ensures branding is clearly captured without looking forced."
                ),
                Question(
                    text: "What is an 'improv' test in commercial acting auditions?",
                    options: [
                        "Acting out a short scenario spontaneously based on brief prompt instructions",
                        "Reading a pre-written script word-for-word",
                        "Improvising a song",
                        "Testing your computer programming skills"
                    ],
                    correctIndex: 0,
                    explanation: "Improv tests measure your spontaneity, adaptability, and creative confidence."
                ),
                Question(
                    text: "How do you maintain vocal projection in an open outdoor commercial shoot?",
                    options: [
                        "Using diaphragm support to speak clearly without straining your throat",
                        "Shouting as loud as possible until your voice cracks",
                        "Whispering into a hidden microphone",
                        "Refusing to speak"
                    ],
                    correctIndex: 0,
                    explanation: "Diaphragmic breathing ensures clear audio projection outdoors without vocal fatigue."
                ),
                Question(
                    text: "What is the best mindset when auditioning for multiple commercial roles in one day?",
                    options: [
                        "Deliver your best performance, stay positive, and let go of the outcome immediately",
                        "Obsess over every mistake you made",
                        "Complain about traffic",
                        "Compare yourself negatively to other actors"
                    ],
                    correctIndex: 0,
                    explanation: "A resilient, detached-from-outcome mindset keeps your energy fresh for every opportunity."
                )
            ]
        }
        
        // 10. Vogue Masterclass & Elite Technique
        else if itemTitle.contains("Vogue Masterclass") || itemTitle.contains("Wardrobe Styling") {
            questions = [
                Question(
                    text: "What is the origin and core essence of Vogue dance and performance style?",
                    options: [
                        "A stylized, highly expressive dance form born in Harlem ballroom culture featuring linear poses and dramatic dips",
                        "A classical European ballet routine",
                        "A military marching drill",
                        "A modern yoga stretching class"
                    ],
                    correctIndex: 0,
                    explanation: "Voguing originated from Harlem ballroom culture, mimicking high-fashion magazine poses with rhythmic grace."
                ),
                Question(
                    text: "How do elite models incorporate fashion theory into their posing repertoire?",
                    options: [
                        "By understanding historical silhouettes, garment construction, and era-specific aesthetics",
                        "By wearing random clothes together",
                        "By ignoring the designer's vision completely",
                        "By studying mathematics"
                    ],
                    correctIndex: 0,
                    explanation: "Knowledge of fashion history and garment styling allows models to pose in harmony with the clothing."
                ),
                Question(
                    text: "What is 'hands-to-face' coordination mastery in high-fashion masterclasses?",
                    options: [
                        "Framing facial features symmetrically and gracefully without obscuring expressions",
                        "Hiding your face behind your hands in fear",
                        "Scratching your face during shots",
                        "Touching your hair constantly"
                    ],
                    correctIndex: 0,
                    explanation: "Precise hand placement frames bone structure and elevates high-fashion imagery."
                ),
                Question(
                    text: "How do you project authority and high status on the runway during an elite masterclass show?",
                    options: [
                        "Through unwavering eye contact, controlled posture, and unhurried rhythmic pacing",
                        "By rushing through your walk as fast as possible",
                        "By laughing and waving at friends in the crowd",
                        "By slouching casually"
                    ],
                    correctIndex: 0,
                    explanation: "Control, calm pacing, and powerful posture project elite high-fashion confidence."
                ),
                Question(
                    text: "What is the importance of garment weight distribution in wardrobe styling?",
                    options: [
                        "Knowing how heavy fabrics drape helps you adjust your posture and movement accordingly",
                        "It has no impact on performance",
                        "Heavy clothes should be dragged on the floor",
                        "It determines how fast you can run"
                    ],
                    correctIndex: 0,
                    explanation: "Understanding fabric weight lets you control how skirts and coats flow around your body."
                ),
                Question(
                    text: "What does 'syncing with the beat' mean in elite runway choreography?",
                    options: [
                        "Hitting your turnaround pivot and final pose precisely on the heavy bass drop or musical cue",
                        "Dancing hip-hop routines on stage",
                        "Walking completely out of time with the music",
                        "Stopping the music with your hand"
                    ],
                    correctIndex: 0,
                    explanation: "Synchronizing key milestones to musical beats creates an unforgettable runway spectacle."
                ),
                Question(
                    text: "How should you handle an unexpected wardrobe piece that restricts movement?",
                    options: [
                        "Adapt your stride length and body angles to work with the restriction gracefully",
                        "Refuse to walk on stage",
                        "Rip the restriction off your outfit",
                        "Sit down on the runway"
                    ],
                    correctIndex: 0,
                    explanation: "Professional adaptability ensures restrictive avant-garde pieces still look effortless."
                ),
                Question(
                    text: "What is the role of facial micro-expressions in high-end editorial masterclasses?",
                    options: [
                        "Conveying subtle shifts in emotion, mood, and narrative tension without over-acting",
                        "Making funny faces at the camera",
                        "Keeping a blank expression at all costs",
                        "Crying tears of sadness"
                    ],
                    correctIndex: 0,
                    explanation: "Micro-expressions bring psychological depth and storytelling intrigue to elite portraits."
                ),
                Question(
                    text: "Why is historical fashion reference knowledge valuable for professional models?",
                    options: [
                        "It helps you embody 60s, 70s, or 80s retro aesthetics accurately during themed shoots",
                        "It is only useful for history teachers",
                        "It prevents you from wearing clothes backwards",
                        "It has no practical value"
                    ],
                    correctIndex: 0,
                    explanation: "Knowing era aesthetics allows you to instantly adopt the correct posture and mood for themed collections."
                ),
                Question(
                    text: "What is the ultimate takeaway from an elite Vogue and runway masterclass?",
                    options: [
                        "Developing absolute command over your body, posture, rhythm, and artistic expression",
                        "Learning how to run marathons",
                        "Memorizing clothing brand names",
                        "Collecting free designer shoes"
                    ],
                    correctIndex: 0,
                    explanation: "Masterclasses transform raw potential into polished, versatile professional excellence."
                )
            ]
        }
        
        // 11. Portfolio Building & Brand Etiquette
        else if itemTitle.contains("Portfolio Building") || itemTitle.contains("Brand Etiquette") || itemTitle.contains("Fitness & Tone") {
            questions = [
                Question(
                    text: "What constitutes a strong, professional model portfolio book?",
                    options: [
                        "A curated selection of 10-15 high-quality diverse images showcasing different looks, beauty, and versatility",
                        "A random collection of 200 selfies taken in a bathroom mirror",
                        "Only pictures of your pets and vacation scenery",
                        "A stack of childhood baby photos"
                    ],
                    correctIndex: 0,
                    explanation: "A clean, concise book of diverse professional shots proves your range to casting directors."
                ),
                Question(
                    text: "How should you handle professional networking and communication with agency bookers?",
                    options: [
                        "Be prompt, polite, reliable, and keep your digital portfolio links updated",
                        "Spam bookers with messages every single hour",
                        "Ignore emails and phone calls for days",
                        "Argue about your booking rates aggressively"
                    ],
                    correctIndex: 0,
                    explanation: "Reliability and polite communication are critical traits that keep bookers calling you back."
                ),
                Question(
                    text: "What is 'test shooting' and why is it important for portfolio building?",
                    options: [
                        "Collaborating with photographers, stylists, and makeup artists on experimental shoots to build content",
                        "Taking exams on fashion history",
                        "Testing camera lenses in a factory",
                        "Trying on clothes in a retail store fitting room"
                    ],
                    correctIndex: 0,
                    explanation: "Test shoots allow models and creatives to build their portfolios and experiment with new styles."
                ),
                Question(
                    text: "What is standard professional etiquette when arriving on any new set?",
                    options: [
                        "Arrive early, greet the crew respectfully, check in with the production manager, and prep",
                        "Show up late and demand immediate attention",
                        "Put your headphones on and ignore everyone",
                        "Eat the client's catering before signing in"
                    ],
                    correctIndex: 0,
                    explanation: "Good set etiquette starts with punctuality and respectful greetings to all crew members."
                ),
                Question(
                    text: "How often should you update your digital portfolio and comp card measurements?",
                    options: [
                        "Regularly (every few months or whenever your look, hair, or measurements change)",
                        "Never, keep the same photos for 10 years",
                        "Only once when you retire",
                        "Every single day"
                    ],
                    correctIndex: 0,
                    explanation: "Bookers rely on accurate, current representations of your appearance."
                ),
                Question(
                    text: "What is the proper way to handle confidential information about unreleased fashion collections?",
                    options: [
                        "Keep it strictly confidential, never leak photos or details on social media before the launch",
                        "Post sneak peek selfies on Instagram immediately",
                        "Tell all your friends and family",
                        "Sell photos to gossip magazines"
                    ],
                    correctIndex: 0,
                    explanation: "NDA compliance and discretion protect designer launches and safeguard your professional reputation."
                ),
                Question(
                    text: "Why is maintaining a professional social media presence vital for modern models?",
                    options: [
                        "Casting directors and brands frequently review your digital footprint and engagement as part of casting",
                        "It is only used for posting cat videos",
                        "Social media has zero impact on modeling careers",
                        "To block people who criticize you"
                    ],
                    correctIndex: 0,
                    explanation: "Brands view social channels as an extension of your public persona and marketability."
                ),
                Question(
                    text: "How should you deal with constructive criticism from a photographer or art director?",
                    options: [
                        "Listen attentively, apply the feedback immediately, and thank them for the guidance",
                        "Take it as a personal insult and walk away",
                        "Argue that your way is better",
                        "Ignore them completely"
                    ],
                    correctIndex: 0,
                    explanation: "Openness to direction accelerates your growth and makes you a favorite on collaborative sets."
                ),
                Question(
                    text: "What is the purpose of a model release form on a photo shoot?",
                    options: [
                        "Granting legal permission for the images to be used across specific commercial or editorial channels",
                        "Releasing you from working on the shoot",
                        "A receipt for your paycheck",
                        "An agreement to buy the photographer's camera"
                    ],
                    correctIndex: 0,
                    explanation: "Model releases govern how, where, and for how long captured media can be published."
                ),
                Question(
                    text: "What is the ultimate key to longevity in the global fashion and modeling industry?",
                    options: [
                        "Unwavering professionalism, adaptability, health discipline, and positive attitude",
                        "Being lucky and never practicing",
                        "Arriving late to every show",
                        "Ignoring agency instructions"
                    ],
                    correctIndex: 0,
                    explanation: "Professionalism and adaptability are the true pillars that sustain a long, successful career."
                )
            ]
        }
        // 12. Wardrobe Styling & Fashion Theory
        else if itemTitle.contains("Wardrobe Styling") || itemTitle.contains("Fashion Theory") {
            questions = [
                Question(
                    text: "What is the main objective of fashion theory when applied to personal styling?",
                    options: [
                        "Understanding how silhouettes, historical context, and color theory shape visual perception",
                        "Memorizing clothing brand names",
                        "Ignoring the designer's vision completely",
                        "Studying mathematics"
                    ],
                    correctIndex: 0,
                    explanation: "Understanding fashion history and garment styling allows models to pose in harmony with the clothing."
                ),
                Question(
                    text: "How do color wheels assist wardrobe stylists on commercial sets?",
                    options: [
                        "Selecting complementary or analogous color harmonies that evoke specific emotions or brand identities",
                        "Deciding what time to eat lunch",
                        "Choosing camera shutter speeds",
                        "Matching shoes to car tires"
                    ],
                    correctIndex: 0,
                    explanation: "Color theory helps stylists create harmonious palettes that enhance the mood of the campaign."
                ),
                Question(
                    text: "What is a capsule wardrobe in modern fashion styling?",
                    options: [
                        "A curated collection of versatile, timeless staple items that can be mixed and matched effortlessly",
                        "A suitcase used for space travel",
                        "A medical kit for backstage emergencies",
                        "A box of winter boots"
                    ],
                    correctIndex: 0,
                    explanation: "Capsule wardrobes focus on versatility and timeless essentials."
                ),
                Question(
                    text: "How should a stylist prepare clothes for a fast-paced runway show?",
                    options: [
                        "Steaming, checking for loose buttons, labeling looks by model order, and organizing accessories",
                        "Throwing all items into a pile",
                        "Washing every garment in hot water on show day",
                        "Hiding accessories in boxes"
                    ],
                    correctIndex: 0,
                    explanation: "Meticulous organization and steaming ensure quick, flawless changes backstage."
                ),
                Question(
                    text: "What does the term 'silhouette' refer to in fashion design and modeling?",
                    options: [
                        "The overall outline or shape of a garment when worn on the body",
                        "The brand logo on a tag",
                        "The photographer's shadow",
                        "The lighting setup in a studio"
                    ],
                    correctIndex: 0,
                    explanation: "Silhouette defines the structural lines and geometric shape of fashion pieces."
                ),
                Question(
                    text: "Why is texture mixing important in high-end styling?",
                    options: [
                        "It adds visual depth, dimension, and tactile richness to monochrome or complex outfits",
                        "It makes clothes heavier",
                        "It prevents garments from tearing",
                        "It replaces the need for makeup"
                    ],
                    correctIndex: 0,
                    explanation: "Contrasting textures like leather, silk, and wool elevate the visual appeal of an outfit."
                ),
                Question(
                    text: "What is the primary role of a mood board in fashion styling?",
                    options: [
                        "Visualizing the creative direction, color palette, and inspiration for a shoot or collection",
                        "Keeping track of model attendance",
                        "A menu for the catering crew",
                        "A list of retail store prices"
                    ],
                    correctIndex: 0,
                    explanation: "Mood boards align the entire creative team on the aesthetic vision."
                ),
                Question(
                    text: "How do avant-garde styling choices differ from commercial retail styling?",
                    options: [
                        "Avant-garde prioritizes sculptural, conceptual artistry over everyday wearability",
                        "Avant-garde uses only grey office suits",
                        "There is no difference at all",
                        "Commercial styling is always illegal"
                    ],
                    correctIndex: 0,
                    explanation: "Avant-garde fashion pushes artistic boundaries rather than focusing on mass retail sales."
                ),
                Question(
                    text: "What is the significance of proper layering in winter outerwear shoots?",
                    options: [
                        "Creating structural volume and depth while keeping garments functional and stylish",
                        "Making the model overheat",
                        "Hiding poor posture",
                        "Blocking all studio lighting"
                    ],
                    correctIndex: 0,
                    explanation: "Skillful layering adds rich dimensions to heavy seasonal collections."
                ),
                Question(
                    text: "How should accessories be balanced in a high-fashion look?",
                    options: [
                        "Ensuring they complement rather than overpower the statement pieces of the main garment",
                        "Wearing every piece of jewelry you own at once",
                        "Eliminating all accessories entirely",
                        "Hiding jewelry in your pockets"
                    ],
                    correctIndex: 0,
                    explanation: "Balanced accessories elevate the outfit without distracting from the primary design."
                )
            ]
        }
        
        // 13. Runway Choreography & Stage Movement
        else if itemTitle.contains("Runway Choreography") || itemTitle.contains("Stage Movement") {
            questions = [
                Question(
                    text: "What is the primary purpose of runway choreography during fashion weeks?",
                    options: [
                        "Synchronizing model pacing, spacing, and turns with music and stage design",
                        "Making models run as fast as possible",
                        "Confusing the audience",
                        "Replacing traditional clothing with dance routines"
                    ],
                    correctIndex: 0,
                    explanation: "Choreography unifies the flow, rhythm, and visual presentation of a fashion show."
                ),
                Question(
                    text: "How should models maintain spacing between each other on the runway?",
                    options: [
                        "Keeping a steady, deliberate interval (usually 5-10 seconds) to ensure individual visibility",
                        "Walking right on top of each other's heels",
                        "Stopping midway to chat",
                        "Running past the person ahead of you"
                    ],
                    correctIndex: 0,
                    explanation: "Consistent spacing ensures each look gets its spotlight without crowding."
                ),
                Question(
                    text: "What is a 'T-stage' or 'U-stage' runway layout?",
                    options: [
                        "A stage design with extended walkways allowing audience members a closer 360-degree view",
                        "A straight tunnel underground",
                        "A circular dance floor",
                        "An outdoor parking lot"
                    ],
                    correctIndex: 0,
                    explanation: "Extended stage layouts give guests multiple angles to view the collection."
                ),
                Question(
                    text: "How do you execute a synchronized group finale walk?",
                    options: [
                        "Matching tempo, turning together on cue, and holding formation neatly at the end of the stage",
                        "Pushing past other models to get to the front",
                        "Running off stage immediately",
                        "Sitting down on the runway"
                    ],
                    correctIndex: 0,
                    explanation: "Group synchronization requires precise timing and spatial awareness."
                ),
                Question(
                    text: "What is the role of floor markers (tape or lights) during runway rehearsals?",
                    options: [
                        "Guiding models precisely where to stop, pose, and turn for photographers",
                        "Decorating the floor",
                        "Marking where catering is located",
                        "Showing where shoes should be left"
                    ],
                    correctIndex: 0,
                    explanation: "Floor markers ensure photographers capture clean, perfectly framed shots."
                ),
                Question(
                    text: "How should you adjust your movement if the runway features stairs or elevated platforms?",
                    options: [
                        "Looking ahead, lifting your hem slightly if needed, and stepping with secure footing",
                        "Closing your eyes and running blindly",
                        "Looking down at your feet the entire time",
                        "Refusing to walk"
                    ],
                    correctIndex: 0,
                    explanation: "Prepared footing prevents stumbles on complex architectural runways."
                ),
                Question(
                    text: "What is the best way to handle abrupt changes in choreography instructions before a show?",
                    options: [
                        "Staying calm, listening closely to the stage manager, and practicing the new cues immediately",
                        "Arguing with the choreographer",
                        "Walking out of the backstage area",
                        "Crying in the corner"
                    ],
                    correctIndex: 0,
                    explanation: "Adaptability under pressure is essential in high-stakes backstage environments."
                ),
                Question(
                    text: "How does stage lighting affect your runway visibility and navigation?",
                    options: [
                        "Bright spotlights can cause temporary glare; looking past the lights prevents disorientation",
                        "It blinds you permanently",
                        "It makes the runway invisible",
                        "It has no effect"
                    ],
                    correctIndex: 0,
                    explanation: "A horizon gaze helps you navigate cleanly past blinding stage strobes and spots."
                ),
                Question(
                    text: "Why is rhythm and musicality essential for stage movement?",
                    options: [
                        "It helps you hit your marks, pivots, and poses in perfect harmony with the soundtrack",
                        "So you can sing along while walking",
                        "It is completely optional",
                        "To drown out audience noise"
                    ],
                    correctIndex: 0,
                    explanation: "Musicality gives the runway walk its magnetic, hypnotic rhythm."
                ),
                Question(
                    text: "What is the etiquette during backstage runway alignment before going on stage?",
                    options: [
                        "Staying quiet, listening to line-up coordinators, and being ready when your look number is called",
                        "Shouting across the room",
                        "Wandering around looking for snacks",
                        "Sleeping through your lineup call"
                    ],
                    correctIndex: 0,
                    explanation: "Orderly line-ups prevent delays and keep the show running on schedule."
                )
            ]
        }
        
        // 14. Digital Modeling & Virtual Avatars
        else if itemTitle.contains("Digital Modeling") || itemTitle.contains("Virtual Avatars") {
            questions = [
                Question(
                    text: "What is digital modeling and the use of virtual avatars in modern fashion?",
                    options: [
                        "Creating 3D CGI models and virtual twins for digital runways, gaming, and metaverses",
                        "Editing photos in Photoshop only",
                        "Playing video games backstage",
                        "Printing paper catalogs"
                    ],
                    correctIndex: 0,
                    explanation: "Digital modeling merges fashion with CGI technology for virtual spaces and metaverses."
                ),
                Question(
                    text: "How are 3D body scans utilized in digital fashion production?",
                    options: [
                        "Creating accurate virtual avatars of real models for digital clothing fittings and simulations",
                        "Checking your body weight",
                        "Printing plastic action figures",
                        "Designing shoe soles"
                    ],
                    correctIndex: 0,
                    explanation: "Scans capture precise proportions to simulate realistic digital garment draping."
                ),
                Question(
                    text: "What is the role of motion capture (mocap) suits in virtual avatar animation?",
                    options: [
                        "Recording real human runway walks and facial expressions to animate 3D digital characters",
                        "Keeping models warm in cold studios",
                        "Measuring body fat percentage",
                        "Protecting clothes from stains"
                    ],
                    correctIndex: 0,
                    explanation: "Mocap translates live human movement into fluid digital animations."
                ),
                Question(
                    text: "Why are fashion brands investing in virtual clothing and digital showrooms?",
                    options: [
                        "Reducing physical waste, lowering production costs, and reaching global digital audiences",
                        "Because physical clothes are banned",
                        "To avoid hiring photographers",
                        "To save electricity"
                    ],
                    correctIndex: 0,
                    explanation: "Digital fashion offers sustainable, scalable alternatives to physical samples."
                ),
                Question(
                    text: "What skills do physical models need when transitioning to digital/AR modeling?",
                    options: [
                        "Understanding virtual camera angles, digital posing restraint, and avatar tracking limitations",
                        "Knowing how to write computer code",
                        "Building computer hardware",
                        "Playing professional video games"
                    ],
                    correctIndex: 0,
                    explanation: "AR and virtual shoots require precise coordination with digital tracking markers."
                ),
                Question(
                    text: "What is a 'digital twin' in the modeling and fashion tech industry?",
                    options: [
                        "A high-fidelity virtual replica of a physical garment or human model used in virtual spaces",
                        "An identical twin sibling who also models",
                        "A backup smartphone",
                        "A printed photo book"
                    ],
                    correctIndex: 0,
                    explanation: "Digital twins mirror physical assets in virtual simulations and metaverses."
                ),
                Question(
                    text: "How do virtual runway shows differ from traditional physical fashion weeks?",
                    options: [
                        "They leverage CGI environments, zero-gravity physics, and immersive digital graphics",
                        "They take place in dark basements",
                        "Models walk much slower",
                        "There is no music"
                    ],
                    correctIndex: 0,
                    explanation: "Virtual shows break physical laws, allowing impossible CGI backdrops and physics."
                ),
                Question(
                    text: "What software or technology powers real-time cloth simulation on digital avatars?",
                    options: [
                        "Advanced physics engines that replicate gravity, tension, and fabric elasticity",
                        "Standard text editors",
                        "Web browsers",
                        "Spreadsheet software"
                    ],
                    correctIndex: 0,
                    explanation: "Physics engines calculate how threads bend, stretch, and fold in real time."
                ),
                Question(
                    text: "What is the significance of NFTs and blockchain in digital fashion ownership?",
                    options: [
                        "Certifying authenticity, digital ownership, and provenance of virtual couture garments",
                        "Paying for backstage catering",
                        "Booking airline tickets",
                        "Printing comp cards"
                    ],
                    correctIndex: 0,
                    explanation: "Blockchain verifies the unique ownership of rare digital designer pieces."
                ),
                Question(
                    text: "How do casting directors select talent for hybrid digital-physical campaigns?",
                    options: [
                        "Looking for versatility in both live runway presence and digital/3D scan readiness",
                        "Choosing only gamers",
                        "Checking video game scores",
                        "Ignoring digital portfolios"
                    ],
                    correctIndex: 0,
                    explanation: "Hybrid campaigns require talent comfortable in both physical and virtual realms."
                )
            ]
        }
        
        // 15. Commercial Print & Catalog & E-Comm
        else if itemTitle.contains("Commercial Print") || itemTitle.contains("Catalog & E-Comm") {
            questions = [
                Question(
                    text: "What is the primary goal of commercial print and e-commerce modeling?",
                    options: [
                        "Displaying retail garments clearly and accurately to drive online sales and catalog purchases",
                        "Creating abstract conceptual art",
                        "Winning film awards",
                        "Showing off extreme avant-garde makeup"
                    ],
                    correctIndex: 0,
                    explanation: "E-commerce photography focuses on clean garment presentation to boost retail sales."
                ),
                Question(
                    text: "How does posing for e-commerce differ from high-fashion editorial?",
                    options: [
                        "E-commerce requires clean, repeatable, standardized poses that show garment details clearly",
                        "E-commerce requires bizarre body contortions",
                        "You must keep your eyes closed in e-commerce",
                        "There is no difference"
                    ],
                    correctIndex: 0,
                    explanation: "Retail shoppers need to see the fit, cut, and details of the clothing clearly."
                ),
                Question(
                    text: "What is a 'ghost mannequin' or invisible mannequin shoot?",
                    options: [
                        "A photography technique where garments appear filled out without a visible human model or mannequin",
                        "A spooky Halloween photoshoot",
                        "A runway show with invisible clothes",
                        "Shooting in total darkness"
                    ],
                    correctIndex: 0,
                    explanation: "Ghost mannequin shots give 3D shape to clothing items on retail websites."
                ),
                Question(
                    text: "Why is speed and efficiency critical during high-volume e-commerce studio shoots?",
                    options: [
                        "Shooting dozens or hundreds of outfits per day requires rapid posing and quick clothing changes",
                        "To finish work early and go home",
                        "Because cameras break quickly",
                        "So you don't have to wear makeup"
                    ],
                    correctIndex: 0,
                    explanation: "High-volume retail production runs on tight daily shot-count quotas."
                ),
                Question(
                    text: "What facial expression is typically expected in commercial catalog print work?",
                    options: [
                        "An approachable, warm, friendly smile or soft neutral look that appeals to mass consumers",
                        "An angry scowl",
                        "Crying tears of sadness",
                        "A blank stare into space"
                    ],
                    correctIndex: 0,
                    explanation: "Commercial work relies on warm, relatable expressions that connect with everyday shoppers."
                ),
                Question(
                    text: "How do commercial print models maintain consistency across multiple product categories?",
                    options: [
                        "Keeping skin, hair, and makeup neutral and versatile for diverse brand guidelines",
                        "Changing hair color every hour",
                        "Wearing heavy theatrical face paint",
                        "Refusing to change outfits"
                    ],
                    correctIndex: 0,
                    explanation: "A clean, versatile canvas allows brands to feature different product lines seamlessly."
                ),
                Question(
                    text: "What is the importance of fit in commercial catalog modeling?",
                    options: [
                        "Ensuring standard sizes fit properly so online buyers receive accurate representations",
                        "Wearing clothes three sizes too big",
                        "It has no importance",
                        "Tearing garments to look distressed"
                    ],
                    correctIndex: 0,
                    explanation: "Accurate fit prevents high customer return rates for online retail stores."
                ),
                Question(
                    text: "How should you interact with lifestyle props on commercial e-comm sets?",
                    options: [
                        "Using them naturally and casually to create an authentic everyday lifestyle narrative",
                        "Ignoring them completely",
                        "Hiding them behind your back",
                        "Throwing them at the photographer"
                    ],
                    correctIndex: 0,
                    explanation: "Natural interaction with props builds an inviting, lifestyle-driven brand story."
                ),
                Question(
                    text: "What lighting is standard for clean commercial retail photography?",
                    options: [
                        "Bright, even, shadow-free studio lighting that shows true fabric colors and textures",
                        "Dark moody shadows",
                        "Neon green laser lights",
                        "Flashing strobe lights in total darkness"
                    ],
                    correctIndex: 0,
                    explanation: "Even, bright lighting displays accurate color representation for online buyers."
                ),
                Question(
                    text: "Why do e-commerce clients value reliable, punctual, and low-maintenance models?",
                    options: [
                        "Tight production schedules rely on smooth teamwork to meet strict retail launch deadlines",
                        "So they don't have to pay them",
                        "It makes no difference to clients",
                        "To avoid talking to agents"
                    ],
                    correctIndex: 0,
                    explanation: "Commercial studios operate like clockwork; reliability keeps you booked."
                )
            ]
        }
        
        // 16. Lingerie & Swim & Specialized Fit
        else if itemTitle.contains("Lingerie & Swim") || itemTitle.contains("Specialized Fit") {
            questions = [
                Question(
                    text: "What is the key requirement for success in specialized fit, lingerie, and swimwear modeling?",
                    options: [
                        "High body confidence, rigorous physical conditioning, and professional boundary management",
                        "Wearing heavy winter coats",
                        "Avoiding all exercise",
                        "Covering up completely"
                    ],
                    correctIndex: 0,
                    explanation: "Specialized fit and swimwear modeling demand strict fitness discipline and strong confidence."
                ),
                Question(
                    text: "How do you maintain poise and confidence during swimwear or lingerie castings?",
                    options: [
                        "Focusing on professional posture, clean lines, and treating the fitting like any other high-end job",
                        "Apologizing for your appearance",
                        "Hiding in the dressing room",
                        "Complaining about the lighting"
                    ],
                    correctIndex: 0,
                    explanation: "Treating specialized castings with clinical professionalism projects supreme confidence."
                ),
                Question(
                    text: "What is a 'fit model' in the garment manufacturing industry?",
                    options: [
                        "A model with exact specific measurements used by designers to test how clothes fit before mass production",
                        "A model who only works at the gym",
                        "A fitness coach",
                        "A runway choreographer"
                    ],
                    correctIndex: 0,
                    explanation: "Fit models are the industry standard for testing garment comfort and proportions."
                ),
                Question(
                    text: "Why is skin care and tan maintenance important for specialized swimwear shoots?",
                    options: [
                        "Ensuring a smooth, even complexion without harsh tan lines unless specifically requested",
                        "So you don't have to wear makeup",
                        "It has no impact on photos",
                        "To change your eye color"
                    ],
                    correctIndex: 0,
                    explanation: "Clean, even skin finishes prevent distracting marks under high-res cameras."
                ),
                Question(
                    text: "How do you handle on-set privacy and professional boundaries during intimate apparel shoots?",
                    options: [
                        "Working only with reputable crews, checking contracts, and communicating comfort levels clearly",
                        "Accepting any shoot without reading contracts",
                        "Refusing to work with photographers",
                        "Isolating yourself from everyone"
                    ],
                    correctIndex: 0,
                    explanation: "Clear boundaries and reputable agencies guarantee a safe, professional working environment."
                ),
                Question(
                    text: "What lighting techniques are used to highlight physique and fabric in swimwear photography?",
                    options: [
                        "Sculpting light with softboxes and reflectors to emphasize muscle tone and clean silhouettes",
                        "Turning off all studio lights",
                        "Using harsh green spotlights",
                        "Shooting in pitch black"
                    ],
                    correctIndex: 0,
                    explanation: "Reflectors and soft light sculpt athletic proportions and fabric textures."
                ),
                Question(
                    text: "How should you pose to elongate the body in swimwear and lingerie photography?",
                    options: [
                        "Arching the back slightly, pointing toes, and extending limbs to create graceful curves",
                        "Slumping your shoulders forward",
                        "Squatting down low",
                        "Crossing your arms tightly"
                    ],
                    correctIndex: 0,
                    explanation: "Extended limbs and subtle spinal arches emphasize graceful body lines."
                ),
                Question(
                    text: "What is the importance of swimwear fabric elasticity during active water or beach shoots?",
                    options: [
                        "Ensuring garments stay secure, fitted, and comfortable during dynamic movement",
                        "So the fabric stretches infinitely",
                        "It has no importance",
                        "To make garments waterproof"
                    ],
                    correctIndex: 0,
                    explanation: "High elasticity prevents wardrobe slips during active water and surf photography."
                ),
                Question(
                    text: "How do fit models assist clothing designers during technical prototyping?",
                    options: [
                        "Providing precise feedback on tightness, comfort, and mobility across various body movements",
                        "Designing the clothes themselves",
                        "Sewing the buttons by hand",
                        "Selling the clothes to buyers"
                    ],
                    correctIndex: 0,
                    explanation: "Fit feedback is crucial for perfecting commercial garment comfort and sizing."
                ),
                Question(
                    text: "What is standard professional etiquette when working on intimate apparel sets?",
                    options: [
                        "Maintaining a respectful, professional atmosphere and utilizing dressing robes between takes",
                        "Walking around set uncovered all day",
                        "Ignoring the crew",
                        "Complaining about wardrobe"
                    ],
                    correctIndex: 0,
                    explanation: "Using robes between setups maintains comfort and professionalism on set."
                )
            ]
        }
        
        // 17. Haute Couture Art & Conceptual Art
        else if itemTitle.contains("Haute Couture Art") || itemTitle.contains("Conceptual Art") {
            questions = [
                Question(
                    text: "What defines haute couture conceptual art and wearable sculpture in fashion?",
                    options: [
                        "Pushing the boundaries of traditional tailoring into surreal, artistic masterpieces",
                        "Making basic white t-shirts",
                        "Designing office uniforms",
                        "Skipping all garment creation"
                    ],
                    correctIndex: 0,
                    explanation: "Wearable sculptures treat clothing as fine art rather than everyday apparel."
                ),
                Question(
                    text: "How should a model approach walking with extreme avant-garde wearable art?",
                    options: [
                        "Treating the garment as an interactive sculpture, pacing carefully to support its weight and structure",
                        "Running as fast as possible",
                        "Dragging the art piece on the floor roughly",
                        "Stopping and taking it off"
                    ],
                    correctIndex: 0,
                    explanation: "Sculptural garments require careful balance and respect for fragile artistic construction."
                ),
                Question(
                    text: "What is the role of museums and galleries in showcasing haute couture art?",
                    options: [
                        "Displaying legendary fashion creations as recognized fine art pieces alongside sculptures and paintings",
                        "Selling discount clothes",
                        "Storing old shoes",
                        "Hosting casting calls"
                    ],
                    correctIndex: 0,
                    explanation: "High-fashion masterpieces are frequently exhibited in world-class museums as fine art."
                ),
                Question(
                    text: "How do conceptual art photographers light surreal fashion pieces?",
                    options: [
                        "Using dramatic, experimental shadows, colored gels, and avant-garde staging to create moody artwork",
                        "Using flat office fluorescent lighting",
                        "Turning off all lights",
                        "Shooting in direct blinding sunlight"
                    ],
                    correctIndex: 0,
                    explanation: "Experimental lighting enhances the surreal, gallery-worthy mood of conceptual pieces."
                ),
                Question(
                    text: "Why is emotional detachment and intense focus required for conceptual art modeling?",
                    options: [
                        "To embody abstract, surreal themes without breaking character or looking self-conscious",
                        "So you can fall asleep on set",
                        "To ignore the photographer",
                        "It is not required"
                    ],
                    correctIndex: 0,
                    explanation: "Abstract art demands unwavering commitment to strange, ethereal characters."
                ),
                Question(
                    text: "What materials are frequently experimented with in haute couture conceptual art?",
                    options: [
                        "Recycled plastics, metals, paper, wire, 3D-printed polymers, and organic elements",
                        "Only standard cotton",
                        "Basic denim",
                        "Standard polyester"
                    ],
                    correctIndex: 0,
                    explanation: "Conceptual designers use unconventional materials to sculpt futuristic silhouettes."
                ),
                Question(
                    text: "How do you protect delicate wearable art pieces backstage during preparation?",
                    options: [
                        "Working hand-in-hand with master artisans and wearing cotton gloves when handling fragile elements",
                        "Tossing them onto chairs",
                        "Washing them in a washing machine",
                        "Pulling them over your head quickly"
                    ],
                    correctIndex: 0,
                    explanation: "Fragile art pieces require delicate handling by trained dressers and artisans."
                ),
                Question(
                    text: "What is the artistic goal of blurring the line between fashion and performance art?",
                    options: [
                        "Provoking thought, challenging societal norms, and redefining aesthetic boundaries",
                        "Making clothes cheaper",
                        "Selling more retail shoes",
                        "Avoiding runway shows"
                    ],
                    correctIndex: 0,
                    explanation: "Performance art fashion challenges viewers to rethink beauty and form."
                ),
                Question(
                    text: "How do conceptual art performances impact a model's global industry reputation?",
                    options: [
                        "Establishing them as elite muses capable of carrying high-concept, avant-garde visions",
                        "Ruining their career",
                        "Limiting them to commercial print only",
                        "Having zero impact"
                    ],
                    correctIndex: 0,
                    explanation: "Carrying conceptual art shows elite status and high-fashion versatility."
                ),
                Question(
                    text: "What is the best way to prepare for an avant-garde art casting call?",
                    options: [
                        "Studying the designer's conceptual lookbook, practicing experimental posing, and bringing a bold artistic mindset",
                        "Practicing commercial pageant smiles",
                        "Bringing a resume for an office job",
                        "Wearing casual streetwear"
                    ],
                    correctIndex: 0,
                    explanation: "Understanding the designer's unique art vision helps you nail the casting."
                )
            ]
        }
        
        // 18. Global Agency Prep & Contract Mastery
        else if itemTitle.contains("Global Agency Prep") || itemTitle.contains("Contract Mastery") {
            questions = [
                Question(
                    text: "What is the primary purpose of a modeling agency representation contract?",
                    options: [
                        "Defining commission splits, exclusivity terms, territory rights, and career management obligations",
                        "A receipt for clothing purchases",
                        "An invitation to a party",
                        "A gym membership agreement"
                    ],
                    correctIndex: 0,
                    explanation: "Contracts protect both the model and agency by outlining legal rights and commission terms."
                ),
                Question(
                    text: "What does 'mother agency' mean in the international modeling industry?",
                    options: [
                        "The primary agency that discovers, develops, and places a model with international partner agencies",
                        "An agency for parents only",
                        "A clothing store",
                        "A modeling school for children"
                    ],
                    correctIndex: 0,
                    explanation: "Mother agencies guide your early development and coordinate international placements."
                ),
                Question(
                    text: "What are agency 'board divisions' (e.g., Mainboard, Development, Commercial)?",
                    options: [
                        "Categories that manage models based on their look, experience, and target market sectors",
                        "Different physical office rooms",
                        "A board game played by bookers",
                        "A list of fashion magazines"
                    ],
                    correctIndex: 0,
                    explanation: "Boards organize talent so bookers can quickly find models suited for specific clients."
                ),
                Question(
                    text: "How should a model review financial statements and expense deductions from their agency?",
                    options: [
                        "Checking all recoupable costs like test shoots, polaroids, and travel expenses carefully",
                        "Throwing statements in the trash",
                        "Signing without looking",
                        "Ignoring them completely"
                    ],
                    correctIndex: 0,
                    explanation: "Financial literacy ensures you understand commission deductions and expenses."
                ),
                Question(
                    text: "What is exclusive vs. non-exclusive agency representation?",
                    options: [
                        "Exclusive means working with one agency globally; non-exclusive allows multiple local placements",
                        "Exclusive means you work for free",
                        "Non-exclusive means you cannot work at all",
                        "There is no difference"
                    ],
                    correctIndex: 0,
                    explanation: "Exclusivity terms dictate whether you can sign with multiple agencies across cities."
                ),
                Question(
                    text: "Why are international placement visas (e.g., O-1 visa or working holiday visas) vital for global models?",
                    options: [
                        "Ensuring legal authorization to work and reside in major fashion capitals like Paris, Milan, and NY",
                        "Getting free airplane snacks",
                        "Booking hotel rooms",
                        "Visiting museums"
                    ],
                    correctIndex: 0,
                    explanation: "Working legally abroad requires proper visas to avoid deportation or blacklisting."
                ),
                Question(
                    text: "How do international booking options and option holds work?",
                    options: [
                        "Clients place a tentative 'hold' on your dates before confirming and signing the final booking contract",
                        "Options mean you can skip work whenever you want",
                        "Options are free cash bonuses",
                        "Options mean you choose your own salary"
                    ],
                    correctIndex: 0,
                    explanation: "Option holds secure tentative dates while clients finalize production budgets."
                ),
                Question(
                    text: "What is the significance of comp cards and digital portfolios in agency submissions?",
                    options: [
                        "Serving as your official resume and visual business card for international scouting",
                        "A collection of movie tickets",
                        "A discount card for clothing stores",
                        "A social media meme"
                    ],
                    correctIndex: 0,
                    explanation: "Comp cards and digital links are your primary tools for agency submissions."
                ),
                Question(
                    text: "What should a model do before signing any professional contract?",
                    options: [
                        "Consulting with legal representation or experienced mentors to understand all clauses",
                        "Signing it immediately without reading",
                        "Tearing it up",
                        "Posting it on Instagram"
                    ],
                    correctIndex: 0,
                    explanation: "Legal review protects you from unfavorable commission splits or binding traps."
                ),
                Question(
                    text: "What is the ultimate key to building a sustainable, long-term international modeling career?",
                    options: [
                        "Maintaining professional discipline, strong agency communication, financial literacy, and personal well-being",
                        "Being lucky and never practicing",
                        "Ignoring bookers' phone calls",
                        "Arriving late to every shoot"
                    ],
                    correctIndex: 0,
                    explanation: "Professionalism, financial sense, and wellness sustain a lifelong career in fashion."
                )
            ]
        }
        
        questions = questions.map { question in
            // Создаем пары (исходный индекс, текст варианта)
            let zippedOptions = Array(question.options.enumerated())
            // Перемешиваем их в случайном порядке
            let shuffledZipped = zippedOptions.shuffled()
            // Собираем новый массив перемешанных строк
            let newOptions = shuffledZipped.map { $0.element }
            // Находим новый индекс, куда сместился правильный ответ
            let newCorrectIndex = shuffledZipped.firstIndex { $0.offset == question.correctIndex } ?? 0
            
            return Question(
                text: question.text,
                options: newOptions,
                correctIndex: newCorrectIndex,
                explanation: question.explanation
            )
        }
    }
    
    func currentQuestion() -> Question? {
        guard currentIndex < questions.count else { return nil }
        return questions[currentIndex]
    }
    
    func selectAnswer(optionIndex: Int) {
        userAnswers[currentIndex] = optionIndex
    }
    
    func selectedAnswerForCurrent() -> Int? {
        return userAnswers[currentIndex]
    }
    
    @discardableResult
    func nextQuestion() -> Bool {
        if currentIndex < questions.count - 1 {
            currentIndex += 1
            return true
        }
        return false
    }
    
    @discardableResult
    func previousQuestion() -> Bool {
        if currentIndex > 0 {
            currentIndex -= 1
            return true
        }
        return false
    }
    
    func calculateResults() -> (score: Int, total: Int, items: [QuizResultItem]) {
        var score = 0
        var items: [QuizResultItem] = []
        
        for (index, question) in questions.enumerated() {
            let selectedOpt = userAnswers[index] ?? 0
            let isCorrect = (selectedOpt == question.correctIndex)
            if isCorrect { score += 1 }
            
            let selectedText = question.options.indices.contains(selectedOpt) ? question.options[selectedOpt] : "No answer"
            let correctText = question.options[question.correctIndex]
            
            items.append(QuizResultItem(
                questionText: question.text,
                selectedAnswer: selectedText,
                correctAnswer: correctText,
                isCorrect: isCorrect,
                explanation: question.explanation
            ))
        }
        
        return (score, questions.count, items)
    }
}

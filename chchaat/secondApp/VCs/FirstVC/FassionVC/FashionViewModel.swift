import Foundation

final class FashionViewModel {
    
    struct StoryStep {
        let title: String
        let description: String
    }
    
    let itemTitle: String
    let itemSubtitle: String
    let imageName: String
    
    private(set) var currentStep = 0
    var totalSteps: Int { steps.count }
    
    var onStepChanged: ((Int, Int, String, String) -> Void)?
    var onFinished: (() -> Void)?
    
    private lazy var steps: [StoryStep] = {
        return Self.contentDatabase[itemTitle] ?? Self.fallbackSteps
    }()
    
    init(itemTitle: String, itemSubtitle: String, imageName: String) {
        self.itemTitle = itemTitle
        self.itemSubtitle = itemSubtitle
        self.imageName = imageName
    }
    
    func viewDidLoad() {
        notifyCurrentStep()
    }
    
    func nextStep() {
        if currentStep < totalSteps - 1 {
            currentStep += 1
            notifyCurrentStep()
        } else {
            onFinished?()
        }
    }
    
    private func notifyCurrentStep() {
        guard currentStep < steps.count else { return }
        let stepData = steps[currentStep]
        onStepChanged?(currentStep, totalSteps, stepData.title, stepData.description)
    }
    
    // MARK: - 100 Unique Story Screens (20 items x 5 steps)
    private static let contentDatabase: [String: [StoryStep]] = [
        
        // 1. Paris Fashion Week Casting
        "Paris Fashion Week Casting": [
            StoryStep(title: "The Tuileries Call Sheet", description: "Dawn breaks over Place Vendome as casting directors review hundreds of comp cards. Only models with unmistakable sculptural presence make the first cut for Paris."),
            StoryStep(title: "The 15-Second Walk Test", description: "Inside a minimalist Marais studio, you have fifteen seconds to cross concrete floors in unforgiving stilettos while designers evaluate garment drape in motion."),
            StoryStep(title: "Couture Fitting Precision", description: "Selected talent moves directly to atelier fittings. Seamstresses pin raw silk and structured wool directly onto the body, demanding absolute stillness for hours."),
            StoryStep(title: "Backstage Tensions", description: "Minutes before the Palais de Tokyo doors open, hair stylists, makeup artists, and dressers swarm the lineup in a synchronized storm of last-second adjustments."),
            StoryStep(title: "The Grand Finale Lineup", description: "Flashbulbs erupt along the 60-meter runway. Closing a Parisian show cements a model's status on the global stage and unlocks major luxury campaigns.")
        ],
        
        // 2. Milano Editorial Shoot
        "Milano Editorial Shoot": [
            StoryStep(title: "Brera Courtyard Briefing", description: "Set inside a historic Milanese palazzo, the creative director outlines a moody, neo-realist visual narrative inspired by 1960s Italian cinema."),
            StoryStep(title: "Architectural Tailoring", description: "Heavy structured coats and razor-sharp silhouettes require sharp angular poses that emphasize fabric weight and Italian sartorial craftsmanship."),
            StoryStep(title: "Chiaroscuro Lighting Setup", description: "Master photographers manipulate harsh directional sunlight and deep shadows, asking you to hold micro-expressions without blinking between medium-format frames."),
            StoryStep(title: "The Cover Story Frame", description: "Mid-shoot, the stylist swaps in an archival velvet gown. A spontaneous turn toward the wind machine creates the defining shot for the September cover."),
            StoryStep(title: "Print Proof Approval", description: "Reviewing raw contact sheets over espresso, the editor-in-chief locks in a 12-page spread that will circulate across every fashion capital.")
        ],
        
        // 3. New York Brand Showcase
        "New York Brand Showcase": [
            StoryStep(title: "SoHo Loft Casting", description: "Energy in downtown Manhattan is fast and unapologetic. Casting agents look for raw street charisma, athletic confidence, and instant camera chemistry."),
            StoryStep(title: "Streetwear Layering", description: "Oversized outerwear, technical fabrics, and bold sneakers demand dynamic movement, relaxed shoulders, and an effortless urban attitude."),
            StoryStep(title: "Live Lookbook Capture", description: "Unlike traditional shows, buyers and stylists inspect garments up close while cameras stream the presentation live to global retail partners."),
            StoryStep(title: "Social Press Wall", description: "Between sets, models step onto the press riser for rapid-fire street-style portraits that go viral before the showcase even wraps."),
            StoryStep(title: "Commercial Contract Lock", description: "Strong buyer reception translates directly into seasonal lookbook bookings and billboard placements across Times Square and Midtown.")
        ],
        
        // 4. Tokyo Avant-Garde Show
        "Tokyo Avant-Garde Show": [
            StoryStep(title: "Shibuya Underground Venue", description: "Held inside a Brutalist concrete warehouse, this presentation rejects Western symmetry in favor of deconstructed silhouettes and radical proportions."),
            StoryStep(title: "Sculptural Garment Physics", description: "Wearing asymmetrical pleated textiles and platform architecture requires recalculating your center of gravity with every deliberate step."),
            StoryStep(title: "Conceptual Face Art", description: "Prosthetic details, metallic pigments, and bleached brows transform the face into a living canvas aligned with the designer's futuristic manifesto."),
            StoryStep(title: "Ambient Soundscape Pacing", description: "Instead of a standard 120-BPM beat, models pace their walk to industrial ambient frequencies, pausing for dramatic ten-second silhouettes."),
            StoryStep(title: "Cult Archive Recognition", description: "Tokyo's avant-garde circuit is closely watched by international curators, turning standout performers into muses for experimental fashion houses.")
        ],
        
        // 5. London Haute Couture
        "London Haute Couture": [
            StoryStep(title: "Mayfair Salon Preview", description: "Intimate, exclusive, and steeped in rebellious British heritage. Private clients and royalty sit inches away from the runway path."),
            StoryStep(title: "Hand-Embroidered Opulence", description: "Each look carries hundreds of hours of hand-beading and corsetry, demanding regal posture and unhurried, deliberate turns."),
            StoryStep(title: "Theatrical Storytelling", description: "London couture blends historical drama with punk subversion—models must project fierce character rather than a blank expression."),
            StoryStep(title: "Close-Range Scrutiny", description: "With no barrier between front-row guests and the catwalk, every detail of hand placement, eye contact, and hemline control is visible."),
            StoryStep(title: "Savile Row & Couture Prestige", description: "Completing a London couture week establishes versatility across both heritage luxury and boundary-pushing British design.")
        ],
        
        // 6. Classic Runway
        "Classic Runway": [
            StoryStep(title: "Spinal Alignment & Axis", description: "Every great catwalk begins with skeletal alignment: shoulders dropped back, chin parallel to the floor, and core engaged from the first step."),
            StoryStep(title: "The Pendulum Stride", description: "Master the long, fluid stride where hips lead the motion slightly while the upper body remains completely calm and floating."),
            StoryStep(title: "Pivot & Pose Mechanics", description: "At the end of the runway, execute a crisp half-turn or full pivot without losing balance, anchoring your weight on the back foot."),
            StoryStep(title: "Tempo & Rhythm Control", description: "Learn to lock your footsteps onto the bassline of the show's soundtrack without looking down at the floor."),
            StoryStep(title: "Garment Flow Awareness", description: "Adjust stride length automatically depending on whether you are wearing a tight pencil skirt, flowing chiffon, or heavy tailoring.")
        ],
        
        // 7. Editorial Posing
        "Editorial Posing": [
            StoryStep(title: "Breaking Symmetry", description: "Editorial photography thrives on tension. Learn to create triangles with limbs, tilt shoulders off-axis, and avoid static front-facing stances."),
            StoryStep(title: "Micro-Facial Control", description: "Master the 'smize' and subtle jaw tension—conveying intensity, vulnerability, or detachment without exaggerated facial expressions."),
            StoryStep(title: "Working With Hard Light", description: "Understand where key lights and reflectors sit so your cheekbones and jawline catch crisp highlights rather than unflattering shadows."),
            StoryStep(title: "Continuous Flow Transitions", description: "Move seamlessly every two clicks of the shutter, giving the photographer twenty distinct compositions in under a minute."),
            StoryStep(title: "Prop & Set Interaction", description: "Integrate chairs, architectural walls, and flowing fabrics naturally into your body lines so the environment feels like an extension of your pose.")
        ],
        
        // 8. High-End Makeup
        "High-End Makeup": [
            StoryStep(title: "Glass Skin Prep", description: "Backstage beauty starts with lymphatic drainage massage and barrier hydration so foundation melts seamlessly under 8K macro lenses."),
            StoryStep(title: "Editorial Color Theory", description: "Experiment with graphic liner, metallic foils, and negative-space pigments designed to complement seasonal fabric palettes."),
            StoryStep(title: "Bone Structure Contouring", description: "Learn how matte shading and translucent highlights sculpt the face differently for natural daylight versus harsh runway spotlights."),
            StoryStep(title: "Rapid Backstage Turnarounds", description: "Practice stripping bold runway pigments and resetting skin within ten minutes when booked for back-to-back shows."),
            StoryStep(title: "Beauty Campaign Close-Ups", description: "Develop the stillness and facial symmetry required for luxury skincare and cosmetics macro photography.")
        ],
        
        // 9. Commercial Acting
        "Commercial Acting": [
            StoryStep(title: "Instant Likability & Warmth", description: "Unlike icy high fashion, commercial work demands genuine, relatable expressions that connect with everyday audiences in half a second."),
            StoryStep(title: "Product Hero Framing", description: "Learn how to hold a watch, perfume bottle, or smartphone naturally while keeping labels angled squarely toward the lens."),
            StoryStep(title: "Teleprompter & Cue Delivery", description: "Deliver crisp brand taglines on camera with natural cadence while hitting precise floor marks during tracking shots."),
            StoryStep(title: "Ensemble Chemistry", description: "Build believable on-screen rapport with co-stars during lifestyle shoots, family scenarios, and luxury travel spots."),
            StoryStep(title: "Callback Improvisation", description: "Handle unexpected director notes during callbacks—switching from upbeat energy to serene luxury within a single take.")
        ],
        
        // 10. Vogue Masterclass
        "Vogue Masterclass": [
            StoryStep(title: "Decades of Visual Archives", description: "Study iconic covers and spreads from Irving Penn to Steven Meisel to understand how legendary poses shaped fashion history."),
            StoryStep(title: "Narrative Embodiment", description: "Step into complex editorial characters—transforming your posture and gaze to tell an entire story within a single frame."),
            StoryStep(title: "Extreme Couture Proportions", description: "Command voluminous ballgowns and avant-garde headpieces so the garment never overwhelms your personal presence."),
            StoryStep(title: "On-Set Creative Direction", description: "Collaborate directly with veteran art directors, offering bold physical interpretations that elevate the initial moodboard."),
            StoryStep(title: "Iconic Cover Readiness", description: "Synthesize poise, authority, and magnetic stillness—the hallmark traits of models who headline international editions.")
        ],
        
        // 11. Portfolio Building
        "Portfolio Building": [
            StoryStep(title: "The Polaroid / Digital Standard", description: "Capture raw, unretouched natural-light digitals in simple black attire—the single most important tool casting directors inspect."),
            StoryStep(title: "Curating Visual Range", description: "Balance your book with distinct moods: sharp beauty close-ups, full-length runway silhouettes, commercial warmth, and edgy monochrome."),
            StoryStep(title: "Test Shoot Collaboration", description: "Partner with rising photographers and stylists to produce tear-sheet-worthy stories that fill gaps in your current book."),
            StoryStep(title: "Comp Card Architecture", description: "Select the strongest front cover portrait and four contrasting back images alongside accurate measurements and agency contacts."),
            StoryStep(title: "Seasonal Book Refresh", description: "Audit and replace outdated shots every six months so your portfolio reflects your exact current look and market positioning.")
        ],
        
        // 12. Brand Etiquette
        "Brand Etiquette": [
            StoryStep(title: "The Golden Rule of Punctuality", description: "In fashion production, arriving fifteen minutes early is on time. Learn call-sheet decoding and backstage professionalism."),
            StoryStep(title: "Client & Designer Confidentiality", description: "Respect strict NDAs around unreleased collections—no backstage phone leaks before the official embargo lifts."),
            StoryStep(title: "Grace Under Production Pressure", description: "Maintain composure during twelve-hour shoot days, delayed flights, and last-minute wardrobe changes."),
            StoryStep(title: "Networking Without Overstepping", description: "Build lasting professional rapport with stylists, casting assistants, and editors who remember pleasant, reliable talent."),
            StoryStep(title: "Digital Presence Curation", description: "Manage public social channels cleanly so your online persona aligns with luxury brand safety standards.")
        ],
        
        // 13. Fitness & Tone
        "Fitness & Tone": [
            StoryStep(title: "Core & Postural Endurance", description: "Build deep stabilizer strength through Pilates and isometric holds to sustain effortless posture through marathon show days."),
            StoryStep(title: "Lean Muscle Elongation", description: "Focus on low-impact resistance, mobility, and flexibility routines that create long, balanced lines without bulk."),
            StoryStep(title: "Fashion Week Stamina", description: "Condition cardiovascular endurance to handle back-to-back castings, fittings, and late-night events without burnout."),
            StoryStep(title: "Hydration & Skin Vitality", description: "Balance electrolytes, clean nutrition, and recovery sleep so skin stays clear and energized under heavy studio lights."),
            StoryStep(title: "Injury Prevention & Foot Care", description: "Strengthen ankles, arches, and calves to protect joints from prolonged hours in narrow sample-size footwear.")
        ],
        
        // 14. Wardrobe Styling
        "Wardrobe Styling": [
            StoryStep(title: "Fabric Weight & Drape Theory", description: "Understand how bias-cut silk, raw denim, cashmere, and structured organza behave when walking or seated."),
            StoryStep(title: "Silhouette Proportioning", description: "Learn the rule of thirds in outfit construction—balancing oversized tops with tailored trousers or cinched waists."),
            StoryStep(title: "Sample Size Handling", description: "Treat delicate one-of-a-kind runway samples with care during quick changes, protecting seams, zippers, and embellishments."),
            StoryStep(title: "Color & Texture Pairing", description: "Combine contrasting textures like matte wool with patent leather to create depth on camera."),
            StoryStep(title: "Personal Off-Duty Uniform", description: "Master the classic model off-duty look—clean lines, neutral tones, and tailored basics that let your natural features shine at castings.")
        ],
        
        // 15. Runway Choreography
        "Runway Choreography": [
            StoryStep(title: "Complex Floor Formations", description: "Navigate multi-level stages, circular tracks, and crossing paths with split-second spatial timing."),
            StoryStep(title: "Synchronized Finale Walks", description: "Maintain exact two-meter spacing and unified pace during full-cast finale lineups."),
            StoryStep(title: "Staircase & Elevated Catwalks", description: "Descend steep architectural staircases smoothly without breaking eye contact with the pit cameras."),
            StoryStep(title: "Interactive Set Staging", description: "Execute scripted pauses, turns, and interactions with live musicians or moving stage installations."),
            StoryStep(title: "Show Opener & Closer Duties", description: "Command the energy of the entire room when chosen to set the pace as first look or close the collection.")
        ],
        
        // 16. Digital Modeling
        "Digital Modeling": [
            StoryStep(title: "3D Photogrammetry Scanning", description: "Step into multi-camera volumetric rigs to capture exact facial geometry and body topology for virtual avatars."),
            StoryStep(title: "Motion Capture Expression", description: "Perform fluid walks and facial micro-movements in mocap suits to animate digital luxury garments."),
            StoryStep(title: "Virtual Runway Environments", description: "Adapt posing techniques for CGI sets, zero-gravity physics, and mixed-reality brand showcases."),
            StoryStep(title: "Digital Twin Licensing", description: "Understand likeness rights, usage territories, and royalty structures for AI and 3D campaign assets."),
            StoryStep(title: "Metaverse & Gaming Collaborations", description: "Represent high-fashion houses launching digital skins and interactive virtual lookbooks.")
        ],
        
        // 17. Commercial Print
        "Commercial Print": [
            StoryStep(title: "E-Commerce Rapid Pacing", description: "Deliver 40 to 60 clean, consistent outfit angles per day while keeping garment details sharp for online shoppers."),
            StoryStep(title: "Catalog & Lookbook Consistency", description: "Maintain uniform framing, hand placement, and expression across multi-page seasonal print catalogs."),
            StoryStep(title: "Billboard & Out-of-Home Scale", description: "Project bold, readable silhouettes and clear eye-line connection designed to stand out from fifty meters away."),
            StoryStep(title: "Accessory & Jewelry Focus", description: "Master delicate hand and neck positioning so rings, watches, and necklaces catch crisp specular highlights."),
            StoryStep(title: "High-Volume Client Retention", description: "Become a reliable repeat booking for major retail brands through speed, accuracy, and zero-ego professionalism.")
        ],
        
        // 18. Lingerie & Swim
        "Lingerie & Swim": [
            StoryStep(title: "Body Confidence & Poise", description: "Project effortless self-assurance and athletic grace in minimal resortwear and delicate lace collections."),
            StoryStep(title: "Outdoor Resort Light Control", description: "Work with harsh midday beach sun, ocean wind, and wet-skin highlights on destination location shoots."),
            StoryStep(title: "Elongated Lines & Arching", description: "Use subtle hip shifts, pointed toes, and lifted ribcage posture to create flattering, sculpted silhouettes."),
            StoryStep(title: "Wing & Prop Runway Balance", description: "Carry statement resort capes, metallic wings, and sculptural swimwear frames down high-energy runways."),
            StoryStep(title: "Global Resort Campaign Appeal", description: "Blend aspirational glamour with approachable warmth for international swimwear and wellness brands.")
        ],
        
        // 19. Haute Couture Art
        "Haute Couture Art": [
            StoryStep(title: "Living Sculpture Philosophy", description: "Treat rare handmade couture pieces as wearable museum art, moving with deliberate, architectural stillness."),
            StoryStep(title: "Surrealist & Conceptual Posing", description: "Collaborate with visionary designers to create gravity-defying silhouettes and avant-garde gallery portraits."),
            StoryStep(title: "Atelier Craft Appreciation", description: "Understand featherwork, metallic weaving, and hand-draped tulle to showcase each artisan detail to the lens."),
            StoryStep(title: "Emotional Depth Without Words", description: "Channel poetic, cinematic atmosphere that elevates editorial spreads into collectible art books."),
            StoryStep(title: "Museum & Exhibition Prestige", description: "Become the face of retrospective exhibitions and archival couture showcases in Paris and New York.")
        ],
        
        // 20. Global Agency Prep
        "Global Agency Prep": [
            StoryStep(title: "Mother Agency Placement Strategy", description: "Learn how your home agency develops your book before placing you with top boards in Paris, Milan, London, and New York."),
            StoryStep(title: "Contract & Commission Literacy", description: "Understand agency percentages, advance recouping, exclusivity clauses, and buyout terms before signing."),
            StoryStep(title: "International Work Visa Navigation", description: "Prepare portfolios, tear sheets, and press clippings required to qualify for O-1 and international talent visas."),
            StoryStep(title: "Go-See Route Optimization", description: "Navigate unfamiliar cities efficiently, hitting twelve casting offices in a single day with energy to spare."),
            StoryStep(title: "Long-Term Career Longevity", description: "Transition from breakout newcomer to established campaign regular and creative collaborator across global markets.")
        ]
    ]
    
    private static let fallbackSteps: [StoryStep] = [
        StoryStep(title: "Core Foundation", description: "Build essential discipline, posture, and visual awareness required in modern fashion."),
        StoryStep(title: "Technical Execution", description: "Refine movement precision, lighting sensitivity, and camera presence under professional direction."),
        StoryStep(title: "Industry Standards", description: "Adapt your presentation to meet the expectations of international casting directors and stylists."),
        StoryStep(title: "Creative Range", description: "Expand versatility across editorial storytelling, runway pacing, and commercial campaigns."),
        StoryStep(title: "Agency Readiness", description: "Complete your training block and unlock new opportunities across global fashion capitals.")
    ]
}

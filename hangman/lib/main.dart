import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(HangmanApp());
}

class HangmanApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hangman Game',
      debugShowCheckedModeBanner: false, // Disable the debug banner
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HangmanGame(),
    );
  }
}


class HangmanGame extends StatefulWidget {
  @override
  _HangmanGameState createState() => _HangmanGameState();
}

enum GameScreen {
  initial,
  game,
}

class _HangmanGameState extends State<HangmanGame> {
  Map<String, List<String>> categoryWordBank = {

    "Animal": [
      "TIGER", "ELEPHANT", "KANGAROO", "GIRAFFE", "GOAT", "HORSE", "COW",
      "DOG", "CAT", "BAT", "RAT", "PIG", "FOX", "WOLF", "LION",
      "BEAR", "MULE", "DEER", "FROG", "SEAL", "MOLE", "HARE",
      "OTTER", "PANDA", "LLAMA", "KOALA", "CAMEL", "SHEEP",
      "ZEBRA", "MONKEY", "BISON", "DONKEY", "JAGUAR", "HYENA",
      "BUFFALO", "RABBIT", "ORANGUTAN", "GORILLA", "LEOPARD",
      "CHEETAH", "WHALE", "DOLPHIN", "DUGONG", "MANATEE",
      "PLATYPUS", "WALRUS", "BADGER", "WEASEL", "MINK",
      "HEDGEHOG", "PORCUPINE", "ARMADILLO", "ANTEATER",
      "SLOTH", "MONGOOSE", "FERRET", "MEERKAT", "OPOSSUM",
      "KANGAROO", "WALLABY", "TAPIR", "RHINOCEROS", "HIPPOPOTAMUS",
      "CHIMPANZEE", "GORILLA", "ALPACA", "COYOTE", "BEAVER",
      "LYNX", "CARIBOU", "MUSKRAT", "OTTER", "WILDCAT",
      "BOBCAT", "PECCARY", "POSSUM", "GOPHER", "OCELOT",
      "SKUNK", "VICUÑA", "CHIPMUNK", "LEMUR", "SERVAL",
      "PANGOLIN", "OKAPI", "KUDU", "IBEX", "ELAND",
      "JAVELINA", "HYAENA", "TASMANIAN DEVIL", "PRONGHORN",
      "MOUSE", "GERBIL", "HAMSTER", "GUINEA PIG"
    ],


    "Bird": [ "SPARROW", "PEACOCK", "PIGEON", "EAGLE", "PARROT", "DOVE",
      "CROW", "SWAN", "DUCK", "FINCH", "OWL", "WREN", "TERN",
      "LARK", "COOT", "KITE", "BIRD", "LOON", "RAVEN", "JAY",
      "CRANE", "HERON", "EGRET", "STORK", "IBIS", "HAWK", "GREBE",
      "SWIFT", "BULBUL", "CURLEW", "AVOCET", "SISKIN", "SPINEBILL",
      "BITTERN", "WARBLER", "BUNTING", "SKYLARK", "KESTREL",
      "CUCKOO", "GALLINULE", "NIGHTJAR", "WOODPECKER", "PELICAN",
      "FLYCATCHER", "SUNBIRD", "HORNBILL", "SHRIKE", "SEAGULL",
      "STARLING", "MAGPIE", "SANDPIPER", "TURKEY", "OSTRICH",
      "PENGUIN", "PUFFIN", "KINGFISHER", "HUMMINGBIRD", "WEAVER",
      "QUAIL", "DUNLIN", "PARTRIDGE", "JACANA", "MOORHEN", "GREYHEN",
      "LYREBIRD", "TOUCAN", "SWALLOW", "PLOVER", "BRAMBLING",
      "WHIMBREL", "SKUA", "RAIL", "NODDY", "ALBATROSS", "MERGANSER",
      "STINT", "COCKATOO", "PYGMY", "MANAKIN", "ROADRUNNER",
      "TINAMOU", "SPOONBILL", "WHISTLER", "TANAGER", "ORIOLE",
      "MEADOWLARK", "BOOBY", "MALKOHA", "NIGHTINGALE",
      "ANHINGA", "BITTERN", "WAGTAIL", "WOODCOCK",
      "HARRIER", "PHEASANT", "KINGLET", "MACAW" ],


    "Brand": ["NIKE", "GUCCI", "ADIDAS", "SONY", "APPLE", "TESLA",
      "DELL", "HP", "FORD", "AUDI", "TOYOTA", "HONDA",
      "BMW", "KIA", "LG", "GAP", "ZARA", "H&M", "PUMA",
      "BOSE", "MAC", "NIVEA", "REEBOK", "CANON", "EPSON",
      "PEPSI", "COCA-COLA", "INTEL", "ORACLE", "SAMSUNG",
      "GOOGLE", "MICROSOFT", "FACEBOOK", "AMAZON", "TWITTER",
      "YOUTUBE", "DISNEY", "SPOTIFY", "NETFLIX", "TIKTOK",
      "INSTAGRAM", "LINKEDIN", "WHATSAPP", "SNAPCHAT",
      "XIAOMI", "OPPO", "VIVO", "ONEPLUS", "ASUS",
      "LENOVO", "ACER", "ROLEX", "TISSOT", "SEIKO",
      "PHILIPS", "PANASONIC", "HITACHI", "SHARP", "DAIKIN",
      "JEEP", "VOLVO", "SUZUKI", "MERCEDES", "HYUNDAI",
      "CHANEL", "PRADA", "LOUIS VUITTON", "VERSACE",
      "FENDI", "BURBERRY", "RALPH LAUREN", "TOMMY HILFIGER",
      "CALVIN KLEIN", "LEVI'S", "DIESEL", "YSL", "BALENCIAGA",
      "ARMANI", "HERMES", "CARTIER", "TIFANY & CO.",
      "GUESS", "LACOSTE", "DIOR", "OAKLEY", "RAY-BAN",
      "FOSSIL", "PANDORA", "SWATCH", "DOLCE & GABBANA",
      "GIVENCHY", "BOSS", "CLINIQUE", "LANCOME",
      "ESTEE LAUDER", "KIEHL'S", "URBAN DECAY", "NYX",
      "MAC COSMETICS", "L'OREAL", "OLAY", "DOVE",
      "GARNIER", "TRESEMME", "JOHNSON & JOHNSON"],

    "CP Platform": ["CODEFORCES", "LEETCODE", "DIMIK OJ", "ICPC", "HACKERRANK", "CSES", "BEECROWD"],

    "Country": [
      "BANGLADESH", "CANADA", "AUSTRALIA", "GERMANY", "AMERICA", "JAPAN", "INDIA",
      "CHINA", "SPAIN", "FRANCE", "ITALY", "GREECE", "SWEDEN",
      "NORWAY", "RUSSIA", "BRAZIL", "EGYPT", "POLAND",
      "BELGIUM", "DENMARK", "FINLAND", "HUNGARY", "ISRAEL",
      "JORDAN", "KENYA", "MEXICO", "NEPAL", "OMAN",
      "QATAR", "YEMEN", "SYRIA", "GHANA", "CHILE",
      "HAITI", "IRAQ", "IRAN", "LIBYA", "MALTA",
      "NIGER", "PERU", "SOMALIA", "SUDAN", "THAILAND",
      "TURKEY", "UGANDA", "ZAMBIA", "ZIMBABWE", "VIETNAM",
      "ICELAND", "IRELAND", "LEBANON", "MALAWI", "MYANMAR",
      "PAKISTAN", "PORTUGAL", "ROMANIA", "SERBIA", "SINGAPORE",
      "SLOVAKIA", "SLOVENIA", "TUNISIA", "UKRAINE", "VENEZUELA",
      "ARGENTINA", "BAHRAIN", "BOLIVIA", "BOTSWANA",
      "BULGARIA", "CAMBODIA", "COSTA RICA", "CROATIA",
      "ECUADOR", "ESTONIA", "ETHIOPIA", "GUATEMALA",
      "INDONESIA", "JAMAICA", "KAZAKHSTAN", "LATVIA",
      "LITHUANIA", "LUXEMBOURG", "MADAGASCAR", "MALAYSIA",
      "MONGOLIA", "NICARAGUA", "PANAMA", "PARAGUAY",
      "PHILIPPINES", "SENEGAL", "SOUTH AFRICA", "SOUTH KOREA",
      "SRI LANKA", "SURINAME", "SWITZERLAND", "TAIWAN",
      "TANZANIA", "TRINIDAD", "URUGUAY", "UZBEKISTAN",
      "VATICAN CITY", "WESTERN SAHARA"
    ],

    "Courses": ["DSA","MATH","OOP","ACCOUNTING","EEE"],

    "District": ["DHAKA", "CHITTAGONG", "SYLHET", "RAJSHAHI","JHENAIDAH","RANGPUR"],

    "Family": ["PRINCE","NAZMUL","NISHAT","JAHANARA","AMIRUL","PRIYANKA",],


    "Fish":["COD", "EEL", "BASS", "TUNA", "CARP", "PIKE", "PERCH",
      "SHAD", "TROUT", "CHAR", "SALMON", "MULLET", "GROUPER",
      "SNAPPER", "ANCHOVY", "HERRING", "CATFISH", "MINNOW",
      "DRUM", "BREAM", "GAR", "ROACH", "DARTER",
      "SUNFISH", "BLUEGILL", "CRAPPIE", "GOLDFISH",
      "SARDINE", "GOURAMI", "PUFFER", "FLATFISH", "HALIBUT",
      "TILAPIA", "FLOUNDER", "SEAHORSE", "STINGRAY", "RAY",
      "MARLIN", "SAWFISH", "BARRACUDA", "SHARK", "SKATE",
      "MAHI-MAHI", "BONEFISH", "PADDLEFISH", "SURGEONFISH",
      "TRIGGERFISH", "CLOWNFISH", "BUTTERFLYFISH",
      "ANGELFISH", "PARROTFISH", "WRASSE", "DAMSELFISH",
      "BLENNY", "GOBY", "SNORKELFISH", "PIPEFISH", "TRUMPETFISH",
      "LIONFISH", "SCORPIONFISH", "STONEFISH",
      "FROGFISH", "LOBSTER", "CRAYFISH", "CUTTLEFISH",
      "SQUID", "OCTOPUS", "NAUTILUS", "GRUNTFISH",
      "HOGFISH", "HADDOCK", "POLLOCK", "LINGCOD",
      "CODLING", "SAWFISH", "POMPANO", "MONKFISH",
      "DOGFISH", "SKIPJACK", "KINGFISH", "WALLEYE",
      "SAILFISH", "YELLOWTAIL", "TAILOR", "SNAPPER",
      "ALBACORE", "COBIA", "SWORDFISH", "TARPON",
      "BULLHEAD", "FLYINGFISH", "BUBBLEFISH", "DRAGONFISH",
      "GLASSFISH", "SQUIRRELFISH", "STURGEON", "TIGERFISH",
      "PACU", "OSCAR", "DISCUSS", "BETTA"],


    "Flower": [
      "ROSE", "LILY", "TULIP", "SUNFLOWER",
      "IRIS", "DAISY", "LOTUS", "ORCHID", "PANSY", "ASTER",
      "PETUNIA", "CROCUS", "ZINNIA", "MARIGOLD", "POPPY",
      "VIOLET", "DAHLIA", "FREESIA", "AZALEA", "CAMELLIA",
      "PRIMROSE", "HIBISCUS", "JASMINE", "LAVENDER", "GARDENIA",
      "CHRYSANTHEMUM", "MAGNOLIA", "SNAPDRAGON", "HYDRANGEA",
      "CALENDULA", "FORGET-ME-NOT", "BLUEBELL", "WISTERIA",
      "RANUNCULUS", "ALSTROEMERIA", "DELPHINIUM", "COLUMBINE",
      "ANEMONE", "HEATHER", "GERANIUM", "PEONY", "IRIS",
      "CARNATION", "YARROW", "VERBENA", "FOXGLOVE", "BLEEDING HEART",
      "EVENING PRIMROSE", "HOLLYHOCK", "HONEYSUCKLE", "LUPINE",
      "PHLOX", "SWEET PEA", "BLACK-EYED SUSAN", "COREOPSIS",
      "GLADIOLUS", "SCABIOSA", "STATICE", "COSMOS", "ALYSSUM",
      "BORAGE", "LOBELIA", "NEMOPHILA", "PETASITES", "SPEEDWELL",
      "THRIFT", "TOADFLAX", "TRILLIUM", "WALLFLOWER", "WAXFLOWER",
      "WINDFLOWER", "BUTTERCUP", "HONEYSUCKLE", "CANTERBURY BELLS",
      "BELLFLOWER", "CHERRY BLOSSOM", "SUN DROPS", "FOUR O'CLOCK",
      "SPIDERWORT", "BACHELOR'S BUTTON", "CAMPANULA", "GLOBE AMARANTH",
      "MORNING GLORY", "PAINTED DAISY", "SALVIA", "THISTLE",
      "VIBURNUM", "WHITE CAMPION", "YELLOW IRIS", "ZEPHYR LILY",
      "ANGEL'S TRUMPET", "BIRDS OF PARADISE", "CANNA LILY",
      "CELOSIA", "CHRYSANTHEMUM", "CLEMATIS", "CONEFLOWER",
      "CORNFLOWER", "DAFFODIL", "DANDELION"
    ],

    "Friends":["SHITHI","NOOR","MUBASSHIR","DIYA","BORHAN"],

    "Fruits":["FIG", "PEAR", "KIWI", "PLUM", "DATE", "MELON", "APPLE",
      "GRAPE", "LEMON", "MANGO", "GUAVA", "PEACH", "ORANGE",
      "BANANA", "CHERRY", "LYCHEE", "PAPAYA", "PINEAPPLE",
      "APRICOT", "AVOCADO", "CUSTARD APPLE", "DRAGONFRUIT",
      "STRAWBERRY", "BLUEBERRY", "RASPBERRY", "CRANBERRY",
      "BLACKBERRY", "POMEGRANATE", "WATERMELON", "CANTALOUPE",
      "HONEYDEW", "PASSIONFRUIT", "TAMARIND", "SOURSOP",
      "JACKFRUIT", "LONGAN", "RAMBUTAN", "STARFRUIT", "SUGARCANE",
      "COCONUT", "ELDERBERRY", "GOOSEBERRY", "MULBERRY",
      "OLIVE", "NECTARINE", "TANGERINE", "PERSIMMON",
      "QUINCE", "KUMQUAT", "SAPODILLA", "UGLI FRUIT",
      "BLOOD ORANGE", "CALAMANSI", "CAPE GOOSEBERRY",
      "CLÉMENTINE", "SALAK", "DURIAN", "CAMU CAMU",
      "JABUTICABA", "MARIONBERRY", "ACAI", "ARONIA",
      "BARBERRY", "BREADFRUIT", "CACAO", "CHERIMOYA",
      "CLOUDBERRY", "CURRANT", "FEIJOA", "HUCKLEBERRY",
      "IMBE", "JUNEBERRY", "LOQUAT", "MEDLAR", "MONSTERA",
      "NANNYBERRY", "OSAGE ORANGE", "PLANTAIN", "ROSEHIP",
      "SEABERRY", "SHIPOVA", "SWEET LIME", "TOMATO",
      "WHITE SAPOTE", "YANGMEI", "YELLOW PASSIONFRUIT",
      "ZUCCHINI"],

    "Human Body":["EYE", "EAR", "ARM", "LEG", "LIP", "GUM", "TOE",
      "JAW", "HIP", "Nose", "SKIN", "HAND", "FOOT",
      "HEAD", "BACK", "FACE", "NECK", "CHEST",
      "RIBS", "HAIR", "NAIL", "PALM", "BRAIN",
      "LUNG", "HEART", "LIVER", "SPINE", "KNEE",
      "BLOOD", "STOMACH", "MUSCLE", "TONGUE", "VEINS",
      "ARMPIT", "FINGER", "WRIST", "ELBOW", "ANKLE",
      "THIGH", "JOINT", "SCALP", "PELVIS", "NERVES",
      "TEETH", "TRACHEA", "ESOPHAGUS", "SPLEEN", "RETINA",
      "CORNEA", "PUPIL", "IRIS", "EUSTACHIAN", "SINUS",
      "PANCREAS", "GALLBLADDER", "DIAPHRAGM", "INTESTINE",
      "COLON", "RECTUM", "BLADDER", "URETER", "URETHRA",
      "PHARYNX", "LARYNX", "BRONCHI", "ALVEOLI", "TENDONS",
      "CARTILAGE", "LIGAMENT", "MANDIBLE", "CLAVICLE",
      "SCAPULA", "HUMERUS", "FEMUR", "TIBIA", "FIBULA",
      "ULNA", "RADIUS", "VERTEBRAE", "CRANIUM",
      "METACARPALS", "PHALANGES", "COCCYX", "PATELLA",
      "EPIDERMIS", "DERMIS", "HYPODERMIS", "LYMPH",
      "CAPILLARY", "AORTA", "VENTRICLE", "ATRIA",
      "PLATELETS", "HORMONES", "ENZYMES", "CEREBELLUM",
      "CEREBRUM", "HYPOTHALAMUS", "PITUITARY"],

    "IDE": ["VS CODE", "ECLIPSE", "INTELLIJ", "CODEBLOCKS", "PYCHARM", "ANDROID STUDIO"],

    "Insects": ["ANT", "BEE", "FLY", "BUG", "MOTH", "GNAT", "FLEA",
      "WASP", "TERMITE", "BEETLE", "LOCUST", "CRICKET",
      "EARWIG", "APHID", "CICADA", "HORNET", "DRAGONFLY",
      "BUTTERFLY", "COCKROACH", "DAMSELFLY", "FIREFLY", "GRASSHOPPER",
      "LADYBUG", "STINKBUG", "SCORPIONFLY", "STONEFLY",
      "LEAFHOPPER", "LACEWING", "SPITTLEBUG", "WATERBOATMAN",
      "WEEVIL", "WATERSTRIDER", "KATYDID", "MAYFLY",
      "MEALWORM", "SILKWORM", "MOSQUITO", "LOVEBUG",
      "BEDBUG", "CADDISFLY", "CATERPILLAR", "CRANEFLY",
      "FRUITFLY", "MIDGE", "THRIPS", "BOLLWEEVIL",
      "LEAFMINER", "BARKBEETLE", "ARMYWORM", "CUTWORM",
      "CABBAGEWORM", "TENTCATERPILLAR", "WEBWORM", "SKIPPER",
      "VINEBORER", "BEANBEETLE", "GALLMIDGE", "SCARAB",
      "TUMBLEBUG", "HOVERFLY", "GALLWASP", "MANTIS",
      "PRAYINGMANTIS", "GLASSWING", "ATLASMOTH",
      "TIGERBEETLE", "WATERBEETLE", "CARRIONBEETLE", "POTATOBUG",
      "EARWIG", "FIREANT", "HARVESTERANT", "CARPENTERANT",
      "BLACKFLY", "YELLOWJACKET", "GREENLACEWING",
      "MOCKERSWALLOWTAIL", "PAINTEDLADY", "REDADMIRAL",
      "MONARCH", "SWALLOWTAIL", "CLOUDEDYELLOW",
      "PEACOCKBUTTERFLY", "ZEBRALONGWING", "ANTLION",
      "STAGBEETLE", "RHINOBEETLE", "CLICKBEETLE",
      "PEARLWEEVIL", "GOLDBEETLE", "LUNAMOTH",
      "SPHINXMOTH", "TIGERMOTH", "HAWKMOTH",
      "ORCHIDMANTIS", "LEAFINSECT", "STICKINSECT"],

    "Occupation":["CHEF", "COOK", "FARMER", "DOCTOR", "NURSE", "TEACHER",
      "LAWYER", "DRIVER", "PAINTER", "WAITER", "WRITER", "ACTOR",
      "SINGER", "DANCER", "BARBER", "GUARD", "ARTIST", "BAKER",
      "TAILOR", "DENTIST", "POLICE", "FISHER", "HUNTER", "JANITOR",
      "PRIEST", "PILOT", "PLUMBER", "CARPENTER", "SCIENTIST",
      "ENGINEER", "MECHANIC", "ELECTRICIAN", "ARCHITECT",
      "ACCOUNTANT", "PHOTOGRAPHER", "PROGRAMMER", "SOFTWARE DEVELOPER",
      "CONSULTANT", "PHARMACIST", "SURGEON", "CHEMIST", "BIOLOGIST",
      "ENTREPRENEUR", "PSYCHOLOGIST", "THERAPIST", "LECTURER",
      "RESEARCHER", "LIBRARIAN", "VETERINARIAN", "JOURNALIST",
      "MARKETER", "SALESPERSON", "ACTIVIST", "FIREFIGHTER",
      "PARAMEDIC", "ATHLETE", "COACH", "SCULPTOR",
      "COMPOSER", "MUSICIAN", "OPTOMETRIST", "TRANSLATOR",
      "INTERPRETER", "BLACKSMITH", "GOLDSMITH", "POTTER",
      "WEAVER", "SEAMSTRESS", "CASHIER", "RECEPTIONIST",
      "SECRETARY", "CLERK", "SUPERVISOR", "MANAGER",
      "ADMINISTRATOR", "DIRECTOR", "INSPECTOR", "TUTOR",
      "GUIDE", "CHEMICAL ENGINEER", "CIVIL ENGINEER", "DATA ANALYST",
      "DATA SCIENTIST", "UX DESIGNER", "GRAPHIC DESIGNER",
      "CONTENT CREATOR", "VIDEO EDITOR", "SOCIAL MEDIA MANAGER",
      "WEB DEVELOPER", "FULL-STACK DEVELOPER", "CYBERSECURITY SPECIALIST",
      "GAME DEVELOPER", "UI DESIGNER", "PROJECT MANAGER",
      "BUSINESS ANALYST", "STRATEGIST", "EVENT PLANNER",
      "TRAVEL AGENT", "LOGISTICS MANAGER"],


    "Programming": ["CSE", "JAVA", "PYTHON", "C++", "DART", "FLUTTER", "JAVASCRIPT"],

    "Search Engine": ["CHROME", "FIREFOX", "OPERA MINI", "BRAVE", "MS EDGE"],

    "Shapes":["DOT", "LINE", "ARC", "CONE", "CUBE", "OVAL",
      "SPHERE", "CIRCLE", "SQUARE", "TRIANGLE", "HEXAGON",
      "OCTAGON", "PENTAGON", "DIAMOND", "ELLIPSE",
      "PRISM", "PYRAMID", "CYLINDER", "TORUS", "CRESCENT",
      "STAR", "ARROW", "TRAPEZOID", "PARALLELOGRAM",
      "RECTANGLE", "DECAGON", "HEPTAGON", "NONAGON",
      "DODECAGON", "RHOMBUS", "KITE", "OBLONG",
      "SCALENE TRIANGLE", "ISOSCELES TRIANGLE",
      "EQUILATERAL TRIANGLE", "RIGHT TRIANGLE",
      "SPIRAL", "LOZENGE", "CHEVRON", "CROSS",
      "PLUS", "MINUS", "WAVE", "ARROWHEAD",
      "HEART", "CLOVER", "ROUNDED SQUARE",
      "ROUNDED RECTANGLE", "CUBOID", "HEXAGRAM",
      "OCTAGRAM", "POLYGON", "TETRAHEDRON",
      "DODECAHEDRON", "ICOSAHEDRON", "PARABOLA",
      "HYPERBOLA", "CYLINDROID", "ELLIPSOID",
      "SUPERELLIPSE", "ASTROID", "DELRTOID",
      "ROSE CURVE", "LEMISCATE", "FOLIUM",
      "VORTEX", "TRILOBE", "QUADRIC",
      "HYPERSPHERE", "ANNULUS", "HELICOID",
      "CONOID", "RECTANGULAR PRISM", "TETRAHEDRAL",
      "PYRAMIDAL FRUSTUM", "OBLIQUE", "LOOPS",
      "QUADRANT", "SEGMENT", "SECTOR",
      "HYPERCUBE", "POLYHEDRON", "TRAPEZIUM",
      "BITANGENT", "ENNEAGRAM", "RHOMBOID",
      "SCALENE", "TOROID", "LUNE", "ANNULAR SECTOR",
      "KEPLER TRIANGLE", "SPINDLE", "SUPERHYPERSPHERE",
      "VASE", "LOLLIPOP", "LENS", "SUPERFORM"],



    "Vegetables": ["PEA", "BEAN", "CORN", "OKRA", "KALE", "ONION", "CHILI",
      "RADISH", "CARROT", "POTATO", "TOMATO", "GARLIC",
      "GINGER", "SPINACH", "TURNIP", "PEPPER", "CELERY",
      "LETTUCE", "CABBAGE", "CILANTRO", "PARSNIP",
      "ZUCCHINI", "CUCUMBER", "BROCCOLI", "CAULIFLOWER",
      "EGGPLANT", "MUSHROOM", "PUMPKIN", "SQUASH", "FENNEL",
      "ASPARAGUS", "ARTICHOKE", "BRUSSELS SPROUT",
      "SCALLION", "CHARD", "ARUGULA", "BEETROOT",
      "WATERCRESS", "LEEK", "DANDELION", "BOK CHOY",
      "RHUBARB", "YAM", "SOYBEAN", "CHICKPEA", "LENTIL",
      "KIDNEY BEAN", "SNAP PEA", "SWEET POTATO", "BUTTERNUT",
      "ACORN SQUASH", "SPAGHETTI SQUASH", "CORN SALAD",
      "JERUSALEM ARTICHOKE", "KOHLRABI", "RADICCHIO",
      "ENDIVE", "ESCAROLE", "CHICORY", "MUSTARD GREENS",
      "CURLY KALE", "RED CABBAGE", "WHITE CABBAGE",
      "SAVOY CABBAGE", "BELL PEPPER", "CHINESE BROCCOLI",
      "GAI LAN", "SNOW PEA", "BAMBOO SHOOT", "WINGED BEAN",
      "PARSLEY", "MINT", "DILL", "BASIL", "OREGANO",
      "THYME", "ROSEMARY", "TARRAGON", "MARJORAM",
      "SORREL", "CHIVE", "FENUGREEK", "LEMONGRASS",
      "SPROUTS", "ALFALFA", "RADISH SPROUT", "BEAN SPROUT",
      "PEANUT", "TARO", "EDAMAME", "HORSE RADISH",
      "SALSIFY", "BLACK RADISH", "WHITE RADISH",
      "KOMATSUNA", "MIZUNA", "BURDOCK", "MORINGA"],




    "Vehicles":["CAR", "BUS", "VAN", "SUV", "TAXI", "BIKE", "TRAM",
      "TRUCK", "TRAIN", "SCOOTER", "BOAT", "SHIP", "PLANE",
      "JEEP", "RAFT", "KAYAK", "CYCLE", "FERRY", "CANOe",
      "SUBWAY", "TROLLEY", "MOPED", "YACHT", "GONDOLA",
      "AIRSHIP", "TANK", "BARGE", "CRUISER", "GLIDER",
      "AMBULANCE", "CAMPER", "TRACTOR", "MINIBUS", "LIMOUSINE",
      "MOTORBIKE", "CABRIOLET", "PICKUP", "CHOPPER", "ROADSTER",
      "HOVERCRAFT", "DIRIGIBLE", "SPEEDBOAT", "JETSKI", "KART",
      "SNOWMOBILE", "ATV", "ALL-TERRAIN VEHICLE", "HELICOPTER",
      "BULLDOZER", "EXCAVATOR", "GRADER", "FORKLIFT", "SKATEBOARD",
      "SEGWAY", "UNIMOG", "TOW TRUCK", "DUMP TRUCK", "GARBAGE TRUCK",
      "FIRETRUCK", "LIFT", "ESCALATOR", "BICYCLE",
      "HANDCART", "DRONE", "FREIGHTER", "CATAMARAN",
      "FISHING BOAT", "JET", "AIRLINER", "CARGO PLANE",
      "SPACECRAFT", "ROCKET", "SPACESHIP", "TANKER", "STEAMER",
      "CARAVAN", "MONORAIL", "SKI LIFT", "TROLLEYBUS",
      "HORSE CARRIAGE", "DOG SLED", "BALLOON",
      "DIRT BIKE", "BULLDOZER", "HATCHBACK",
      "RICKSHAW", "AUTO RICKSHAW", "PEDAL BOAT",
      "SKIFF", "GOKART", "CABLE CAR", "ZIPLINE",
      "ULTRALIGHT", "SEAPLANE", "HOVERBIKE", "GONDOLA LIFT",
      "HYBRID CAR", "ELECTRIC SCOOTER", "ELECTRIC CAR"],











  };

  late String hiddenWord;
  late String currentGuess;
  int attemptsLeft = 6;
  String currentCategory = "Family";
  String message = "";
  GameScreen _currentScreen = GameScreen.initial;

  final TextEditingController _inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    resetGame();
  }

  void resetGame() {
    hiddenWord = selectRandomWord();
    currentGuess = "_ " * hiddenWord.length;
    attemptsLeft = 6;
    message = "";
    _inputController.clear();
    setState(() {});
  }

  String selectRandomWord() {
    final random = Random();
    final words = categoryWordBank[currentCategory] ?? ["UNKNOWN"];
    return words[random.nextInt(words.length)];
  }


  void handleGuess(String input) {
    if (input.isEmpty || input.length != 1) {
      setState(() {
        message = "Please enter a single letter.";
      });
      return;
    }
    final guessedLetter = input.toUpperCase().characters.first;

    bool correctGuess = false;
    List<String> newGuessList = [];

    for (int i = 0; i < hiddenWord.length; i++) {
      if (hiddenWord[i] == guessedLetter) {
        newGuessList.add(guessedLetter);
        correctGuess = true;
      } else {
        newGuessList.add(currentGuess[i*2]); // Correct indexing for the letter/underscore
      }
      if (i < hiddenWord.length -1 )
        newGuessList.add(" ");
    }
    String newGuess = newGuessList.join();

    if (!correctGuess) {
      attemptsLeft--;
      setState(() {
        message = "Incorrect guess!";
      });
    } else {
      setState(() {
        message = "Correct guess!";
      });
    }
    currentGuess = newGuess;
    _inputController.clear();

    if (attemptsLeft == 0) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Game Over"),
            content: Text("Game Over! The word was: $hiddenWord"),
            actions: <Widget>[
              TextButton(onPressed: () => Navigator.pop(context), child: Text("Ok"))
            ],
          )
      );
      setState(() {
        message = "Game Over! The word was: $hiddenWord";
      });
    } else if (currentGuess.replaceAll(" ", "") == hiddenWord) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Congratulations!"),
            content: Text("Congratulations! You've guessed the word: $hiddenWord"),
            actions: <Widget>[
              TextButton(onPressed: () => Navigator.pop(context), child: Text("Ok"))
            ],
          )
      );
      setState(() {
        message = "Congratulations! You've guessed the word: $hiddenWord";
      });
    }

    setState(() {});
  }

  void _switchToGameScreen() {
    setState(() {
      _currentScreen = GameScreen.game;
      resetGame();
    });
  }

  void _switchToInitialScreen() {
    setState(() {
      _currentScreen = GameScreen.initial;
    });
  }


  Widget _buildInitialScreen(){
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF006400), Colors.lightGreen],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Welcome to Hangman Game!",
                style: TextStyle(
                  fontFamily: 'Arial Rounded MT Bold',
                  fontSize: 30,
                  color: Colors.yellow,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Select Category",
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 25,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                      colors: [Color(0xFF6B3000), Color(0xFF754D00)]
                  ),
                ),
                child: DropdownButton<String>(
                  dropdownColor: Color(0xFF724B00),
                  value: currentCategory,
                  onChanged: (String? newValue) {
                    setState(() {
                      currentCategory = newValue!;
                    });
                  },
                  items: categoryWordBank.keys.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(fontSize: 25, fontFamily: 'Arial',color: Colors.white,),
                      ),
                    );
                  }).toList(),
                  style: TextStyle(color: Colors.white, fontSize: 25, fontFamily: 'Arial'),
                  underline: Container(),
                ),
              ),
              SizedBox(height: 10),
              _createStyledButton(
                "Start Game",
                _switchToGameScreen,
                startColor: Color(0xFF1E90FF),
                endColor: Color(0xFF87CEFA),
              ),
              SizedBox(height: 10),
              _createStyledButton(
                "Exit Game",
                    () => Navigator.of(context).pop(),
                startColor: Color(0xFFFF6347),
                endColor: Color(0xFFFF4500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF00008B), Colors.cyan],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Word: $currentGuess",
                  style: TextStyle(
                    fontFamily: 'Times New Roman',
                    fontSize: 35,
                    color: Colors.yellow,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Attempts Left: $attemptsLeft",
                  style: TextStyle(
                    fontFamily: 'Arial Rounded MT Bold',
                    fontSize: 26,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _inputController,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'Arial Black',
                    color: Colors.white, // Set text color to red
                  ),
                  cursorColor: Colors.blue, // Set the cursor color to blue
                  decoration: InputDecoration(
                      hintText: "Enter a letter",
                      hintStyle: TextStyle(
                          color: Colors.white
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      )
                  ),
                  onSubmitted: (input) => handleGuess(input),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _createSmallStyledButton(
                        "Guess",
                            () => handleGuess(_inputController.text),
                        startColor: Color(0xFFFF4500),
                        endColor: Color(0xFFFF8C00)
                    ),
                    SizedBox(width: 8,),
                    _createSmallStyledButton(
                        "Play Again",
                            () {
                          resetGame();
                        },
                        startColor: Color(0xFF007519),
                        endColor: Color(0xFF007519)
                    ),
                    SizedBox(width: 8,),
                    _createSmallStyledButton(
                      "Back",
                      _switchToInitialScreen,
                      startColor: Color(0xFF9370DB),
                      endColor: Color(0xFF8A2BE2),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  message,
                  style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 18,
                      color: message == "Correct guess!" ? Colors.white : Colors.white
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _createStyledButton(
      String text,
      VoidCallback onPressed,
      {required Color startColor, required Color endColor}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 300,
        height: 70,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white, width: 2),
            gradient: LinearGradient(
                colors: [startColor, endColor]
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 10,
                offset: Offset(0, 3),
              )
            ]
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                fontSize: 24,
                fontFamily: 'Arial',
                color: Colors.white
            ),
          ),
        ),
      ),
    );
  }


  Widget _createSmallStyledButton(
      String text,
      VoidCallback onPressed,
      {required Color startColor, required Color endColor}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 95,
        height: 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white, width: 2),
            gradient: LinearGradient(
                colors: [startColor, endColor]
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 10,
                offset: Offset(0, 3),
              )
            ]
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                fontSize: 18,
                fontFamily: 'Arial',
                color: Colors.white
            ),
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    switch(_currentScreen){
      case GameScreen.initial:
        return _buildInitialScreen();
      case GameScreen.game:
        return _buildGameScreen();
      default:
        return _buildInitialScreen();
    }
  }


  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

}
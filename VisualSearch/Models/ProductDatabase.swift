import Foundation

final class ProductDatabase {
    static let shared = ProductDatabase()

    private init() {}

    let products: [Product] = [
        // MARK: Fruits
        Product(id: "fruit-apple", name: "Fuji Apple", emoji: "🍎",
                category: .fruits, price: 1.49, unit: "lb",
                description: "Crisp and sweet Fuji apples, perfect for snacking or baking.",
                keywords: ["apple", "fuji", "red apple", "fruit", "manzana"], isAvailable: true),

        Product(id: "fruit-banana", name: "Organic Banana", emoji: "🍌",
                category: .fruits, price: 0.79, unit: "lb",
                description: "Naturally sweet organic bananas, great for smoothies and snacking.",
                keywords: ["banana", "yellow fruit", "tropical", "platano", "fruit"], isAvailable: true),

        Product(id: "fruit-orange", name: "Navel Orange", emoji: "🍊",
                category: .fruits, price: 1.29, unit: "ea",
                description: "Juicy navel oranges bursting with vitamin C.",
                keywords: ["orange", "citrus", "navel", "naranja", "fruit"], isAvailable: true),

        Product(id: "fruit-strawberry", name: "Strawberries", emoji: "🍓",
                category: .fruits, price: 3.99, unit: "pint",
                description: "Fresh local strawberries, sweet and perfectly ripe.",
                keywords: ["strawberry", "berries", "red berries", "fresa", "fruit"], isAvailable: true),

        Product(id: "fruit-avocado", name: "Hass Avocado", emoji: "🥑",
                category: .fruits, price: 1.49, unit: "ea",
                description: "Creamy Hass avocados, ideal for guacamole or toast.",
                keywords: ["avocado", "guacamole", "aguacate", "green fruit"], isAvailable: true),

        Product(id: "fruit-lemon", name: "Lemon", emoji: "🍋",
                category: .fruits, price: 0.79, unit: "ea",
                description: "Bright and zesty lemons for cooking, baking, and drinks.",
                keywords: ["lemon", "citrus", "yellow", "limon", "fruit"], isAvailable: true),

        Product(id: "fruit-grapes", name: "Seedless Grapes", emoji: "🍇",
                category: .fruits, price: 2.99, unit: "lb",
                description: "Sweet seedless grapes, red or green, perfect for snacking.",
                keywords: ["grapes", "uvas", "seedless", "red grapes", "green grapes", "fruit"], isAvailable: true),

        Product(id: "fruit-watermelon", name: "Watermelon", emoji: "🍉",
                category: .fruits, price: 5.99, unit: "ea",
                description: "Refreshing whole watermelon, sweet and hydrating.",
                keywords: ["watermelon", "melon", "sandia", "fruit", "summer fruit"], isAvailable: true),

        Product(id: "fruit-peach", name: "Peach", emoji: "🍑",
                category: .fruits, price: 1.99, unit: "lb",
                description: "Tender, juicy peaches with a sweet floral aroma.",
                keywords: ["peach", "durazno", "stone fruit", "fruit"], isAvailable: true),

        // MARK: Vegetables
        Product(id: "veg-tomato", name: "Roma Tomato", emoji: "🍅",
                category: .vegetables, price: 0.99, unit: "lb",
                description: "Firm and flavorful Roma tomatoes, great for sauces and salads.",
                keywords: ["tomato", "tomate", "roma", "red", "vegetable"], isAvailable: true),

        Product(id: "veg-carrot", name: "Baby Carrots", emoji: "🥕",
                category: .vegetables, price: 1.99, unit: "bag",
                description: "Washed and ready-to-eat baby carrots, a healthy snack.",
                keywords: ["carrot", "zanahoria", "orange vegetable", "baby carrots"], isAvailable: true),

        Product(id: "veg-broccoli", name: "Broccoli", emoji: "🥦",
                category: .vegetables, price: 1.79, unit: "head",
                description: "Fresh broccoli crowns, packed with vitamins and nutrients.",
                keywords: ["broccoli", "brocoli", "green vegetable", "cruciferous"], isAvailable: true),

        Product(id: "veg-spinach", name: "Baby Spinach", emoji: "🌿",
                category: .vegetables, price: 3.49, unit: "bag",
                description: "Tender baby spinach leaves, pre-washed and ready for salads.",
                keywords: ["spinach", "espinaca", "leafy greens", "salad", "green"], isAvailable: true),

        Product(id: "veg-potato", name: "Russet Potato", emoji: "🥔",
                category: .vegetables, price: 0.89, unit: "lb",
                description: "Classic russet potatoes, versatile for baking, frying, or mashing.",
                keywords: ["potato", "papa", "russet", "starch", "vegetable"], isAvailable: true),

        Product(id: "veg-onion", name: "Yellow Onion", emoji: "🧅",
                category: .vegetables, price: 0.69, unit: "lb",
                description: "Aromatic yellow onions, essential for countless recipes.",
                keywords: ["onion", "cebolla", "yellow onion", "vegetable"], isAvailable: true),

        Product(id: "veg-corn", name: "Sweet Corn", emoji: "🌽",
                category: .vegetables, price: 0.59, unit: "ea",
                description: "Freshly picked sweet corn on the cob.",
                keywords: ["corn", "maiz", "elote", "sweet corn", "vegetable"], isAvailable: true),

        // MARK: Dairy
        Product(id: "dairy-milk", name: "Whole Milk", emoji: "🥛",
                category: .dairy, price: 4.29, unit: "gallon",
                description: "Fresh whole milk from local farms. Rich and creamy.",
                keywords: ["milk", "leche", "dairy", "whole milk", "white"], isAvailable: true),

        Product(id: "dairy-cheese", name: "Cheddar Cheese", emoji: "🧀",
                category: .dairy, price: 5.99, unit: "block",
                description: "Aged sharp cheddar cheese, perfect for sandwiches and snacking.",
                keywords: ["cheese", "queso", "cheddar", "dairy", "yellow cheese"], isAvailable: true),

        Product(id: "dairy-yogurt", name: "Greek Yogurt", emoji: "🍦",
                category: .dairy, price: 1.29, unit: "cup",
                description: "Thick and creamy Greek yogurt, high in protein.",
                keywords: ["yogurt", "greek yogurt", "dairy", "protein"], isAvailable: true),

        Product(id: "dairy-butter", name: "Unsalted Butter", emoji: "🧈",
                category: .dairy, price: 4.49, unit: "lb",
                description: "Rich unsalted butter for baking and cooking.",
                keywords: ["butter", "mantequilla", "dairy", "baking"], isAvailable: true),

        Product(id: "dairy-eggs", name: "Free-Range Eggs", emoji: "🥚",
                category: .dairy, price: 5.99, unit: "dozen",
                description: "Fresh free-range eggs from happy hens.",
                keywords: ["eggs", "huevos", "egg", "dozen", "breakfast"], isAvailable: true),

        // MARK: Bakery
        Product(id: "bakery-bread", name: "Sourdough Bread", emoji: "🍞",
                category: .bakery, price: 4.99, unit: "loaf",
                description: "Artisan sourdough with a crispy crust and tangy flavor.",
                keywords: ["bread", "pan", "sourdough", "loaf", "bakery"], isAvailable: true),

        Product(id: "bakery-croissant", name: "Butter Croissant", emoji: "🥐",
                category: .bakery, price: 2.49, unit: "ea",
                description: "Flaky, buttery croissants baked fresh every morning.",
                keywords: ["croissant", "pastry", "bakery", "butter croissant", "breakfast"], isAvailable: true),

        // MARK: Beverages
        Product(id: "bev-oj", name: "Orange Juice", emoji: "🍊",
                category: .beverages, price: 3.99, unit: "bottle",
                description: "Freshly squeezed 100% orange juice, no added sugar.",
                keywords: ["orange juice", "jugo", "juice", "beverage", "vitamin c",
                           "tropicana", "simply", "florida natural", "minute maid", "oj"], isAvailable: true),

        Product(id: "bev-water-local", name: "Salus Water", emoji: "💧",
                category: .beverages, price: 10.49, unit: "bottle",
                description: "Natural spring water from pristine mountain sources.",
                keywords: ["water", "agua", "spring water", "beverage", "hydration", "drink", "salus","sparkling", "mineral"], isAvailable: true),

        Product(id: "bev-water", name: "Spring Water", emoji: "💧",
                category: .beverages, price: 1.49, unit: "bottle",
                description: "Natural spring water from pristine mountain sources.",
                keywords: ["water", "agua", "spring water", "beverage", "hydration", "drink",
                           "evian", "volvic", "fiji", "smartwater", "dasani", "aquafina",
                           "arrowhead", "crystal geyser", "perrier", "san pellegrino", "sparkling"], isAvailable: true),

        Product(id: "bev-water-flavor", name: "Spring Water flavor", emoji: "💧",
                category: .beverages, price: 2.49, unit: "bottle",
                description: "Flavor spring water from pristine mountain sources.",
                keywords: ["water", "agua", "spring water", "beverage", "hydration", "drink", "flavor",
                           "hint", "sparkling ice", "lacroix", "bubly", "waterloo", "spindrift"], isAvailable: true),

        Product(id: "bev-coffee", name: "Ground Coffee", emoji: "☕",
                category: .beverages, price: 9.99, unit: "bag",
                description: "Medium roast ground coffee with notes of chocolate and citrus.",
                keywords: ["coffee", "cafe", "ground coffee", "beverage", "caffeine",
                           "starbucks", "folgers", "nescafe", "lavazza", "dunkin", "peet", "illy",
                           "espresso", "roast", "arabica"], isAvailable: true),

        // MARK: Snacks
        Product(id: "snack-chips", name: "Tortilla Chips", emoji: "🌮",
                category: .snacks, price: 3.49, unit: "bag",
                description: "Crunchy salted tortilla chips, perfect with salsa or guacamole.",
                keywords: ["chips", "tortilla chips", "nachos", "snack", "totopos"], isAvailable: true),

        Product(id: "snack-crackers", name: "Whole Wheat Crackers", emoji: "🫙",
                category: .snacks, price: 2.99, unit: "box",
                description: "Light and crispy whole wheat crackers for snacking or cheese pairings.",
                keywords: ["crackers", "wheat crackers", "snack", "biscuit"], isAvailable: true),
    ]

    func product(withId id: String) -> Product? {
        products.first { $0.id == id }
    }

    func products(in category: Product.Category) -> [Product] {
        products.filter { $0.category == category }
    }
}

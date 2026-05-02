# FreshMart — Visual Intelligence Demo

A grocery store iOS app that demonstrates **Apple Visual Intelligence** integration using AppIntents. Point your camera at any food product or beverage and FreshMart will surface matching items from its catalog — including brand-level recognition via on-device OCR.

Built for iOS 26.4 / Xcode 26.4.

---

## Features

- **Visual Intelligence integration** — registers as a system provider via `IntentValueQuery`, so results appear directly in the VI panel alongside Google and Amazon
- **"More results" deep link** — tapping the VI button opens the app and immediately launches the photo scanner for higher-precision results
- **On-device OCR** — uses `VNRecognizeTextRequest` to read brand names and label text from photos (e.g. detects "Salus" on a water bottle instead of just "beverage")
- **Semantic classification** — `VNClassifyImageRequest` supplements OCR with object-level labels, all running on-device with no network calls
- **Hybrid search flow** — VI handles the system entry point; the in-app camera button provides brand-accurate results when needed
- **28-product catalog** across 6 categories: Fruits, Vegetables, Dairy, Bakery, Beverages, Snacks

---

## Requirements

| | |
|---|---|
| iOS | 26.4+ |
| Xcode | 26.4+ |
| Device | Physical iPhone (Visual Intelligence requires camera; OCR works in Simulator with photo library) |

---

## Architecture

```
VisualSearch/
├── Models/
│   ├── Product.swift                 — Core data model
│   ├── ProductDatabase.swift         — 28-item mock catalog with brand keywords
│   ├── CartStore.swift               — @Observable shopping cart
│   └── GroceryProductEntity.swift    — AppEntity + EntityQuery for AppIntents
├── Services/
│   ├── ProductMatchingService.swift  — Scores products against label arrays
│   ├── ImageRecognitionService.swift — On-device OCR + image classification (Vision)
│   └── Navigator.swift               — @Observable shared navigation state
├── Intents/
│   ├── GroceryIntentValueQuery.swift — IntentValueQuery called by VI with SemanticContentDescriptor
│   ├── ShowSearchResultsIntent.swift — Opens app + launches photo scanner on "More results" tap
│   └── OpenProductIntent.swift       — Navigates to product detail from VI result tap
└── Views/
    ├── StoreView.swift               — Main catalog with camera search button in toolbar
    ├── SearchResultsView.swift       — Results sheet (used by both VI and camera flows)
    ├── ProductDetailView.swift
    ├── ProductCard.swift
    └── CartView.swift
```

All AppIntents run in the **main app target** (no extension required).

---

## How Visual Intelligence works

```
System VI flow
──────────────────────────────────────────────────────────────
Photo → Apple on-device model → SemanticContentDescriptor
                                        │
                              GroceryIntentValueQuery
                                        │
                              ProductMatchingService
                              (top 3 results, score ≥ 5)
                                        │
                              VI panel shows results ←──── GroceryProductEntity.displayRepresentation
                                        │
                    ┌───────────────────┴───────────────────┐
                    │                                       │
             Tap a result                      Tap "More results from FreshMart"
                    │                                       │
          OpenProductIntent                   ShowSearchResultsIntent
          → product detail sheet              → app opens → PhotosPicker auto-launches
                                              → ImageRecognitionService (OCR + classify)
                                              → SearchResultsView updates with brand results
```

### In-app camera flow (standalone)

The toolbar in `StoreView` has a `camera.viewfinder` button that triggers the same `ImageRecognitionService` pipeline independently of Visual Intelligence.

---

## Scoring algorithm

`ProductMatchingService` assigns a relevance score per product per label:

| Match type | Points |
|---|---|
| Exact product name | 20 |
| Emoji match | 15 |
| Partial name match | 10 |
| Exact keyword match | 8 |
| Category match | 5 |
| Partial keyword match | 4 |

Only products scoring **≥ 5** are returned. The VI panel receives the top **3** results to avoid the system "search results are limited" warning.

---

## On-device OCR

`ImageRecognitionService` runs two Vision requests in parallel:

- **`VNRecognizeTextRequest`** (`.accurate` mode) — extracts all visible text, splits into individual words, lowercased. This is what picks up brand names like "Salus", "Evian", or "Tropicana".
- **`VNClassifyImageRequest`** — semantic object labels with confidence > 0.3, supplements text with general category context.

Both run entirely on-device. No API keys, no network requests, no data leaves the device.

---

## Adding products

Extend the catalog in `ProductDatabase.swift`. Include brand names in `keywords` to maximize OCR match accuracy:

```swift
Product(
    id: "bev-sparkling",
    name: "Sparkling Water",
    emoji: "💧",
    category: .beverages,
    price: 1.99,
    unit: "bottle",
    description: "...",
    keywords: ["sparkling", "water", "perrier", "san pellegrino", "bubly", "lacroix"],
    isAvailable: true
)
```

---

## License

MIT

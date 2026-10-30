# flutter-widgets-[прізвище]

Практична робота 5 «Розробка віджетів у Flutter» (Програмування для мобільних платформ).

## Опис
Застосунок демонструє власні віджети: `ProfileWidget`, `CustomButton` (Stateless),
`AnimatedCounter`, `ProductCard` (Stateful, анімації) та простий state management
на `ChangeNotifier` + `InheritedNotifier` без сторонніх пакетів.

## Запуск
    flutter pub get
    flutter run                 # Android / iOS
    flutter run -d chrome       # веб-версія
    flutter test --coverage     # тести і покриття

## Реалізовані віджети
- `ProfileWidget` — аватар, імʼя, email; compact / expanded; адаптивність
- `CustomButton` — 4 стилі, іконка, стан завантаження, Semantics
- `AnimatedCounter` — scale-анімація, перехід кольору, progress, bounce
- `ProductCard` — свайп для обраного, zoom зображення, shimmer, bounce
- `BounceTap`, `ShimmerBox` — допоміжні анімовані віджети
- `AppState` / `AppScope` — єдине джерело стану

## Скріншоти
(додайте скріншоти головних екранів у папку `docs/screenshots/`)

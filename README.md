# 🛒 Flutter E-Commerce App — Day 14: Clean Architecture

A Flutter e-commerce application refactored to follow **Clean Architecture** principles, building on the Repository Pattern introduced in Day 13.

---

## 🏗️ Architecture Overview

The **Home** feature is organized into **3 independent layers**:

```
lib/features/home/
├── domain/             # Pure Dart — Business logic only
│   ├── entities/       # CategoryEntity, ProductEntity
│   ├── repository/     # HomeRepository (abstract interface)
│   └── use_cases/      # GetAllCategoriesUseCase, GetAllProductsUseCase
│
├── data/               # Data fetching & conversion
│   ├── models/         # CategoryDto, ProductDto (fromJson + toEntity)
│   ├── data_source/    # HomeDataSource interface & implementation
│   └── repository/     # HomeRepositoryImplementation
│
└── presentation/       # UI & State Management
    ├── view/           # HomeScreen
    ├── view_model/     # HomeCubit, HomeState
    └── widgets/        # CategoryItem, ProductItem
```

> **Key Rule:** The `Domain` layer is pure Dart — it does **not** import anything from `Presentation` or `Data`.

---

## 🔄 Data Flow

```
API JSON
   ↓
ProductDto  (Data layer — parses raw JSON)
   ↓  toEntity()
ProductEntity  (Domain layer — clean business object)
   ↓
GetAllProductsUseCase
   ↓
HomeCubit
   ↓
UI (HomeScreen)
```

---

## 🆕 What's New in Day 14

### 1. DTOs vs. Entities

| | DTO (Data Layer) | Entity (Domain Layer) |
|---|---|---|
| Location | `data/models/` | `domain/entities/` |
| Purpose | Parse raw API JSON | Represent business data |
| Has `fromJson`? | ✅ Yes | ❌ No |
| Has `toEntity()`? | ✅ Yes | ❌ No |

### 2. Use Cases

Each use case = one specific action. They sit between the Cubit and the Repository:

```dart
class GetAllCategoriesUseCase {
  final HomeRepository repository;
  GetAllCategoriesUseCase(this.repository);

  Future<ApiResult<List<CategoryEntity>>> call() {
    return repository.getAllCategories();
  }
}
```

### 3. Repository Split

- **Interface** lives in `domain/repository/` — defines *what* operations exist, returns Entities.
- **Implementation** lives in `data/repository/` — fetches DTOs, converts to Entities, returns them.

```dart
final dtos = await remoteDataSource.getAllProducts(skip: skip, limit: limit);
final entities = dtos.map((dto) => dto.toEntity()).toList();
return Success(entities);
```

### 4. Structured Error Handling with `ApiResult`

```dart
final result = await getAllCategoriesUseCase.call();
if (result is Success<List<CategoryEntity>>) {
  emit(state.copyWith(categoryState: HomeCategorySuccess(result.data)));
} else if (result is Failure<List<CategoryEntity>>) {
  emit(state.copyWith(categoryState: HomeCategoryError(result.message)));
}
```

### 5. Pagination

Products support `skip` and `limit` pagination. When the user scrolls to the bottom, `loadMoreProducts()` increments `_skip` and appends the next page.

### 6. Manual Dependency Injection

Dependencies are wired manually in `HomeScreen`:

```dart
final homeRepository = HomeRepositoryImplementation();
final getAllCategoriesUseCase = GetAllCategoriesUseCase(homeRepository);
final getAllProductsUseCase = GetAllProductsUseCase(homeRepository);

BlocProvider(
  create: (context) => HomeCubit(
    getAllCategoriesUseCase: getAllCategoriesUseCase,
    getAllProductsUseCase: getAllProductsUseCase,
  )..getAllCategories()..getAllProducts(),
)
```

---

## 📦 Features

- 🏠 Home screen with categories and products
- 🔍 Product search
- 🛒 Cart management
- ❤️ Favorites
- 👤 Account screen
- 🔐 Authentication (Login / Register)
- ♾️ Infinite scroll pagination

---

## 🔁 Day 13 → Day 14 Comparison

| Day 13 (Repository Pattern) | Day 14 (Clean Architecture) |
|---|---|
| Single `ProductModel` for everything | `ProductDto` (Data) + `ProductEntity` (Domain) |
| Cubit called Repository directly | Cubit calls **Use Cases** |
| Repo interface lived in Data layer | Repo interface in **Domain**, implementation in **Data** |
| Raw try/catch exceptions | Structured `ApiResult` (`Success` / `Failure`) |
| UI depended on Data layer models | UI depends only on **Domain Entities** |

---

## 🚀 Getting Started

```bash
flutter pub get
flutter run
```

---

## 🛠️ Tech Stack

- **Flutter** & **Dart**
- **flutter_bloc** — State management (Cubit)
- **http** — API calls
- **Clean Architecture** — 3-layer separation (Domain / Data / Presentation)

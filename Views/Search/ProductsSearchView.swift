import SwiftUI

struct ProductsSearchView: View {
    @State private var searchText = ""
    @State private var selectedCategory = "Все"
    @State private var isFilterSheetPresented = false
    
    let categories = ["Все", "Электроника", "Одежда", "Дом", "Красота", "Спорт"]
    let products = Product.mock
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: AppSpacing.md) {
                    HStack(spacing: AppSpacing.sm) {
                        SearchBar(text: $searchText, placeholder: "Поиск товаров...")
                        
                        Button {
                            isFilterSheetPresented = true
                        } label: {
                            Image(systemName: "slider.horizontal.3")
                                .font(.system(size: 18))
                                .foregroundStyle(AppColor.primaryGreen)
                                .frame(width: 44, height: 44)
                                .background(Color(.secondarySystemFill))
                                .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
                        }
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: AppSpacing.sm) {
                            ForEach(categories, id: \.self) { cat in
                                FilterChip(
                                    title: cat,
                                    isSelected: selectedCategory == cat
                                ) {
                                    withAnimation(.spring(response: 0.3)) {
                                        selectedCategory = cat
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(AppSpacing.lg)
                .background(AppColor.surface)
                
                Divider()
                
                // Grid
                ScrollView {
                    LazyVGrid(
                        columns: [GridItem(.flexible()), GridItem(.flexible())],
                        spacing: AppSpacing.md
                    ) {
                        ForEach(products) { product in
                            ProductCard(product: product)
                        }
                    }
                    .padding(AppSpacing.lg)
                }
                .background(AppColor.background)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    ModeSwitcher()
                }
            }
            .sheet(isPresented: $isFilterSheetPresented) {
                ProductFilterSheet()
            }
        }
    }
}

// MARK: - Product Filter Sheet

struct ProductFilterSheet: View {
    @Environment(\.dismiss) var dismiss
    @State private var maxPrice: Double = 100000
    @State private var selectedRating: Int = 0
    @State private var inStockOnly = false
    @State private var sortBy = "Рекомендуемые"
    
    let sortOptions = ["Рекомендуемые", "По цене ↑", "По цене ↓", "По рейтингу", "Новинки"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Сортировка") {
                    Picker("Сортировать по", selection: $sortBy) {
                        ForEach(sortOptions, id: \.self) { opt in
                            Text(opt).tag(opt)
                        }
                    }
                }
                
                Section("Цена (до)") {
                    VStack(spacing: AppSpacing.sm) {
                        HStack {
                            Text("0 с").font(AppFont.footnote()).foregroundStyle(AppColor.textTertiary)
                            Spacer()
                            Text("100.000 с").font(AppFont.footnote()).foregroundStyle(AppColor.textTertiary)
                        }
                        Slider(value: $maxPrice, in: 0...100000, step: 1000)
                            .tint(AppColor.primaryGreen)
                        Text("До \(Int(maxPrice).formatted()) с")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(AppColor.primaryGreen)
                    }
                }
                
                Section("Рейтинг") {
                    HStack(spacing: AppSpacing.md) {
                        ForEach(1...5, id: \.self) { star in
                            Image(systemName: star <= selectedRating ? "star.fill" : "star")
                                .font(.system(size: 28))
                                .foregroundStyle(star <= selectedRating ? AppColor.star : AppColor.textTertiary)
                                .onTapGesture {
                                    withAnimation { selectedRating = star == selectedRating ? 0 : star }
                                }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppSpacing.sm)
                }
                
                Section("Наличие") {
                    Toggle("Только в наличии", isOn: $inStockOnly)
                        .tint(AppColor.primaryGreen)
                }
            }
            .navigationTitle("Фильтры")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Сбросить") {
                        maxPrice = 100000; selectedRating = 0; inStockOnly = false
                    }.foregroundStyle(AppColor.textSecondary)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Готово") { dismiss() }
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(AppColor.primaryGreen)
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}

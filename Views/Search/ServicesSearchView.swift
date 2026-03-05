import SwiftUI

struct ServicesSearchView: View {
    @State private var searchText = ""
    @State private var isFilterSheetPresented = false
    @State private var selectedFilter = "Все"
    @FocusState private var isSearchFocused: Bool
    
    let filters = ["Все", "Парикмахеры", "Маникюр", "Тренеры", "Репетиторы"]
    let results = Salon.mock
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search Header
                VStack(spacing: AppSpacing.md) {
                    HStack(spacing: AppSpacing.sm) {
                        SearchBar(text: $searchText, placeholder: "Поиск услуг, салонов...")
                            .focused($isSearchFocused)
                        
                        Button {
                            isFilterSheetPresented = true
                        } label: {
                            Image(systemName: "slider.horizontal.3")
                                .font(.system(size: 18))
                                .foregroundStyle(AppColor.primary)
                                .frame(width: 44, height: 44)
                                .background(Color(.secondarySystemFill))
                                .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
                        }
                    }
                    
                    // Filter chips
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: AppSpacing.sm) {
                            ForEach(filters, id: \.self) { filter in
                                FilterChip(
                                    title: filter,
                                    isSelected: selectedFilter == filter
                                ) {
                                    withAnimation(.spring(response: 0.3)) {
                                        selectedFilter = filter
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(AppSpacing.lg)
                .background(AppColor.surface)
                
                Divider()
                
                // Results
                ScrollView {
                    LazyVStack(spacing: AppSpacing.sm) {
                        ForEach(results) { salon in
                            NavigationLink(destination: SalonDetailView(salon: salon)) {
                                SalonRow(salon: salon)
                                    .padding(.horizontal, AppSpacing.lg)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, AppSpacing.md)
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
                FilterSheet()
            }
        }
        .onAppear { isSearchFocused = false }
    }
}

// MARK: - Filter Chip

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: isSelected ? .semibold : .regular))
                .foregroundStyle(isSelected ? AppColor.primary : AppColor.textSecondary)
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, 7)
                .background(isSelected ? AppColor.primary.opacity(0.12) : Color(.secondarySystemFill))
                .overlay(
                    RoundedRectangle(cornerRadius: AppRadius.pill)
                        .stroke(isSelected ? AppColor.primary : Color.clear, lineWidth: 1.5)
                )
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Filter Sheet

struct FilterSheet: View {
    @Environment(\.dismiss) var dismiss
    @State private var priceRange: Double = 3000
    @State private var selectedRating: Int = 0
    @State private var isOpenNow = false
    @State private var sortBy = "Рекомендуемые"
    
    let sortOptions = ["Рекомендуемые", "По рейтингу", "По цене", "По расстоянию"]
    
    var body: some View {
        NavigationStack {
            Form {
                // Sort
                Section("Сортировка") {
                    Picker("Сортировать по", selection: $sortBy) {
                        ForEach(sortOptions, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                }
                
                // Price Range
                Section("Цена") {
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        HStack {
                            Text("0 с")
                                .font(AppFont.footnote())
                                .foregroundStyle(AppColor.textTertiary)
                            Spacer()
                            Text("10.000 с")
                                .font(AppFont.footnote())
                                .foregroundStyle(AppColor.textTertiary)
                        }
                        
                        Slider(value: $priceRange, in: 0...10000, step: 100)
                            .tint(AppColor.primary)
                        
                        Text("До \(Int(priceRange).formatted()) с")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(AppColor.primary)
                    }
                }
                
                // Rating
                Section("Рейтинг") {
                    HStack(spacing: AppSpacing.md) {
                        ForEach(1...5, id: \.self) { star in
                            Image(systemName: star <= selectedRating ? "star.fill" : "star")
                                .font(.system(size: 28))
                                .foregroundStyle(star <= selectedRating ? AppColor.star : AppColor.textTertiary)
                                .onTapGesture {
                                    withAnimation {
                                        selectedRating = star == selectedRating ? 0 : star
                                    }
                                }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppSpacing.sm)
                }
                
                // Additional
                Section("Дополнительно") {
                    Toggle("Открыто сейчас", isOn: $isOpenNow)
                        .tint(AppColor.primary)
                }
            }
            .navigationTitle("Фильтры")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Сбросить") {
                        priceRange = 10000
                        selectedRating = 0
                        isOpenNow = false
                        sortBy = "Рекомендуемые"
                    }
                    .foregroundStyle(AppColor.textSecondary)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Готово") {
                        dismiss()
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(AppColor.primary)
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}

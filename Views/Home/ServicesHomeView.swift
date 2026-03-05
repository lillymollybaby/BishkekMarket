import SwiftUI

struct ServicesHomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var searchText = ""
    @State private var selectedCategory: String? = nil
    
    let categories = ServiceCategory.mock
    let salons = Salon.mock
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.xxl) {
                    
                    // Search
                    NavigationLink(destination: ServicesSearchView()) {
                        SearchBar(text: $searchText, placeholder: "Поиск услуг, салонов...")
                            .background(AppColor.surface)
                            .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, AppSpacing.lg)
                    
                    // Categories
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: AppSpacing.md) {
                            ForEach(categories) { cat in
                                CategoryChip(
                                    category: cat.name,
                                    icon: cat.icon,
                                    isSelected: selectedCategory == cat.id.uuidString
                                ) {
                                    withAnimation(.spring(response: 0.3)) {
                                        if selectedCategory == cat.id.uuidString {
                                            selectedCategory = nil
                                        } else {
                                            selectedCategory = cat.id.uuidString
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, AppSpacing.lg)
                    }
                    
                    // Recommended Salons
                    VStack(alignment: .leading, spacing: AppSpacing.md) {
                        SectionHeader(title: "Рекомендуемые салоны", showAll: true)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: AppSpacing.md) {
                                ForEach(salons) { salon in
                                    NavigationLink(destination: SalonDetailView(salon: salon)) {
                                        SalonCardHorizontal(salon: salon)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, AppSpacing.lg)
                        }
                    }
                    
                    // Nearby
                    VStack(alignment: .leading, spacing: AppSpacing.md) {
                        SectionHeader(title: "Рядом со мной", showAll: true)
                        
                        VStack(spacing: AppSpacing.sm) {
                            ForEach(salons) { salon in
                                NavigationLink(destination: SalonDetailView(salon: salon)) {
                                    SalonRow(salon: salon)
                                }
                                .buttonStyle(.plain)
                                .padding(.horizontal, AppSpacing.lg)
                            }
                        }
                    }
                    
                    // Popular Services
                    VStack(alignment: .leading, spacing: AppSpacing.md) {
                        SectionHeader(title: "Популярные услуги")
                        
                        LazyVGrid(
                            columns: [GridItem(.flexible()), GridItem(.flexible())],
                            spacing: AppSpacing.md
                        ) {
                            ForEach(popularServices) { service in
                                PopularServiceCard(service: service)
                            }
                        }
                        .padding(.horizontal, AppSpacing.lg)
                    }
                    
                    // Recent Reviews
                    VStack(alignment: .leading, spacing: AppSpacing.md) {
                        SectionHeader(title: "Недавние отзывы")
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: AppSpacing.md) {
                                ForEach(mockReviews) { review in
                                    ReviewCard(review: review)
                                }
                            }
                            .padding(.horizontal, AppSpacing.lg)
                        }
                    }
                    
                    Spacer(minLength: AppSpacing.xxl)
                }
                .padding(.vertical, AppSpacing.lg)
            }
            .background(AppColor.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    ModeSwitcher()
                }
            }
        }
    }
    
    var popularServices: [Service] {
        [
            Service(name: "Стрижка женская", price: 1200, duration: 60, masterNames: []),
            Service(name: "Стрижка мужская", price: 600, duration: 30, masterNames: []),
            Service(name: "Окрашивание", price: 3500, duration: 120, masterNames: []),
            Service(name: "Укладка", price: 800, duration: 45, masterNames: [])
        ]
    }
    
    var mockReviews: [Review] {
        [
            Review(authorName: "Салима К.", rating: 5, text: "Отличный салон! Назира – волшебница, волосы выглядят потрясающе. Обязательно вернусь!", date: "3 days", likesCount: 12, hasPhotos: true),
            Review(authorName: "Мар...", rating: 4, text: "Очень довольна, внимательны и сделала...", date: "7 days", likesCount: 5, hasPhotos: false)
        ]
    }
}

// MARK: - Popular Service Card

struct PopularServiceCard: View {
    let service: Service
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            ZStack {
                RoundedRectangle(cornerRadius: AppRadius.md)
                    .fill(Color(.tertiarySystemFill))
                    .aspectRatio(1, contentMode: .fit)
                
                Image(systemName: "sparkles")
                    .font(.system(size: 32))
                    .foregroundStyle(AppColor.primary.opacity(0.4))
            }
            
            Text(service.name)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(AppColor.textPrimary)
                .lineLimit(2)
            
            Text("\(service.price.formatted()) с")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(AppColor.primary)
            
            Text("\(service.duration) мин")
                .font(.system(size: 12))
                .foregroundStyle(AppColor.textTertiary)
        }
        .padding(AppSpacing.md)
        .background(AppColor.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
    }
}

// MARK: - Review Card

struct ReviewCard: View {
    let review: Review
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            HStack {
                Circle()
                    .fill(Color(.tertiarySystemFill))
                    .frame(width: 36, height: 36)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 18))
                            .foregroundStyle(AppColor.textTertiary)
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(review.authorName)
                        .font(.system(size: 14, weight: .semibold))
                    HStack(spacing: 2) {
                        ForEach(0..<review.rating, id: \.self) { _ in
                            Image(systemName: "star.fill")
                                .font(.system(size: 10))
                                .foregroundStyle(AppColor.star)
                        }
                    }
                }
            }
            
            Text(review.text)
                .font(.system(size: 13))
                .foregroundStyle(AppColor.textPrimary)
                .lineLimit(3)
            
            if review.hasPhotos {
                HStack(spacing: AppSpacing.sm) {
                    ForEach(0..<2, id: \.self) { _ in
                        PlaceholderImage(cornerRadius: 6, aspectRatio: 1)
                            .frame(width: 44, height: 44)
                    }
                }
            }
            
            HStack {
                Text(review.date)
                    .font(.system(size: 12))
                    .foregroundStyle(AppColor.textTertiary)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "hand.thumbsup")
                        .font(.system(size: 12))
                        .foregroundStyle(AppColor.textTertiary)
                    Text("\(review.likesCount)")
                        .font(.system(size: 12))
                        .foregroundStyle(AppColor.textSecondary)
                }
            }
        }
        .padding(AppSpacing.md)
        .background(AppColor.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
        .frame(width: 240)
        .shadow(color: .black.opacity(0.04), radius: 6, y: 2)
    }
}

import SwiftUI

struct SalonDetailView: View {
    let salon: Salon
    @State private var isBookingPresented = false
    @State private var selectedTab = 0
    
    let services: [Service] = [
        Service(name: "Стрижка женская", price: 1200, duration: 60, masterNames: ["Назира", "Айгуль"]),
        Service(name: "Стрижка мужская", price: 600, duration: 30, masterNames: ["Назира"]),
        Service(name: "Окрашивание", price: 3500, duration: 120, masterNames: ["Айгуль"]),
        Service(name: "Укладка", price: 800, duration: 45, masterNames: ["Назира", "Айгуль"])
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Gallery
                GallerySection()
                
                VStack(alignment: .leading, spacing: AppSpacing.xl) {
                    
                    // Header info
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack(spacing: AppSpacing.sm) {
                                    Text(salon.name)
                                        .font(.system(size: 22, weight: .bold))
                                    if salon.isVerified {
                                        VerifiedBadge()
                                    }
                                }
                                
                                Text(salon.category)
                                    .font(AppFont.subheadline())
                                    .foregroundStyle(AppColor.textSecondary)
                            }
                            
                            Spacer()
                            
                            Button {
                                // favorite
                            } label: {
                                Image(systemName: "heart")
                                    .font(.system(size: 22))
                                    .foregroundStyle(AppColor.textSecondary)
                                    .frame(width: 44, height: 44)
                                    .background(Color(.secondarySystemFill))
                                    .clipShape(Circle())
                            }
                        }
                        
                        RatingView(rating: salon.rating, reviewCount: salon.reviewCount)
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    
                    // Contact info
                    ContactInfoSection(salon: salon)
                        .padding(.horizontal, AppSpacing.lg)
                    
                    Divider().padding(.horizontal, AppSpacing.lg)
                    
                    // Services
                    VStack(alignment: .leading, spacing: AppSpacing.md) {
                        Text("Услуги")
                            .font(.system(size: 18, weight: .bold))
                            .padding(.horizontal, AppSpacing.lg)
                        
                        ForEach(services) { service in
                            ServiceRow(service: service)
                                .padding(.horizontal, AppSpacing.lg)
                        }
                    }
                    
                    Divider().padding(.horizontal, AppSpacing.lg)
                    
                    // Reviews
                    VStack(alignment: .leading, spacing: AppSpacing.md) {
                        SectionHeader(title: "Отзывы", showAll: true)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: AppSpacing.md) {
                                ForEach(mockReviews) { review in
                                    ReviewCard(review: review)
                                }
                            }
                            .padding(.horizontal, AppSpacing.lg)
                        }
                    }
                    
                    // Bottom padding for sticky button
                    Spacer(minLength: 80)
                }
                .padding(.vertical, AppSpacing.lg)
            }
        }
        .ignoresSafeArea(edges: .top)
        .background(AppColor.background)
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            // Sticky Book Button
            VStack(spacing: 0) {
                Divider()
                HStack(spacing: AppSpacing.md) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("от \(salon.priceFrom.formatted()) с")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(AppColor.textPrimary)
                        Text("за услугу")
                            .font(AppFont.caption())
                            .foregroundStyle(AppColor.textSecondary)
                    }
                    
                    Button {
                        isBookingPresented = true
                    } label: {
                        Text("Записаться")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(AppColor.primary)
                            .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
                    }
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.vertical, AppSpacing.md)
                .background(.ultraThinMaterial)
            }
        }
        .fullScreenCover(isPresented: $isBookingPresented) {
            BookingView(salon: salon)
        }
    }
    
    var mockReviews: [Review] {
        [
            Review(authorName: "Салима К.", rating: 5, text: "Отличный салон! Назира – волшебница. Обязательно вернусь!", date: "3 days", likesCount: 12, hasPhotos: true),
            Review(authorName: "Марина В.", rating: 4, text: "Очень довольна, внимательны и сделала всё на высшем уровне", date: "7 days", likesCount: 5, hasPhotos: false)
        ]
    }
}

// MARK: - Gallery Section

struct GallerySection: View {
    @State private var currentPage = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $currentPage) {
                ForEach(0..<4, id: \.self) { i in
                    ZStack {
                        Color(.tertiarySystemFill)
                        Image(systemName: "photo")
                            .font(.system(size: 48))
                            .foregroundStyle(Color(.tertiaryLabel))
                    }
                    .tag(i)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 280)
            
            // Page dots
            HStack(spacing: 6) {
                ForEach(0..<4, id: \.self) { i in
                    Circle()
                        .fill(i == currentPage ? .white : .white.opacity(0.5))
                        .frame(width: i == currentPage ? 8 : 6, height: i == currentPage ? 8 : 6)
                        .animation(.spring(response: 0.3), value: currentPage)
                }
            }
            .padding(.bottom, AppSpacing.md)
        }
    }
}

// MARK: - Contact Info

struct ContactInfoSection: View {
    let salon: Salon
    
    var body: some View {
        VStack(spacing: AppSpacing.sm) {
            InfoRow(icon: "phone.fill", text: "+996 555 123 456", actionIcon: "arrow.up.right")
            InfoRow(icon: "location.fill", text: "ул. Чуй 123, Бишкек")
            InfoRow(icon: "clock.fill", text: "09:00 – 20:00, Пн–Сб")
            InfoRow(icon: "location.fill", text: "\(String(format: "%.1f", salon.distance)) км от вас")
        }
        .padding(AppSpacing.md)
        .background(Color(.secondarySystemFill))
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
    }
}

struct InfoRow: View {
    let icon: String
    let text: String
    var actionIcon: String? = nil
    
    var body: some View {
        HStack(spacing: AppSpacing.md) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundStyle(AppColor.primary)
                .frame(width: 20)
            
            Text(text)
                .font(AppFont.subheadline())
                .foregroundStyle(AppColor.textPrimary)
            
            Spacer()
            
            if let actionIcon {
                Image(systemName: actionIcon)
                    .font(.system(size: 12))
                    .foregroundStyle(AppColor.primary)
            }
        }
    }
}

// MARK: - Service Row

struct ServiceRow: View {
    let service: Service
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(service.name)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(AppColor.textPrimary)
                
                HStack(spacing: AppSpacing.xs) {
                    Text("\(service.duration) мин")
                        .font(AppFont.caption())
                        .foregroundStyle(AppColor.textTertiary)
                    
                    if !service.masterNames.isEmpty {
                        Text("·")
                            .foregroundStyle(AppColor.textTertiary)
                        Text(service.masterNames.joined(separator: ", "))
                            .font(AppFont.caption())
                            .foregroundStyle(AppColor.textSecondary)
                    }
                }
            }
            
            Spacer()
            
            Text("\(service.price.formatted()) с")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(AppColor.primary)
        }
        .padding(AppSpacing.md)
        .background(AppColor.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
    }
}

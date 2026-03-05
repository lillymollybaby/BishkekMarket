import SwiftUI

struct ProductsHomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var searchText = ""
    
    let products = Product.mock
    let categories = ProductCategory.mock
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.xxl) {
                    
                    // Search
                    SearchBar(text: $searchText, placeholder: "Поиск товаров...")
                        .padding(.horizontal, AppSpacing.lg)
                    
                    // Categories
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: AppSpacing.md) {
                            ForEach(categories) { cat in
                                CategoryChip(
                                    category: cat.name,
                                    icon: cat.icon,
                                    isSelected: false,
                                    action: {}
                                )
                            }
                        }
                        .padding(.horizontal, AppSpacing.lg)
                    }
                    
                    // Hot Deals Banner
                    HotDealsSection()
                    
                    // Popular Products
                    VStack(alignment: .leading, spacing: AppSpacing.md) {
                        SectionHeader(title: "Популярные товары", showAll: true)
                        
                        LazyVGrid(
                            columns: [GridItem(.flexible()), GridItem(.flexible())],
                            spacing: AppSpacing.md
                        ) {
                            ForEach(products.prefix(4)) { product in
                                ProductCard(product: product)
                            }
                        }
                        .padding(.horizontal, AppSpacing.lg)
                    }
                    
                    // Hot Discounts
                    VStack(alignment: .leading, spacing: AppSpacing.md) {
                        SectionHeader(title: "Горящие скидки 🔥", showAll: true)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: AppSpacing.md) {
                                ForEach(products.filter { $0.discount != nil }) { product in
                                    HotDealRow(product: product)
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
}

// MARK: - Hot Deals Banner

struct HotDealsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            SectionHeader(title: "Горячие предложения")
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppSpacing.md) {
                    // Electronics deal
                    HotDealBanner(
                        title: "Скидки до 30%",
                        subtitle: "На всю электронику",
                        gradient: [Color(hex: "#0A84FF"), Color(hex: "#5AC8FA")],
                        icon: "iphone"
                    )
                    
                    // Fashion deal
                    HotDealBanner(
                        title: "Новая коллекция",
                        subtitle: "Одежда 2024",
                        gradient: [Color(hex: "#BF5AF2"), Color(hex: "#FF375F")],
                        icon: "tshirt"
                    )
                    
                    // Home deal
                    HotDealBanner(
                        title: "Уют дома",
                        subtitle: "Скидки до 40%",
                        gradient: [Color(hex: "#30D158"), Color(hex: "#32ADE6")],
                        icon: "house"
                    )
                }
                .padding(.horizontal, AppSpacing.lg)
            }
        }
    }
}

struct HotDealBanner: View {
    let title: String
    let subtitle: String
    let gradient: [Color]
    let icon: String
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: AppRadius.lg)
                .fill(LinearGradient(colors: gradient, startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 160, height: 100)
            
            Image(systemName: icon)
                .font(.system(size: 36))
                .foregroundStyle(.white.opacity(0.15))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding()
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.white)
                Text(subtitle)
                    .font(.system(size: 11))
                    .foregroundStyle(.white.opacity(0.85))
            }
            .padding(AppSpacing.md)
        }
        .frame(width: 160, height: 100)
    }
}

// MARK: - Hot Deal Row (horizontal compact card)

struct HotDealRow: View {
    let product: Product
    
    var body: some View {
        HStack(spacing: AppSpacing.md) {
            PlaceholderImage(cornerRadius: AppRadius.sm, aspectRatio: 1)
                .frame(width: 60, height: 60)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.system(size: 13, weight: .medium))
                    .lineLimit(2)
                    .foregroundStyle(AppColor.textPrimary)
                
                RatingView(rating: product.rating, reviewCount: product.reviewCount, compact: true)
                
                HStack(spacing: 4) {
                    Text("\(product.price.formatted()) с")
                        .font(.system(size: 14, weight: .bold))
                    
                    if let discount = product.discount {
                        Text("-\(discount)%")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(AppColor.discountText)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 2)
                            .background(AppColor.discountBg)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                    }
                }
            }
        }
        .padding(AppSpacing.md)
        .background(AppColor.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
        .frame(width: 260)
        .shadow(color: .black.opacity(0.04), radius: 6, y: 2)
    }
}

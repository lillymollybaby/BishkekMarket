import SwiftUI

// MARK: - Search Bar

struct SearchBar: View {
    @Binding var text: String
    var placeholder: String = "Поиск..."
    var onTap: (() -> Void)? = nil
    
    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(AppColor.textTertiary)
                .font(.system(size: 16))
            
            if let onTap {
                Button(action: onTap) {
                    Text(text.isEmpty ? placeholder : text)
                        .foregroundStyle(text.isEmpty ? AppColor.textTertiary : AppColor.textPrimary)
                        .font(AppFont.body())
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .buttonStyle(.plain)
            } else {
                TextField(placeholder, text: $text)
                    .font(AppFont.body())
            }
            
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(AppColor.textTertiary)
                }
            }
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: AppRadius.md)
                .fill(Color(.secondarySystemFill))
        )
    }
}

// MARK: - Rating View

struct RatingView: View {
    let rating: Double
    let reviewCount: Int
    var compact: Bool = false
    
    var body: some View {
        HStack(spacing: 3) {
            Image(systemName: "star.fill")
                .font(.system(size: compact ? 11 : 13))
                .foregroundStyle(AppColor.star)
            
            Text(String(format: "%.1f", rating))
                .font(.system(size: compact ? 12 : 14, weight: .semibold))
                .foregroundStyle(AppColor.textPrimary)
            
            if !compact {
                Text("(\(reviewCount))")
                    .font(.system(size: 12))
                    .foregroundStyle(AppColor.textSecondary)
            }
        }
    }
}

// MARK: - Verified Badge

struct VerifiedBadge: View {
    var body: some View {
        Image(systemName: "checkmark.seal.fill")
            .foregroundStyle(AppColor.primary)
            .font(.system(size: 14))
    }
}

// MARK: - Placeholder Image

struct PlaceholderImage: View {
    var cornerRadius: CGFloat = AppRadius.md
    var aspectRatio: CGFloat = 1.0
    var icon: String = "photo"
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color(.tertiarySystemFill))
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundStyle(Color(.tertiaryLabel))
        }
        .aspectRatio(aspectRatio, contentMode: .fit)
    }
}

// MARK: - Salon Card (Horizontal - for Recommended)

struct SalonCardHorizontal: View {
    let salon: Salon
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image
            ZStack(alignment: .topTrailing) {
                PlaceholderImage(cornerRadius: AppRadius.md, aspectRatio: 4/3)
                
                if salon.isOpen {
                    Text("Открыто")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(AppColor.success)
                        .clipShape(Capsule())
                        .padding(8)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 4) {
                    Text(salon.name)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(AppColor.textPrimary)
                        .lineLimit(1)
                    
                    if salon.isVerified {
                        VerifiedBadge()
                    }
                }
                
                RatingView(rating: salon.rating, reviewCount: salon.reviewCount, compact: true)
                
                HStack(spacing: 4) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 10))
                        .foregroundStyle(AppColor.textTertiary)
                    Text("\(String(format: "%.1f", salon.distance)) км")
                        .font(.system(size: 11))
                        .foregroundStyle(AppColor.textSecondary)
                    
                    Spacer()
                    
                    Text("от \(salon.priceFrom) с")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(AppColor.primary)
                }
            }
            .padding(10)
        }
        .background(AppColor.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
        .shadow(color: .black.opacity(0.06), radius: 8, y: 2)
        .frame(width: 180)
    }
}

// MARK: - Salon Row (Vertical list - for Nearby)

struct SalonRow: View {
    let salon: Salon
    
    var body: some View {
        HStack(spacing: AppSpacing.md) {
            PlaceholderImage(cornerRadius: AppRadius.sm, aspectRatio: 1)
                .frame(width: 56, height: 56)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 4) {
                    Text(salon.name)
                        .font(AppFont.subheadline())
                        .foregroundStyle(AppColor.textPrimary)
                    if salon.isVerified { VerifiedBadge() }
                }
                
                Text(salon.category)
                    .font(AppFont.caption())
                    .foregroundStyle(AppColor.textSecondary)
                
                HStack(spacing: AppSpacing.sm) {
                    RatingView(rating: salon.rating, reviewCount: salon.reviewCount, compact: true)
                    Text("·")
                        .foregroundStyle(AppColor.textTertiary)
                    HStack(spacing: 2) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 9))
                        Text("\(String(format: "%.1f", salon.distance)) км")
                    }
                    .font(.system(size: 11))
                    .foregroundStyle(AppColor.textSecondary)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("от \(salon.priceFrom) с")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(AppColor.primary)
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(AppColor.textTertiary)
            }
        }
        .padding(AppSpacing.md)
        .background(AppColor.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
    }
}

// MARK: - Product Card (Grid)

struct ProductCard: View {
    let product: Product
    @State private var isFavorite: Bool
    
    init(product: Product) {
        self.product = product
        self._isFavorite = State(initialValue: product.isFavorite)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                PlaceholderImage(cornerRadius: AppRadius.md, aspectRatio: 1)
                
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        isFavorite.toggle()
                    }
                } label: {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 16))
                        .foregroundStyle(isFavorite ? AppColor.destructive : AppColor.textSecondary)
                        .padding(8)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                }
                .padding(8)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.system(size: 13))
                    .foregroundStyle(AppColor.textPrimary)
                    .lineLimit(2)
                
                RatingView(rating: product.rating, reviewCount: product.reviewCount, compact: true)
                
                HStack(alignment: .bottom, spacing: 4) {
                    Text("\(product.price.formatted()) с")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(AppColor.textPrimary)
                    
                    if let original = product.originalPrice {
                        Text("\(original.formatted()) с")
                            .font(.system(size: 11))
                            .foregroundStyle(AppColor.textTertiary)
                            .strikethrough()
                    }
                }
                
                if let discount = product.discount {
                    Text("-\(discount)%")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(AppColor.discountText)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(AppColor.discountBg)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }
            }
            .padding(10)
        }
        .background(AppColor.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
        .shadow(color: .black.opacity(0.06), radius: 8, y: 2)
    }
}

// MARK: - Section Header

struct SectionHeader: View {
    let title: String
    var showAll: Bool = false
    var action: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(AppColor.textPrimary)
            
            Spacer()
            
            if showAll {
                Button(action: action ?? {}) {
                    Text("Все")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(AppColor.primary)
                }
            }
        }
        .padding(.horizontal, AppSpacing.lg)
    }
}

// MARK: - Category Chip

struct CategoryChip: View {
    let category: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                ZStack {
                    RoundedRectangle(cornerRadius: AppRadius.md)
                        .fill(isSelected ? AppColor.primary : Color(.secondarySystemFill))
                        .frame(width: 52, height: 52)
                    
                    Image(systemName: icon)
                        .font(.system(size: 22))
                        .foregroundStyle(isSelected ? .white : AppColor.primary)
                }
                
                Text(category)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(isSelected ? AppColor.primary : AppColor.textSecondary)
                    .lineLimit(1)
                    .frame(width: 56)
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Primary Button

struct PrimaryButton: View {
    let title: String
    var color: Color = AppColor.primary
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Tag/Pill Button

struct PillButton: View {
    let title: String
    var style: Style = .secondary
    let action: () -> Void
    
    enum Style {
        case primary, secondary, destructive
        
        var bg: Color {
            switch self {
            case .primary: return AppColor.primary
            case .secondary: return Color(.secondarySystemFill)
            case .destructive: return Color(.systemRed)
            }
        }
        var fg: Color {
            switch self {
            case .primary: return .white
            case .secondary: return AppColor.textPrimary
            case .destructive: return .white
            }
        }
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(style.fg)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(style.bg)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Number formatter
extension Int {
    func formatted() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}

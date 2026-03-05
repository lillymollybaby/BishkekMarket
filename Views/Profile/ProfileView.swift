import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    @State private var isEditingProfile = false
    
    let user = User(
        name: "Айбек Жумабаев",
        phone: "+996 555 123 456",
        email: "aybek@example.com",
        points: 1250,
        couponsCount: 2,
        upcomingBookings: 1,
        pastBookings: 0,
        pendingOrders: 1,
        deliveredOrders: 8
    )
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    // Profile Card
                    ProfileHeaderCard(user: user) {
                        isEditingProfile = true
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    
                    // Menu Items
                    VStack(spacing: AppSpacing.sm) {
                        if appState.mode == .services {
                            ProfileMenuItem(
                                icon: "calendar",
                                iconBg: AppColor.primary.opacity(0.12),
                                iconColor: AppColor.primary,
                                title: "Мои записи",
                                subtitle: "Предстоящие: \(user.upcomingBookings) • Прошлые: \(user.pastBookings)"
                            )
                        } else {
                            ProfileMenuItem(
                                icon: "bag.fill",
                                iconBg: AppColor.primaryGreen.opacity(0.12),
                                iconColor: AppColor.primaryGreen,
                                title: "Мои заказы",
                                subtitle: "В обработке: \(user.pendingOrders) • Доставлены: \(user.deliveredOrders)"
                            )
                        }
                        
                        ProfileMenuItem(
                            icon: "heart.fill",
                            iconBg: Color(.systemRed).opacity(0.12),
                            iconColor: Color(.systemRed),
                            title: "Избранное"
                        )
                        
                        ProfileMenuItem(
                            icon: "tag.fill",
                            iconBg: Color(.systemOrange).opacity(0.12),
                            iconColor: Color(.systemOrange),
                            title: "Купоны и баллы"
                        )
                        
                        ProfileMenuItem(
                            icon: "star.fill",
                            iconBg: Color(.systemYellow).opacity(0.2),
                            iconColor: Color(.systemYellow),
                            title: "Мои отзывы"
                        )
                        
                        ProfileMenuItem(
                            icon: "location.fill",
                            iconBg: AppColor.primary.opacity(0.12),
                            iconColor: AppColor.primary,
                            title: "Адреса доставки"
                        )
                        
                        ProfileMenuItem(
                            icon: "gearshape.fill",
                            iconBg: Color(.systemGray5),
                            iconColor: AppColor.textSecondary,
                            title: "Настройки"
                        )
                        
                        ProfileMenuItem(
                            icon: "questionmark.circle.fill",
                            iconBg: AppColor.primary.opacity(0.12),
                            iconColor: AppColor.primary,
                            title: "Поддержка"
                        )
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    
                    // Logout
                    Button {
                        // logout
                    } label: {
                        HStack(spacing: AppSpacing.md) {
                            Image(systemName: "arrow.right.square.fill")
                                .font(.system(size: 20))
                                .foregroundStyle(AppColor.destructive)
                                .frame(width: 36, height: 36)
                            
                            Text("Выйти")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(AppColor.destructive)
                            
                            Spacer()
                        }
                        .padding(AppSpacing.md)
                        .background(AppColor.surface)
                        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, AppSpacing.lg)
                    
                    Spacer(minLength: AppSpacing.xxxl)
                }
                .padding(.top, AppSpacing.lg)
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

// MARK: - Profile Header Card

struct ProfileHeaderCard: View {
    let user: User
    let onEdit: () -> Void
    
    var body: some View {
        VStack(spacing: AppSpacing.lg) {
            // Avatar
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(Color(.tertiarySystemFill))
                    .frame(width: 88, height: 88)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 44))
                            .foregroundStyle(AppColor.textTertiary)
                    )
                
                Button(action: onEdit) {
                    ZStack {
                        Circle()
                            .fill(AppColor.primary)
                            .frame(width: 28, height: 28)
                        Image(systemName: "pencil")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                }
            }
            
            // User info
            VStack(spacing: 4) {
                Text(user.name)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(AppColor.textPrimary)
                
                Text(user.phone)
                    .font(AppFont.subheadline())
                    .foregroundStyle(AppColor.textSecondary)
                
                Text(user.email)
                    .font(AppFont.footnote())
                    .foregroundStyle(AppColor.textTertiary)
            }
            
            // Points and coupons
            HStack(spacing: 0) {
                VStack(spacing: 4) {
                    Text("\(user.points.formatted())")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(AppColor.primary)
                    Text("баллов")
                        .font(AppFont.caption())
                        .foregroundStyle(AppColor.textSecondary)
                }
                .frame(maxWidth: .infinity)
                
                Divider()
                    .frame(height: 36)
                
                VStack(spacing: 4) {
                    Text("\(user.couponsCount)")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(AppColor.primaryGreen)
                    Text("купонов")
                        .font(AppFont.caption())
                        .foregroundStyle(AppColor.textSecondary)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.vertical, AppSpacing.sm)
            .background(Color(.tertiarySystemFill))
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
        }
        .padding(AppSpacing.xl)
        .background(AppColor.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.xl))
        .shadow(color: .black.opacity(0.06), radius: 12, y: 4)
    }
}

// MARK: - Profile Menu Item

struct ProfileMenuItem: View {
    let icon: String
    let iconBg: Color
    let iconColor: Color
    let title: String
    var subtitle: String? = nil
    
    var body: some View {
        HStack(spacing: AppSpacing.md) {
            ZStack {
                RoundedRectangle(cornerRadius: AppRadius.sm)
                    .fill(iconBg)
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundStyle(iconColor)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16))
                    .foregroundStyle(AppColor.textPrimary)
                
                if let sub = subtitle {
                    Text(sub)
                        .font(.system(size: 12))
                        .foregroundStyle(AppColor.textSecondary)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(AppColor.textTertiary)
        }
        .padding(AppSpacing.md)
        .background(AppColor.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
    }
}

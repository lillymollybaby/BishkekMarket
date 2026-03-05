import SwiftUI

struct NotificationsView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedFilter = "Все"
    
    let filters = ["Все", "Непрочитанные", "На сегодня", "Услуги", "Товары"]
    let notifications = AppNotification.mock
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // AI Assistant banner
                AIAssistantBanner()
                    .padding(AppSpacing.lg)
                    .background(AppColor.surface)
                
                // Filter chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: AppSpacing.sm) {
                        ForEach(filters, id: \.self) { filter in
                            FilterChip(title: filter, isSelected: selectedFilter == filter) {
                                withAnimation(.spring(response: 0.3)) {
                                    selectedFilter = filter
                                }
                            }
                        }
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.vertical, AppSpacing.md)
                }
                .background(AppColor.surface)
                
                Divider()
                
                // Notifications list
                ScrollView {
                    LazyVStack(spacing: AppSpacing.sm) {
                        ForEach(notifications) { notification in
                            NotificationCard(notification: notification)
                                .padding(.horizontal, AppSpacing.lg)
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
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Всё прочитано") {
                        withAnimation { appState.notificationCount = 0 }
                    }
                    .font(.system(size: 14))
                    .foregroundStyle(AppColor.primary)
                }
            }
        }
    }
}

// MARK: - AI Assistant Banner

struct AIAssistantBanner: View {
    var body: some View {
        HStack(spacing: AppSpacing.md) {
            Image(systemName: "sparkles")
                .font(.system(size: 18))
                .foregroundStyle(AppColor.primary)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("AI-ассистент")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(AppColor.textPrimary)
                Text("Управляет вашими записями и очередями")
                    .font(.system(size: 12))
                    .foregroundStyle(AppColor.textSecondary)
            }
            
            Spacer()
        }
        .padding(AppSpacing.md)
        .background(AppColor.primary.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
        .overlay(
            VStack {
                // AI feature chips
                HStack(spacing: AppSpacing.sm) {
                    AIFeatureChip(icon: "clock", title: "Смарт-напоминания", subtitle: "Автоматические напоминания за 24ч и 1ч")
                    AIFeatureChip(icon: "person.3.fill", title: "Управление очередью", subtitle: "Отслеживание позиции в реальном времени")
                }
                .padding(.top, 80)
                .padding(.horizontal, AppSpacing.lg)
            }
            .opacity(0), alignment: .top
        )
    }
}

struct AIFeatureChip: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(AppColor.warning)
            Text(title)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(AppColor.textPrimary)
            Text(subtitle)
                .font(.system(size: 11))
                .foregroundStyle(AppColor.textSecondary)
                .lineLimit(2)
        }
        .padding(AppSpacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppColor.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
    }
}

// MARK: - Full Notifications View (actual screen)

struct NotificationsScreenView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedFilter = "Все"
    
    let filters = ["Все", "Непрочитанные", "На сегодня", "Услуги", "Товары"]
    let notifications = AppNotification.mock
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Filter scroll
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: AppSpacing.sm) {
                        ForEach(filters, id: \.self) { f in
                            FilterChip(title: f, isSelected: selectedFilter == f) {
                                withAnimation(.spring(response: 0.3)) { selectedFilter = f }
                            }
                        }
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.vertical, AppSpacing.md)
                }
                .background(AppColor.surface)
                
                // AI banner
                HStack(spacing: AppSpacing.md) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 16))
                        .foregroundStyle(AppColor.primary)
                    
                    Text("AI-ассистент")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(AppColor.textPrimary)
                    
                    Spacer()
                    
                    HStack(spacing: AppSpacing.sm) {
                        AIFeatureChip(icon: "clock", title: "Смарт-напоминания", subtitle: "Автоматические напоминания за 24ч и 1ч")
                            .frame(width: 140)
                        AIFeatureChip(icon: "person.3.fill", title: "Управление очередью", subtitle: "Отслеживание позиции в реальном времени")
                            .frame(width: 140)
                    }
                }
                .padding(AppSpacing.lg)
                .background(AppColor.surface)
                
                Divider()
                
                ScrollView {
                    LazyVStack(spacing: AppSpacing.sm) {
                        ForEach(notifications) { notification in
                            NotificationCard(notification: notification)
                                .padding(.horizontal, AppSpacing.lg)
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
        }
    }
}

// MARK: - Notification Card

struct NotificationCard: View {
    let notification: AppNotification
    
    var iconConfig: (name: String, bg: Color, fg: Color) {
        switch notification.type {
        case .reminder:
            return ("bell.fill", Color(.systemRed).opacity(0.12), Color(.systemRed))
        case .queue:
            return ("person.3.fill", Color(.systemOrange).opacity(0.12), Color(.systemOrange))
        case .masterReady:
            return ("checkmark.circle.fill", AppColor.success.opacity(0.12), AppColor.success)
        case .review:
            return ("star.fill", Color(.systemOrange).opacity(0.12), Color(.systemOrange))
        case .promo:
            return ("tag.fill", AppColor.primary.opacity(0.12), AppColor.primary)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            // Header
            HStack(spacing: AppSpacing.md) {
                ZStack {
                    Circle()
                        .fill(iconConfig.bg)
                        .frame(width: 44, height: 44)
                    Image(systemName: iconConfig.name)
                        .font(.system(size: 18))
                        .foregroundStyle(iconConfig.fg)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(notification.title)
                        .font(.system(size: 14, weight: notification.isRead ? .regular : .semibold))
                        .foregroundStyle(AppColor.textPrimary)
                    Text(notification.time)
                        .font(.system(size: 12))
                        .foregroundStyle(AppColor.textTertiary)
                }
                
                Spacer()
                
                if !notification.isRead {
                    Circle()
                        .fill(Color(.systemRed))
                        .frame(width: 8, height: 8)
                }
            }
            
            // Message
            Text(notification.message)
                .font(.system(size: 15))
                .foregroundStyle(AppColor.textPrimary)
                .lineLimit(2)
            
            // Actions
            if !notification.actions.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: AppSpacing.sm) {
                        ForEach(notification.actions) { action in
                            Button {
                                // handle action
                            } label: {
                                Text(action.title)
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundStyle(actionFG(action.style))
                                    .padding(.horizontal, AppSpacing.md)
                                    .padding(.vertical, 7)
                                    .background(actionBG(action.style))
                                    .clipShape(Capsule())
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
        .padding(AppSpacing.md)
        .background(notification.isRead ? AppColor.surface : AppColor.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: AppRadius.lg)
                .stroke(notification.isRead ? Color.clear : Color(.separator), lineWidth: 0.5)
        )
        .shadow(color: .black.opacity(notification.isRead ? 0.03 : 0.06), radius: 6, y: 2)
    }
    
    func actionBG(_ style: NotificationAction.ActionStyle) -> Color {
        switch style {
        case .primary: return AppColor.primary
        case .secondary: return Color(.secondarySystemFill)
        case .destructive: return Color(.systemRed).opacity(0.12)
        }
    }
    
    func actionFG(_ style: NotificationAction.ActionStyle) -> Color {
        switch style {
        case .primary: return .white
        case .secondary: return AppColor.textPrimary
        case .destructive: return Color(.systemRed)
        }
    }
}

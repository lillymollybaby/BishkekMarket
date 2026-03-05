import SwiftUI

/// The main mode switcher between "Услуги" and "Товары"
/// Follows Apple HIG segmented-style with fluid animation
struct ModeSwitcher: View {
    @EnvironmentObject var appState: AppState
    @Namespace private var switchNamespace
    
    var body: some View {
        HStack(spacing: 2) {
            SwitchButton(
                title: "Услуги",
                isSelected: appState.mode == .services,
                selectedColor: AppColor.primary,
                namespace: switchNamespace
            ) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                    appState.mode = .services
                }
            }
            
            SwitchButton(
                title: "Товары",
                isSelected: appState.mode == .products,
                selectedColor: AppColor.primaryGreen,
                namespace: switchNamespace
            ) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                    appState.mode = .products
                }
            }
        }
        .padding(3)
        .background(
            RoundedRectangle(cornerRadius: AppRadius.pill)
                .fill(Color(.tertiarySystemFill))
        )
    }
}

private struct SwitchButton: View {
    let title: String
    let isSelected: Bool
    let selectedColor: Color
    let namespace: Namespace.ID
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                if isSelected {
                    RoundedRectangle(cornerRadius: AppRadius.pill)
                        .fill(selectedColor)
                        .matchedGeometryEffect(id: "switcher_bg", in: namespace)
                        .shadow(color: selectedColor.opacity(0.3), radius: 4, y: 2)
                }
                
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(isSelected ? .white : AppColor.textSecondary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 7)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ModeSwitcher()
        .environmentObject(AppState())
        .padding()
}

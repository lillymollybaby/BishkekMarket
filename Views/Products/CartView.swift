import SwiftUI

struct CartView: View {
    @State private var cartItems: [CartItem] = [
        CartItem(product: Product.mock[0], quantity: 1),
        CartItem(product: Product.mock[1], quantity: 2)
    ]
    @State private var isCheckoutPresented = false
    
    var subtotal: Int { cartItems.reduce(0) { $0 + $1.product.price * $1.quantity } }
    var delivery: Int = 200
    var total: Int { subtotal + delivery }
    
    var body: some View {
        NavigationStack {
            if cartItems.isEmpty {
                EmptyCartView()
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            ModeSwitcher()
                        }
                    }
            } else {
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(spacing: AppSpacing.sm) {
                            ForEach(cartItems) { item in
                                CartItemRow(item: item,
                                    onIncrease: { updateQuantity(item, delta: 1) },
                                    onDecrease: { updateQuantity(item, delta: -1) },
                                    onRemove: { removeItem(item) }
                                )
                                .padding(.horizontal, AppSpacing.lg)
                            }
                            
                            // Order summary
                            OrderSummaryCard(subtotal: subtotal, delivery: delivery, total: total)
                                .padding(.horizontal, AppSpacing.lg)
                                .padding(.top, AppSpacing.sm)
                        }
                        .padding(.vertical, AppSpacing.md)
                    }
                    .background(AppColor.background)
                    
                    // Checkout button
                    VStack(spacing: 0) {
                        Divider()
                        VStack(spacing: AppSpacing.sm) {
                            Button {
                                isCheckoutPresented = true
                            } label: {
                                HStack {
                                    Text("Оформить заказ")
                                        .font(.system(size: 16, weight: .semibold))
                                    Spacer()
                                    Text("\(total.formatted()) с")
                                        .font(.system(size: 16, weight: .bold))
                                }
                                .foregroundStyle(.white)
                                .padding(.horizontal, AppSpacing.xl)
                                .padding(.vertical, 14)
                                .background(AppColor.primaryGreen)
                                .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
                            }
                        }
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.vertical, AppSpacing.md)
                        .background(.ultraThinMaterial)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        ModeSwitcher()
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Очистить") {
                            withAnimation { cartItems.removeAll() }
                        }
                        .font(.system(size: 14))
                        .foregroundStyle(AppColor.destructive)
                    }
                }
                .sheet(isPresented: $isCheckoutPresented) {
                    CheckoutView()
                }
            }
        }
    }
    
    func updateQuantity(_ item: CartItem, delta: Int) {
        if let idx = cartItems.firstIndex(where: { $0.id == item.id }) {
            let newQty = cartItems[idx].quantity + delta
            if newQty <= 0 {
                withAnimation { cartItems.remove(at: idx) }
            } else {
                cartItems[idx].quantity = newQty
            }
        }
    }
    
    func removeItem(_ item: CartItem) {
        withAnimation {
            cartItems.removeAll { $0.id == item.id }
        }
    }
}

// MARK: - Cart Item Row

struct CartItemRow: View {
    let item: CartItem
    let onIncrease: () -> Void
    let onDecrease: () -> Void
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: AppSpacing.md) {
            PlaceholderImage(cornerRadius: AppRadius.sm, aspectRatio: 1)
                .frame(width: 72, height: 72)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(item.product.name)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(AppColor.textPrimary)
                    .lineLimit(2)
                
                Text("\(item.product.price.formatted()) с")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(AppColor.textPrimary)
                
                // Quantity stepper
                HStack(spacing: 0) {
                    Button(action: onDecrease) {
                        Image(systemName: "minus")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(item.quantity == 1 ? AppColor.textTertiary : AppColor.textPrimary)
                            .frame(width: 32, height: 32)
                            .background(Color(.secondarySystemFill))
                    }
                    .buttonStyle(.plain)
                    
                    Text("\(item.quantity)")
                        .font(.system(size: 15, weight: .semibold))
                        .frame(width: 36, height: 32)
                        .background(Color(.secondarySystemFill))
                    
                    Button(action: onIncrease) {
                        Image(systemName: "plus")
                            .font(.system(size: 13, weight: .semibold))
                            .frame(width: 32, height: 32)
                            .background(Color(.secondarySystemFill))
                    }
                    .buttonStyle(.plain)
                }
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.sm))
            }
            
            Spacer()
            
            Button(action: onRemove) {
                Image(systemName: "trash")
                    .font(.system(size: 16))
                    .foregroundStyle(AppColor.destructive)
            }
        }
        .padding(AppSpacing.md)
        .background(AppColor.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
    }
}

// MARK: - Order Summary

struct OrderSummaryCard: View {
    let subtotal: Int
    let delivery: Int
    let total: Int
    
    var body: some View {
        VStack(spacing: AppSpacing.md) {
            Text("Итого")
                .font(.system(size: 16, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: AppSpacing.sm) {
                SummaryRow(label: "Товары", value: "\(subtotal.formatted()) с")
                SummaryRow(label: "Доставка", value: "\(delivery.formatted()) с")
                Divider()
                SummaryRow(label: "Итого", value: "\(total.formatted()) с", isBold: true)
            }
        }
        .padding(AppSpacing.lg)
        .background(AppColor.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
    }
}

struct SummaryRow: View {
    let label: String
    let value: String
    var isBold = false
    
    var body: some View {
        HStack {
            Text(label)
                .font(isBold ? .system(size: 16, weight: .bold) : AppFont.body())
                .foregroundStyle(isBold ? AppColor.textPrimary : AppColor.textSecondary)
            Spacer()
            Text(value)
                .font(isBold ? .system(size: 16, weight: .bold) : AppFont.body())
                .foregroundStyle(AppColor.textPrimary)
        }
    }
}

// MARK: - Empty Cart

struct EmptyCartView: View {
    var body: some View {
        VStack(spacing: AppSpacing.xl) {
            Spacer()
            Image(systemName: "cart")
                .font(.system(size: 64))
                .foregroundStyle(AppColor.textTertiary)
            Text("Корзина пуста")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(AppColor.textPrimary)
            Text("Добавьте товары из каталога")
                .font(AppFont.body())
                .foregroundStyle(AppColor.textSecondary)
            Spacer()
        }
    }
}

// MARK: - Checkout View

struct CheckoutView: View {
    @Environment(\.dismiss) var dismiss
    @State private var step = 1
    @State private var deliveryMethod = "Курьер"
    @State private var paymentMethod = "Наличные"
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                BookingProgressBar(current: step, total: 4)
                    .padding(AppSpacing.lg)
                    .background(AppColor.surface)
                
                ScrollView {
                    VStack(spacing: AppSpacing.xl) {
                        switch step {
                        case 1:
                            CheckoutDeliveryStep(selectedMethod: $deliveryMethod)
                        case 2:
                            CheckoutPaymentStep(selectedMethod: $paymentMethod)
                        case 3:
                            CheckoutReviewStep()
                        case 4:
                            CheckoutSuccessStep(onDone: { dismiss() })
                        default:
                            EmptyView()
                        }
                    }
                    .padding(AppSpacing.lg)
                }
                
                if step < 4 {
                    VStack(spacing: 0) {
                        Divider()
                        HStack(spacing: AppSpacing.md) {
                            if step > 1 {
                                Button {
                                    withAnimation(.spring(response: 0.35)) { step -= 1 }
                                } label: {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundStyle(AppColor.textSecondary)
                                        .frame(width: 50, height: 50)
                                        .background(Color(.secondarySystemFill))
                                        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
                                }
                            }
                            
                            Button {
                                withAnimation(.spring(response: 0.35)) { step += 1 }
                            } label: {
                                Text(step == 3 ? "Оплатить" : "Далее")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(AppColor.primaryGreen)
                                    .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
                            }
                        }
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.vertical, AppSpacing.md)
                        .background(.ultraThinMaterial)
                    }
                }
            }
            .navigationTitle(["", "Доставка", "Оплата", "Проверка", "Готово"][min(step, 4)])
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    if step < 4 {
                        Button { dismiss() } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(AppColor.textSecondary)
                        }
                    }
                }
            }
        }
    }
}

struct CheckoutDeliveryStep: View {
    @Binding var selectedMethod: String
    let methods = ["Самовывоз", "Курьер", "Почта"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.lg) {
            Text("Способ доставки")
                .font(.system(size: 22, weight: .bold))
            
            ForEach(methods, id: \.self) { method in
                Button {
                    withAnimation { selectedMethod = method }
                } label: {
                    HStack {
                        Text(method)
                            .font(AppFont.body())
                            .foregroundStyle(AppColor.textPrimary)
                        Spacer()
                        ZStack {
                            Circle()
                                .fill(selectedMethod == method ? AppColor.primaryGreen : Color(.secondarySystemFill))
                                .frame(width: 22, height: 22)
                            if selectedMethod == method {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundStyle(.white)
                            }
                        }
                    }
                    .padding(AppSpacing.md)
                    .background(
                        RoundedRectangle(cornerRadius: AppRadius.lg)
                            .fill(selectedMethod == method ? AppColor.primaryGreen.opacity(0.06) : AppColor.surface)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: AppRadius.lg)
                            .stroke(selectedMethod == method ? AppColor.primaryGreen : Color.clear, lineWidth: 1.5)
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }
}

struct CheckoutPaymentStep: View {
    @Binding var selectedMethod: String
    let methods = ["Наличные", "Элсом", "Карта"]
    let icons = ["banknote", "creditcard", "creditcard.fill"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.lg) {
            Text("Способ оплаты")
                .font(.system(size: 22, weight: .bold))
            
            ForEach(Array(zip(methods, icons)), id: \.0) { method, icon in
                Button {
                    withAnimation { selectedMethod = method }
                } label: {
                    HStack(spacing: AppSpacing.md) {
                        Image(systemName: icon)
                            .font(.system(size: 20))
                            .foregroundStyle(AppColor.primaryGreen)
                            .frame(width: 32)
                        
                        Text(method)
                            .font(AppFont.body())
                            .foregroundStyle(AppColor.textPrimary)
                        Spacer()
                        ZStack {
                            Circle()
                                .fill(selectedMethod == method ? AppColor.primaryGreen : Color(.secondarySystemFill))
                                .frame(width: 22, height: 22)
                            if selectedMethod == method {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundStyle(.white)
                            }
                        }
                    }
                    .padding(AppSpacing.md)
                    .background(
                        RoundedRectangle(cornerRadius: AppRadius.lg)
                            .fill(selectedMethod == method ? AppColor.primaryGreen.opacity(0.06) : AppColor.surface)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: AppRadius.lg)
                            .stroke(selectedMethod == method ? AppColor.primaryGreen : Color.clear, lineWidth: 1.5)
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }
}

struct CheckoutReviewStep: View {
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.lg) {
            Text("Проверьте заказ")
                .font(.system(size: 22, weight: .bold))
            
            VStack(spacing: AppSpacing.sm) {
                SummaryRow(label: "iPhone 15 Pro × 1", value: "89.900 с")
                SummaryRow(label: "Sony WH-1000XM5 × 2", value: "57.800 с")
                Divider()
                SummaryRow(label: "Доставка", value: "200 с")
                Divider()
                SummaryRow(label: "Итого", value: "147.900 с", isBold: true)
            }
            .padding(AppSpacing.lg)
            .background(AppColor.surface)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
            
            VStack(spacing: AppSpacing.sm) {
                SummaryRow(label: "Доставка", value: "Курьер")
                SummaryRow(label: "Оплата", value: "Наличные")
                SummaryRow(label: "Адрес", value: "ул. Чуй 123")
            }
            .padding(AppSpacing.lg)
            .background(AppColor.surface)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
        }
    }
}

struct CheckoutSuccessStep: View {
    let onDone: () -> Void
    
    var body: some View {
        VStack(spacing: AppSpacing.xxl) {
            Spacer(minLength: 40)
            
            ZStack {
                Circle().fill(AppColor.primaryGreen.opacity(0.12)).frame(width: 100, height: 100)
                Circle().fill(AppColor.primaryGreen.opacity(0.2)).frame(width: 80, height: 80)
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(AppColor.primaryGreen)
            }
            
            VStack(spacing: AppSpacing.sm) {
                Text("Заказ оформлен!")
                    .font(.system(size: 24, weight: .bold))
                Text("#ORD-20240315-4521")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(AppColor.textSecondary)
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.vertical, AppSpacing.sm)
                    .background(Color(.secondarySystemFill))
                    .clipShape(Capsule())
            }
            
            // Order tracking
            VStack(alignment: .leading, spacing: AppSpacing.md) {
                Text("Статус заказа")
                    .font(.system(size: 16, weight: .semibold))
                
                OrderStatusTracker()
            }
            .padding(AppSpacing.lg)
            .background(AppColor.surface)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
            
            Button(action: onDone) {
                Text("На главную")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(AppColor.primaryGreen)
                    .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
            }
            
            Spacer(minLength: 40)
        }
    }
}

struct OrderStatusTracker: View {
    let statuses = ["Принят", "Обработка", "В пути", "Доставлено"]
    let currentStep = 1
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(statuses.enumerated()), id: \.offset) { idx, status in
                VStack(spacing: 6) {
                    ZStack {
                        Circle()
                            .fill(idx <= currentStep ? AppColor.primaryGreen : Color(.tertiarySystemFill))
                            .frame(width: 24, height: 24)
                        if idx <= currentStep {
                            Image(systemName: "checkmark")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(.white)
                        }
                    }
                    Text(status)
                        .font(.system(size: 10))
                        .foregroundStyle(idx <= currentStep ? AppColor.primaryGreen : AppColor.textTertiary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                
                if idx < statuses.count - 1 {
                    Rectangle()
                        .fill(idx < currentStep ? AppColor.primaryGreen : Color(.tertiarySystemFill))
                        .frame(height: 2)
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 24)
                }
            }
        }
    }
}

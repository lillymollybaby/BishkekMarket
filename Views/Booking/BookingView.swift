import SwiftUI

struct BookingView: View {
    let salon: Salon
    @Environment(\.dismiss) var dismiss
    @State private var currentStep = 1
    @State private var selectedServices: Set<UUID> = []
    @State private var selectedMaster: UUID? = nil
    @State private var selectedDate = Date()
    @State private var selectedTime: String? = nil
    @State private var notifyBefore24h = true
    @State private var notifyBefore1h = true
    @State private var notifyQueueUpdates = true
    @State private var notes = ""
    
    let totalSteps = 5
    
    let services: [Service] = [
        Service(name: "Стрижка женская", price: 1200, duration: 60, masterNames: []),
        Service(name: "Стрижка мужская", price: 600, duration: 30, masterNames: []),
        Service(name: "Окрашивание", price: 3500, duration: 120, masterNames: []),
        Service(name: "Укладка", price: 800, duration: 45, masterNames: [])
    ]
    
    let masters: [Master] = [
        Master(name: "Назира", specialty: "Парикмахер", rating: 4.9, reviewCount: 189, availableSlots: [
            TimeSlot(time: "10:00", isAvailable: false, queueCount: 0),
            TimeSlot(time: "11:30", isAvailable: true, queueCount: 1),
            TimeSlot(time: "13:00", isAvailable: true, queueCount: 0),
            TimeSlot(time: "14:30", isAvailable: true, queueCount: 2),
            TimeSlot(time: "16:00", isAvailable: true, queueCount: 0),
        ]),
        Master(name: "Айгуль", specialty: "Колорист", rating: 4.7, reviewCount: 134, availableSlots: [
            TimeSlot(time: "09:00", isAvailable: true, queueCount: 0),
            TimeSlot(time: "12:00", isAvailable: true, queueCount: 1),
            TimeSlot(time: "15:00", isAvailable: false, queueCount: 0),
            TimeSlot(time: "17:30", isAvailable: true, queueCount: 0),
        ])
    ]
    
    var progress: Double {
        Double(currentStep) / Double(totalSteps)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Progress Bar
                BookingProgressBar(current: currentStep, total: totalSteps)
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.vertical, AppSpacing.md)
                
                // Step Content
                ScrollView {
                    VStack(spacing: AppSpacing.xl) {
                        switch currentStep {
                        case 1:
                            BookingStep1(services: services, selectedServices: $selectedServices)
                        case 2:
                            BookingStep2(masters: masters, selectedMaster: $selectedMaster, selectedTime: $selectedTime)
                        case 3:
                            BookingStep3(selectedDate: $selectedDate, selectedTime: $selectedTime, masters: masters, selectedMaster: $selectedMaster)
                        case 4:
                            BookingStep4(notify24h: $notifyBefore24h, notify1h: $notifyBefore1h, notifyQueue: $notifyQueueUpdates, notes: $notes)
                        case 5:
                            BookingSuccessView(salon: salon, onDismiss: { dismiss() })
                        default:
                            EmptyView()
                        }
                    }
                    .padding(AppSpacing.lg)
                }
                
                // Bottom Navigation
                if currentStep < 5 {
                    VStack(spacing: 0) {
                        Divider()
                        HStack(spacing: AppSpacing.md) {
                            if currentStep > 1 {
                                Button {
                                    withAnimation(.spring(response: 0.35)) {
                                        currentStep -= 1
                                    }
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
                                withAnimation(.spring(response: 0.35)) {
                                    currentStep += 1
                                }
                            } label: {
                                Text(currentStep == 4 ? "Подтвердить" : "Далее")
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
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    if currentStep < 5 {
                        Button { dismiss() } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(AppColor.textSecondary)
                        }
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text(stepTitle)
                        .font(.system(size: 16, weight: .semibold))
                }
            }
        }
    }
    
    var stepTitle: String {
        switch currentStep {
        case 1: return "Выбор услуги"
        case 2: return "Выбор мастера"
        case 3: return "Дата и время"
        case 4: return "Подтверждение"
        case 5: return "Готово!"
        default: return ""
        }
    }
}

// MARK: - Progress Bar

struct BookingProgressBar: View {
    let current: Int
    let total: Int
    
    var progress: Double { Double(current) / Double(total) }
    
    var body: some View {
        VStack(spacing: AppSpacing.xs) {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(.tertiarySystemFill))
                        .frame(height: 4)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(AppColor.primary)
                        .frame(width: geo.size.width * progress, height: 4)
                        .animation(.spring(response: 0.4), value: current)
                }
            }
            .frame(height: 4)
            
            HStack {
                Text("Шаг \(current) из \(total)")
                    .font(AppFont.caption())
                    .foregroundStyle(AppColor.textSecondary)
                Spacer()
                Text("\(Int(progress * 100))%")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(AppColor.primary)
            }
        }
    }
}

// MARK: - Step 1: Choose Service

struct BookingStep1: View {
    let services: [Service]
    @Binding var selectedServices: Set<UUID>
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.lg) {
            Text("Выберите услуги")
                .font(.system(size: 22, weight: .bold))
            
            ForEach(services) { service in
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        if selectedServices.contains(service.id) {
                            selectedServices.remove(service.id)
                        } else {
                            selectedServices.insert(service.id)
                        }
                    }
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(service.name)
                                .font(.system(size: 15, weight: .medium))
                                .foregroundStyle(AppColor.textPrimary)
                            HStack {
                                Text("\(service.duration) мин")
                                    .font(AppFont.caption())
                                    .foregroundStyle(AppColor.textTertiary)
                            }
                        }
                        
                        Spacer()
                        
                        Text("\(service.price.formatted()) с")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(AppColor.primary)
                        
                        ZStack {
                            Circle()
                                .fill(selectedServices.contains(service.id) ? AppColor.primary : Color(.secondarySystemFill))
                                .frame(width: 24, height: 24)
                            
                            if selectedServices.contains(service.id) {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundStyle(.white)
                            }
                        }
                    }
                    .padding(AppSpacing.md)
                    .background(
                        RoundedRectangle(cornerRadius: AppRadius.lg)
                            .fill(selectedServices.contains(service.id) ? AppColor.primary.opacity(0.06) : AppColor.surface)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: AppRadius.lg)
                            .stroke(selectedServices.contains(service.id) ? AppColor.primary : Color.clear, lineWidth: 1.5)
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }
}

// MARK: - Step 2: Choose Master

struct BookingStep2: View {
    let masters: [Master]
    @Binding var selectedMaster: UUID?
    @Binding var selectedTime: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.lg) {
            Text("Выберите мастера")
                .font(.system(size: 22, weight: .bold))
            
            ForEach(masters) { master in
                VStack(alignment: .leading, spacing: AppSpacing.md) {
                    Button {
                        withAnimation(.spring(response: 0.3)) {
                            selectedMaster = master.id
                        }
                    } label: {
                        HStack(spacing: AppSpacing.md) {
                            Circle()
                                .fill(Color(.tertiarySystemFill))
                                .frame(width: 52, height: 52)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 24))
                                        .foregroundStyle(AppColor.textTertiary)
                                )
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(master.name)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(AppColor.textPrimary)
                                Text(master.specialty)
                                    .font(AppFont.subheadline())
                                    .foregroundStyle(AppColor.textSecondary)
                                RatingView(rating: master.rating, reviewCount: master.reviewCount, compact: true)
                            }
                            
                            Spacer()
                            
                            ZStack {
                                Circle()
                                    .fill(selectedMaster == master.id ? AppColor.primary : Color(.secondarySystemFill))
                                    .frame(width: 24, height: 24)
                                if selectedMaster == master.id {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundStyle(.white)
                                }
                            }
                        }
                        .padding(AppSpacing.md)
                        .background(
                            RoundedRectangle(cornerRadius: AppRadius.lg)
                                .fill(selectedMaster == master.id ? AppColor.primary.opacity(0.06) : AppColor.surface)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: AppRadius.lg)
                                .stroke(selectedMaster == master.id ? AppColor.primary : Color.clear, lineWidth: 1.5)
                        )
                    }
                    .buttonStyle(.plain)
                    
                    // Time slots
                    if selectedMaster == master.id {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: AppSpacing.sm) {
                                ForEach(master.availableSlots) { slot in
                                    TimeSlotChip(slot: slot, isSelected: selectedTime == slot.time) {
                                        if slot.isAvailable {
                                            withAnimation(.spring(response: 0.3)) {
                                                selectedTime = slot.time
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }
                }
            }
        }
    }
}

struct TimeSlotChip: View {
    let slot: TimeSlot
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(slot.time)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(
                        !slot.isAvailable ? AppColor.textTertiary :
                        isSelected ? .white : AppColor.textPrimary
                    )
                
                if slot.queueCount > 0 && slot.isAvailable {
                    Text("~\(slot.queueCount) чел")
                        .font(.system(size: 10))
                        .foregroundStyle(isSelected ? .white.opacity(0.8) : AppColor.textTertiary)
                }
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.sm)
            .background(
                RoundedRectangle(cornerRadius: AppRadius.sm)
                    .fill(
                        !slot.isAvailable ? Color(.tertiarySystemFill) :
                        isSelected ? AppColor.primary : Color(.secondarySystemFill)
                    )
            )
        }
        .disabled(!slot.isAvailable)
        .buttonStyle(.plain)
    }
}

// MARK: - Step 3: Date & Time

struct BookingStep3: View {
    @Binding var selectedDate: Date
    @Binding var selectedTime: String?
    let masters: [Master]
    @Binding var selectedMaster: UUID?
    
    var currentMaster: Master? {
        masters.first { $0.id == selectedMaster }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.lg) {
            Text("Выберите дату")
                .font(.system(size: 22, weight: .bold))
            
            // Calendar
            DatePicker("", selection: $selectedDate, in: Date()..., displayedComponents: .date)
                .datePickerStyle(.graphical)
                .tint(AppColor.primary)
                .padding(AppSpacing.md)
                .background(AppColor.surface)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
            
            // AI advice card
            HStack(spacing: AppSpacing.md) {
                ZStack {
                    Circle()
                        .fill(AppColor.primary.opacity(0.12))
                        .frame(width: 40, height: 40)
                    Image(systemName: "sparkles")
                        .font(.system(size: 16))
                        .foregroundStyle(AppColor.primary)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("AI рекомендует")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(AppColor.primary)
                    Text("Приди в 14:30, в очереди 1 человек")
                        .font(.system(size: 14))
                        .foregroundStyle(AppColor.textPrimary)
                }
            }
            .padding(AppSpacing.md)
            .background(AppColor.primary.opacity(0.06))
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.md)
                    .stroke(AppColor.primary.opacity(0.2), lineWidth: 1)
            )
            
            // Time slots
            if let master = currentMaster {
                VStack(alignment: .leading, spacing: AppSpacing.md) {
                    Text("Свободное время")
                        .font(.system(size: 16, weight: .semibold))
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: AppSpacing.sm) {
                        ForEach(master.availableSlots) { slot in
                            TimeSlotChip(slot: slot, isSelected: selectedTime == slot.time) {
                                if slot.isAvailable {
                                    withAnimation { selectedTime = slot.time }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Step 4: Confirmation

struct BookingStep4: View {
    @Binding var notify24h: Bool
    @Binding var notify1h: Bool
    @Binding var notifyQueue: Bool
    @Binding var notes: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xl) {
            Text("Почти готово!")
                .font(.system(size: 22, weight: .bold))
            
            // Contact info
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("Ваши контакты")
                    .font(.system(size: 16, weight: .semibold))
                
                VStack(spacing: AppSpacing.sm) {
                    ContactRow(icon: "person.fill", value: "Айбек Жумабаев")
                    ContactRow(icon: "phone.fill", value: "+996 555 123 456")
                }
                .padding(AppSpacing.md)
                .background(AppColor.surface)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
            }
            
            // Notes
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("Пожелания")
                    .font(.system(size: 16, weight: .semibold))
                
                TextEditor(text: $notes)
                    .font(AppFont.body())
                    .frame(height: 80)
                    .padding(AppSpacing.md)
                    .background(AppColor.surface)
                    .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
                    .overlay(
                        Group {
                            if notes.isEmpty {
                                Text("Любые пожелания мастеру...")
                                    .font(AppFont.body())
                                    .foregroundStyle(AppColor.textTertiary)
                                    .padding(AppSpacing.lg)
                                    .allowsHitTesting(false)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                            }
                        }
                    )
            }
            
            // Notifications
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("Уведомления")
                    .font(.system(size: 16, weight: .semibold))
                
                VStack(spacing: 0) {
                    Toggle("За 24 часа до записи", isOn: $notify24h)
                        .font(AppFont.body())
                        .tint(AppColor.primary)
                        .padding(AppSpacing.md)
                    
                    Divider().padding(.horizontal, AppSpacing.md)
                    
                    Toggle("За 1 час до записи", isOn: $notify1h)
                        .font(AppFont.body())
                        .tint(AppColor.primary)
                        .padding(AppSpacing.md)
                    
                    Divider().padding(.horizontal, AppSpacing.md)
                    
                    Toggle("Обновления очереди", isOn: $notifyQueue)
                        .font(AppFont.body())
                        .tint(AppColor.primary)
                        .padding(AppSpacing.md)
                }
                .background(AppColor.surface)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
            }
        }
    }
}

struct ContactRow: View {
    let icon: String
    let value: String
    
    var body: some View {
        HStack(spacing: AppSpacing.md) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundStyle(AppColor.primary)
                .frame(width: 20)
            Text(value)
                .font(AppFont.body())
                .foregroundStyle(AppColor.textPrimary)
        }
    }
}

// MARK: - Step 5: Success

struct BookingSuccessView: View {
    let salon: Salon
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: AppSpacing.xxl) {
            Spacer(minLength: 40)
            
            // Success icon
            ZStack {
                Circle()
                    .fill(AppColor.success.opacity(0.12))
                    .frame(width: 100, height: 100)
                Circle()
                    .fill(AppColor.success.opacity(0.2))
                    .frame(width: 80, height: 80)
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(AppColor.success)
            }
            
            VStack(spacing: AppSpacing.sm) {
                Text("Запись подтверждена!")
                    .font(.system(size: 24, weight: .bold))
                
                Text("#BK-202403-7824")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(AppColor.textSecondary)
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.vertical, AppSpacing.sm)
                    .background(Color(.secondarySystemFill))
                    .clipShape(Capsule())
            }
            
            // Booking summary
            VStack(spacing: AppSpacing.md) {
                BookingSummaryRow(icon: "house.fill", label: "Салон", value: salon.name)
                BookingSummaryRow(icon: "calendar", label: "Дата", value: "15 марта 2024")
                BookingSummaryRow(icon: "clock.fill", label: "Время", value: "14:30")
                BookingSummaryRow(icon: "person.fill", label: "Мастер", value: "Назира")
            }
            .padding(AppSpacing.lg)
            .background(AppColor.surface)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
            
            // AI tip
            HStack(spacing: AppSpacing.md) {
                Image(systemName: "sparkles")
                    .foregroundStyle(AppColor.primary)
                Text("Советуем прийти за 5 минут до начала")
                    .font(.system(size: 14))
                    .foregroundStyle(AppColor.textSecondary)
            }
            .padding(AppSpacing.md)
            .background(AppColor.primary.opacity(0.06))
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
            
            // Actions
            VStack(spacing: AppSpacing.sm) {
                HStack(spacing: AppSpacing.md) {
                    Button {
                        // add to calendar
                    } label: {
                        Label("Календарь", systemImage: "calendar.badge.plus")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(AppColor.primary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(AppColor.primary.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
                    }
                    
                    Button {
                        // message master
                    } label: {
                        Label("Написать", systemImage: "message")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(AppColor.primary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(AppColor.primary.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
                    }
                }
                
                Button(action: onDismiss) {
                    Text("На главную")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(AppColor.primary)
                        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
                }
            }
            
            Spacer(minLength: 40)
        }
    }
}

struct BookingSummaryRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundStyle(AppColor.primary)
                .frame(width: 20)
            Text(label)
                .font(AppFont.subheadline())
                .foregroundStyle(AppColor.textSecondary)
            Spacer()
            Text(value)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(AppColor.textPrimary)
        }
    }
}

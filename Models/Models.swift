import SwiftUI

// MARK: - Services Models

struct Salon: Identifiable {
    let id = UUID()
    var name: String
    var category: String
    var rating: Double
    var reviewCount: Int
    var distance: Double
    var priceFrom: Int
    var isOpen: Bool
    var isVerified: Bool
    var imageName: String?
}

struct Master: Identifiable {
    let id = UUID()
    var name: String
    var specialty: String
    var rating: Double
    var reviewCount: Int
    var availableSlots: [TimeSlot]
    var imageName: String?
}

struct Service: Identifiable {
    let id = UUID()
    var name: String
    var price: Int
    var duration: Int // minutes
    var masterNames: [String]
}

struct TimeSlot: Identifiable {
    let id = UUID()
    var time: String
    var isAvailable: Bool
    var queueCount: Int
}

struct Review: Identifiable {
    let id = UUID()
    var authorName: String
    var rating: Int
    var text: String
    var date: String
    var likesCount: Int
    var hasPhotos: Bool
}

struct ServiceCategory: Identifiable {
    let id = UUID()
    var name: String
    var icon: String // SF Symbol
}

// MARK: - Products Models

struct Product: Identifiable {
    let id = UUID()
    var name: String
    var price: Int
    var originalPrice: Int?
    var rating: Double
    var reviewCount: Int
    var category: String
    var isFavorite: Bool = false
    var imageName: String?
    
    var discount: Int? {
        guard let original = originalPrice, original > price else { return nil }
        return Int(((Double(original - price) / Double(original)) * 100).rounded())
    }
}

struct ProductCategory: Identifiable {
    let id = UUID()
    var name: String
    var icon: String // SF Symbol
}

struct CartItem: Identifiable {
    let id = UUID()
    var product: Product
    var quantity: Int
}

// MARK: - Notifications Models

enum NotificationType {
    case reminder
    case queue
    case masterReady
    case review
    case promo
}

struct AppNotification: Identifiable {
    let id = UUID()
    var type: NotificationType
    var title: String
    var message: String
    var time: String
    var isRead: Bool = false
    var actions: [NotificationAction]
}

struct NotificationAction: Identifiable {
    let id = UUID()
    var title: String
    var style: ActionStyle
    
    enum ActionStyle {
        case primary, secondary, destructive
    }
}

// MARK: - Booking Models

struct Booking: Identifiable {
    let id = UUID()
    var bookingNumber: String
    var salonName: String
    var masterName: String
    var serviceName: String
    var date: String
    var time: String
    var status: BookingStatus
    var price: Int
}

enum BookingStatus {
    case upcoming, completed, cancelled
}

// MARK: - User Model

struct User {
    var name: String
    var phone: String
    var email: String
    var points: Int
    var couponsCount: Int
    var upcomingBookings: Int
    var pastBookings: Int
    var pendingOrders: Int
    var deliveredOrders: Int
}

// MARK: - Mock Data

extension Salon {
    static let mock: [Salon] = [
        Salon(name: "Салон красоты АЗИЯ", category: "Парикмахеры", rating: 4.8, reviewCount: 324, distance: 1.2, priceFrom: 600, isOpen: true, isVerified: true),
        Salon(name: "Nail Studio Elite", category: "Маникюр", rating: 4.9, reviewCount: 156, distance: 0.8, priceFrom: 800, isOpen: true, isVerified: true),
        Salon(name: "FitZone Gym", category: "Тренеры", rating: 4.6, reviewCount: 89, distance: 2.5, priceFrom: 800, isOpen: false, isVerified: true)
    ]
}

extension Product {
    static let mock: [Product] = [
        Product(name: "iPhone 15 Pro 256GB", price: 89900, originalPrice: 99900, rating: 4.9, reviewCount: 245, category: "Электроника"),
        Product(name: "Sony WH-1000XM5", price: 28900, originalPrice: 34900, rating: 4.8, reviewCount: 189, category: "Электроника"),
        Product(name: "Nike Air Force 1", price: 8900, originalPrice: nil, rating: 4.7, reviewCount: 423, category: "Одежда"),
        Product(name: "Кофемашина DeLonghi", price: 45900, originalPrice: 52900, rating: 4.6, reviewCount: 67, category: "Дом"),
        Product(name: "Механическая клавиатура Keychron", price: 18900, originalPrice: nil, rating: 4.9, reviewCount: 112, category: "Электроника"),
        Product(name: "Зимняя куртка Columbia", price: 12500, originalPrice: 18900, rating: 4.5, reviewCount: 89, category: "Одежда")
    ]
}

extension ServiceCategory {
    static let mock: [ServiceCategory] = [
        ServiceCategory(name: "Парикмах...", icon: "scissors"),
        ServiceCategory(name: "Маникюр", icon: "paintbrush.pointed"),
        ServiceCategory(name: "Тренеры", icon: "figure.run"),
        ServiceCategory(name: "Репетиторы", icon: "book"),
        ServiceCategory(name: "Массаж", icon: "hands.sparkles")
    ]
}

extension ProductCategory {
    static let mock: [ProductCategory] = [
        ProductCategory(name: "Электрон...", icon: "iphone"),
        ProductCategory(name: "Одежда", icon: "tshirt"),
        ProductCategory(name: "Дом", icon: "house"),
        ProductCategory(name: "Красота", icon: "sparkles"),
        ProductCategory(name: "Спорт", icon: "sportscourt")
    ]
}

extension AppNotification {
    static let mock: [AppNotification] = [
        AppNotification(
            type: .reminder,
            title: "Напоминание о записи",
            message: "Завтра в 14:30 у Назиры. Подтвердите!",
            time: "7 min, 12 sec",
            isRead: false,
            actions: [
                NotificationAction(title: "Подтвердить", style: .primary),
                NotificationAction(title: "Отменить", style: .secondary),
                NotificationAction(title: "Перенести", style: .secondary)
            ]
        ),
        AppNotification(
            type: .queue,
            title: "Обновление очереди",
            message: "Вы на позиции #3. Мастер закончит в 14:45",
            time: "12 min, 12 sec",
            isRead: false,
            actions: [
                NotificationAction(title: "Я в пути", style: .primary),
                NotificationAction(title: "Опаздываю", style: .secondary),
                NotificationAction(title: "Отменить", style: .secondary)
            ]
        ),
        AppNotification(
            type: .masterReady,
            title: "Мастер готова!",
            message: "Мастер готова к вам! Кабинет №2",
            time: "17 min, 12 sec",
            isRead: true,
            actions: [
                NotificationAction(title: "Я уже здесь", style: .primary),
                NotificationAction(title: "Опаздываю", style: .secondary)
            ]
        ),
        AppNotification(
            type: .review,
            title: "Оставьте отзыв",
            message: "Как вам результат? Поделитесь впечатлениями",
            time: "1 day",
            isRead: true,
            actions: [
                NotificationAction(title: "Оставить отзыв", style: .primary)
            ]
        ),
        AppNotification(
            type: .promo,
            title: "Специальное предложение",
            message: "Скидка 20% в салоне АЗИЯ сегодня",
            time: "2 days",
            isRead: true,
            actions: [
                NotificationAction(title: "Записаться", style: .primary),
                NotificationAction(title: "Не интересует", style: .secondary)
            ]
        )
    ]
}

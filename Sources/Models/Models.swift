import Foundation

enum ContentCategory: String, CaseIterable, Identifiable {
    case wellness = "Wellness"
    case leadership = "Leadership"
    case performance = "Performance"
    case creativity = "Creativity"
    var id: String { rawValue }
}

struct Lesson: Identifiable, Hashable {
    let id = UUID()
    let index: Int
    let title: String
    let subtitle: String
    let duration: String
    let isLocked: Bool
}

struct ContentItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let author: String
    let category: ContentCategory
    let kind: String          // Workshop / Article / Audio / Video
    let duration: String
    let meta: String          // e.g. "12 Lessons", "4K", "HD Video"
    let summary: String
    let isPremium: Bool
    let artSeed: Int
    let icon: String
    let imageName: String     // bundled photo (matches the Stitch design)
    var progress: Double = 0  // 0...1 for "continue watching"
    let lessons: [Lesson]

    static func == (l: ContentItem, r: ContentItem) -> Bool { l.id == r.id }
    func hash(into h: inout Hasher) { h.combine(id) }
}

enum MockData {
    static func standardLessons() -> [Lesson] {
        [
            Lesson(index: 1, title: "Introduction",
                   subtitle: "The science of morning rituals", duration: "5 min", isLocked: false),
            Lesson(index: 2, title: "Breathing Techniques",
                   subtitle: "Breathwork for vital energy", duration: "12 min", isLocked: false),
            Lesson(index: 3, title: "Guided Meditation",
                   subtitle: "Visualizing your ideal day", duration: "20 min", isLocked: false),
            Lesson(index: 4, title: "Closing Journaling",
                   subtitle: "Reflective practice", duration: "8 min", isLocked: true),
        ]
    }

    static let items: [ContentItem] = [
        ContentItem(
            title: "Morning Mindfulness Rituals", author: "Sarah Jenkins",
            category: .wellness, kind: "Workshop", duration: "45 min", meta: "4K",
            summary: "Start your day with intention. This premium workshop guided by Sarah Jenkins walks you through a transformative morning sequence designed to ground your energy and clarify your focus for the day ahead.",
            isPremium: true, artSeed: 0, icon: "figure.mind.and.body", imageName: "meditation",
            progress: 0, lessons: standardLessons()),
        ContentItem(
            title: "Gourmet Plant Basics", author: "Chef Julian",
            category: .wellness, kind: "Workshop", duration: "60 min", meta: "12 Lessons",
            summary: "A hands-on culinary series turning everyday produce into restaurant-grade plates, taught by Chef Julian.",
            isPremium: true, artSeed: 1, icon: "leaf.fill", imageName: "food",
            progress: 0, lessons: standardLessons()),
        ContentItem(
            title: "Modern Interiors", author: "Design Studio",
            category: .creativity, kind: "Workshop", duration: "40 min", meta: "8 Lessons",
            summary: "Reimagine your living space with light, texture and intentional negative space.",
            isPremium: true, artSeed: 2, icon: "house.fill", imageName: "chairInterior",
            progress: 0, lessons: standardLessons()),
        ContentItem(
            title: "Visual Storytelling", author: "Mark Ellis",
            category: .creativity, kind: "Video", duration: "35 min", meta: "Audio Only",
            summary: "Frame, light and compose images that move people. A practical photography masterclass.",
            isPremium: true, artSeed: 3, icon: "camera.fill", imageName: "camera",
            progress: 0.75, lessons: standardLessons()),
        ContentItem(
            title: "Leading with Empathy", author: "Dr. Naomi Cole",
            category: .leadership, kind: "Audio", duration: "25 min", meta: "Audio Only",
            summary: "Build trust and psychological safety on your team through empathetic leadership habits.",
            isPremium: false, artSeed: 1, icon: "person.2.fill", imageName: "portraitWoman",
            progress: 0, lessons: standardLessons()),
        ContentItem(
            title: "Functional Strength 101", author: "Coach Reyes",
            category: .performance, kind: "Video", duration: "40 min", meta: "HD Video",
            summary: "A progressive bodyweight program that builds real-world strength without a gym.",
            isPremium: true, artSeed: 2, icon: "figure.strengthtraining.functional", imageName: "sunsetWindow",
            progress: 0, lessons: standardLessons()),
        ContentItem(
            title: "Quiet Focus Mastery", author: "Sarah Jenkins",
            category: .wellness, kind: "Workshop", duration: "30 min", meta: "6 Lessons",
            summary: "Train deep concentration and reclaim your attention in a distracted world.",
            isPremium: true, artSeed: 0, icon: "brain.head.profile", imageName: "laptop",
            progress: 0, lessons: standardLessons()),
        ContentItem(
            title: "Empathetic Strategy", author: "Dr. Naomi Cole",
            category: .leadership, kind: "Article", duration: "12 min", meta: "Article",
            summary: "Align team strategy with human needs - a framework for compassionate decision making.",
            isPremium: false, artSeed: 3, icon: "lightbulb.fill", imageName: "businessWoman",
            progress: 0, lessons: standardLessons()),
    ]
}

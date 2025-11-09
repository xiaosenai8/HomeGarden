//
//  CalendarView.swift
//  HomeGarden
//
//  Created by konishi on 2025/11/09
//

import SwiftUI
import _SwiftData_SwiftUI

//==================================================//
// MARK: - CalendarView
//==================================================//
struct CalendarView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: [SortDescriptor(\Crop.orderIndex, order: .forward)])
    private var crops: [Crop]
    
    @Query(sort: [SortDescriptor(\Activity.date, order: .reverse)])
    private var activities: [Activity]
    
    // ✅ 有効な作物だけのアクティビティを残す
//    private var activities: [Activity] {
//        rawActivities.filter {
//            if let crop = $0.crop {
//                return !crop.isArchived && !crop.isDeleted // 削除 or アーカイブ済み除外
//            }
//            return false
//        }
//    }
    
    
    @State private var selectedDate = Date()
    
    var body: some View {
        VStack(spacing: 0) {
            
            // カレンダー上部（固定）
            VStack(spacing: 16) {
                CalendarHeaderView(selectedDate: $selectedDate)
                CalendarGridView(selectedDate: $selectedDate, activities: activities)
            }
            .padding()
            .background(Color(.systemBackground))
            .shadow(radius: 1)
            
            Divider()
            
            // アクティビティ一覧（スクロール）
            ScrollView {
                ActivityListView(selectedDate: selectedDate, activities: activities)
                    .padding()
            }
        }
        .navigationTitle("カレンダー")
        .navigationBarTitleDisplayMode(.inline)
    }
}

//==================================================//
// MARK: - CalendarHeaderView
//==================================================//
struct CalendarHeaderView: View {
    @Binding var selectedDate: Date
    
    private var monthFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy年M月"
        return formatter
    }
    
    var body: some View {
        HStack {
            Button {
                changeMonth(by: -1)
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title3)
            }
            
            Spacer()
            
            Text(monthFormatter.string(from: selectedDate))
                .font(.title3.bold())
            
            Spacer()
            
            Button {
                changeMonth(by: 1)
            } label: {
                Image(systemName: "chevron.right")
                    .font(.title3)
            }
        }
    }
    
    func changeMonth(by value: Int) {
        if let newDate = Calendar.current.date(byAdding: .month, value: value, to: selectedDate) {
            selectedDate = newDate
        }
    }
}

//==================================================//
// MARK: - CalendarGridView
//==================================================//
struct CalendarGridView: View {
    @Binding var selectedDate: Date
    var activities: [Activity]
    private let calendar = Calendar.current
    
    var body: some View {
        VStack(spacing: 8) {
            // 曜日ヘッダー
            HStack {
                ForEach(["日","月","火","水","木","金","土"], id: \.self) { day in
                    Text(day)
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(day == "日" ? .red : .primary)
                }
            }
            
            // 日付グリッド
            let days = makeDays(for: selectedDate)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                ForEach(days, id: \.self) { date in
                    if date != Date.distantPast {
                        VStack(spacing: 4) {
                            Text("\(calendar.component(.day, from: date))")
                                .frame(maxWidth: .infinity)
                                .padding(6)
                                .background(
                                    Circle()
                                        .fill(calendar.isDate(date, inSameDayAs: selectedDate) ? Color.black : .clear)
                                )
                                .foregroundColor(calendar.isDate(date, inSameDayAs: selectedDate) ? .white : .primary)
                                .onTapGesture { selectedDate = date }
                            
                            // 🟢 作物カラーのドットを表示
//                            HStack(spacing: 3) {
//                                ForEach(cropColorsForDate(date), id: \.self) { color in
//                                    Circle()
//                                        .fill(color)
//                                        .frame(width: 6, height: 6)
//                                }
//                            }
                        }
                        .frame(height: 50)
                    } else {
                        Color.clear.frame(height: 32)
                    }
                }
            }
        }
    }
    
    // MARK: - 当月の日付生成
    func makeDays(for date: Date) -> [Date] {
        guard let range = calendar.range(of: .day, in: .month, for: date),
              let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: date))
        else { return [] }
        
        var days: [Date] = []
        let firstWeekday = calendar.component(.weekday, from: firstDay)
        for _ in 1..<firstWeekday { days.append(Date.distantPast) }
        for day in range {
            if let dayDate = calendar.date(byAdding: .day, value: day - 1, to: firstDay) {
                days.append(dayDate)
            }
        }
        return days
    }
    
    // MARK: - 指定日の作物カラー一覧
    func cropColorsForDate(_ date: Date) -> [Color] {
        let dayActivities = activities.filter {
            calendar.isDate($0.date, inSameDayAs: date)
        }
        
        // ✅ 無効化済みのCropは完全スキップ（クラッシュ防止）
        var validColors: [Color] = []
        for activity in dayActivities {
            guard
                let crop = activity.crop,            // Cropがnilでない
                !crop.isDeleted,                     // SwiftDataから削除されていない
                !crop.isArchived                     // アーカイブされていない
            else {
                continue
            }
            
            // Cropが安全に参照可能
            validColors.append(crop.displayColor)
        }
        
        // ✅ 重複除去して最大3色まで
        let uniqueColors = Array(Set(validColors))
        return Array(uniqueColors.prefix(3))
    }}


//==================================================//
// MARK: - ActivityListView
//==================================================//
struct ActivityListView: View {
    let selectedDate: Date
    let activities: [Activity]
    private let calendar = Calendar.current
    
    // 選択日のアクティビティのみ抽出
    var filteredActivities: [Activity] {
        activities.filter { calendar.isDate($0.date, inSameDayAs: selectedDate) }
    }
    
    // 作物ごとにグループ化
    var groupedByCrop: [(crop: Crop?, activities: [Activity])] {
        Dictionary(grouping: filteredActivities, by: { $0.crop })
            .sorted { ($0.key?.name ?? "") < ($1.key?.name ?? "") }
            .map { (crop: $0.key, activities: $0.value) }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // ✅ 日付を日本語形式で表示
            Text(formattedDate(selectedDate))
                .font(.headline)
                .padding(.bottom, 4)
            
            if filteredActivities.isEmpty {
                Text("この日の作業はありません")
                    .foregroundColor(.gray)
                    .font(.subheadline)
                    .padding(.vertical, 4)
            } else {
                // ✅ 作物ごとにセクション化
                ForEach(groupedByCrop, id: \.crop?.id) { group in
                    VStack(alignment: .leading, spacing: 8) {
                        // 🌱 セクション見出し（作物名＋カラー）
                        if let crop = group.crop {
                            HStack(spacing: 6) {
                                Image(crop.icon.iconName)
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(crop.displayColor)
                                Text(crop.name)
                                    .font(.headline)
                            }
                        } else {
                            Text("作物未設定")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                        
                        // 💧 作業一覧
                        ForEach(group.activities, id: \.self) { activity in
                            HStack {
                                Text(activity.activity.activityName)
                                    .font(.body)
                                Spacer()
                            }
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                    }
                    .padding(.vertical, 6)
                }
            }
        }
    }
    
    // MARK: - 日付フォーマット
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy年M月d日"
        return formatter.string(from: date)
    }
}

//struct ActivityListView: View {
//    let selectedDate: Date
//    let activities: [Activity]
//    private let calendar = Calendar.current
//    
//    var filteredActivities: [Activity] {
//        activities.filter { calendar.isDate($0.date, inSameDayAs: selectedDate) }
//    }
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            Text(formattedDate(selectedDate))
//                .font(.headline)
//                .padding(.bottom, 4)
//            
//            if filteredActivities.isEmpty {
//                Text("この日の作業はありません")
//                    .foregroundColor(.gray)
//                    .font(.subheadline)
//                    .padding(.vertical, 4)
//            } else {
//                ForEach(filteredActivities, id: \.self) { activity in
//                    HStack {
//                        // 🌱 作物名（作物カラー）
//                        if let crop = activity.crop {
//                            Text(crop.name)
//                                .font(.body.bold())
//                                .foregroundColor(crop.displayColor) // 作物カラーで表示
//                                .lineLimit(1)
//                        } else {
//                            Text("作物未設定")
//                                .font(.body.bold())
//                                .foregroundColor(.gray)
//                        }
//                        
//                        Spacer()
//                        
//                        Text(activity.activity.activityName)
//                            .font(.body)
//                            .foregroundColor(.primary)
//                        
//                    }
//                    .padding(.vertical, 4)
//                    .padding(.horizontal, 8)
//                    .background(Color(.systemGray6))
//                    .cornerRadius(8)
//                }
//            }
//        }
//    }
//    private func formattedDate(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.locale = Locale(identifier: "ja_JP")
//        formatter.dateFormat = "MM月d日"
//        return formatter.string(from: date)
//    }
//}

//==================================================//
//  MARK: - Preview
//==================================================//
#Preview {
    let container = try! ModelContainer(
        for: Crop.self, Activity.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let context = container.mainContext
    
    let sampleCrop = Crop(orderIndex: 0, name: "トマト", icon: .tomato, color: .red)
    let sampleActivity1 = Activity(date: Date(), activity: .watering, quantity: 3)
    let sampleActivity2 = Activity(date: Date().addingTimeInterval(-86400 * 2), activity: .watering, quantity: nil)
    sampleCrop.activities = [sampleActivity1, sampleActivity2]
    
    context.insert(sampleCrop)
    context.insert(sampleActivity1)
    context.insert(sampleActivity2)
    
    return CalendarView()
        .modelContainer(container)
}


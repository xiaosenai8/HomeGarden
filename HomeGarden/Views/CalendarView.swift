//
//  CalendarView.swift
//  HomeGarden
//
//  Created by konishi on 2025/11/09
//

import SwiftUI
import _SwiftData_SwiftUI

//==================================================//
// MARK: - CalendarView（メイン画面）
//==================================================//
struct CalendarView: View {
    
    // SwiftData のコンテキスト
    @Environment(\.modelContext) private var modelContext
    
    // 作物一覧（並び順どおり）
    @Query(sort: [SortDescriptor(\Crop.orderIndex, order: .forward)])
    private var crops: [Crop]
    
    // すべての Activity（最新が上）
    @Query(sort: [SortDescriptor(\Activity.date, order: .reverse)])
    private var activities: [Activity]
    
    // 選択中の日付
    @State private var selectedDate = Date()
    
    var body: some View {
        VStack(spacing: 0) {
            
            //--------------------------------------------------
            // 📅 カレンダー上部（年月・前後移動・グリッド）
            //--------------------------------------------------
            VStack(spacing: 16) {
                CalendarHeaderView(selectedDate: $selectedDate)
                CalendarGridView(selectedDate: $selectedDate, activities: activities)
            }
            .padding()
            .background(Color(.systemBackground))
            .shadow(radius: 1)
            
            Divider()
            
            //--------------------------------------------------
            // 📝 選択した日の Activity 一覧
            //--------------------------------------------------
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
// MARK: - CalendarHeaderView（月移動ヘッダー）
//==================================================//
struct CalendarHeaderView: View {
    
    @Binding var selectedDate: Date
    
    /// "2025年11月" のように表示するフォーマッタ
    private var monthFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy年M月"
        return formatter
    }
    
    var body: some View {
        HStack {
            
            //--------------------------------------------------
            // ◀︎ 前の月へ
            //--------------------------------------------------
            Button { changeMonth(by: -1) } label: {
                Image(systemName: "chevron.left").font(.title3)
            }
            
            Spacer()
            
            //--------------------------------------------------
            // 現在の年月表示
            //--------------------------------------------------
            Text(monthFormatter.string(from: selectedDate))
                .font(.title3.bold())
            
            Spacer()
            
            //--------------------------------------------------
            // ▶︎ 次の月へ
            //--------------------------------------------------
            Button { changeMonth(by: 1) } label: {
                Image(systemName: "chevron.right").font(.title3)
            }
        }
    }
    
    /// 月を前後に移動
    func changeMonth(by value: Int) {
        if let newDate = Calendar.current.date(byAdding: .month, value: value, to: selectedDate) {
            selectedDate = newDate
        }
    }
}

//==================================================//
// MARK: - CalendarGridView（日付グリッド）
//==================================================//
struct CalendarGridView: View {
    
    @Binding var selectedDate: Date
    var activities: [Activity]
    
    private let calendar = Calendar.current
    
    var body: some View {
        VStack(spacing: 8) {
            
            //--------------------------------------------------
            // 曜日ヘッダー（日 → 土）
            //--------------------------------------------------
            HStack {
                ForEach(["日","月","火","水","木","金","土"], id: \.self) { day in
                    Text(day)
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                    // 日曜日=赤、土曜日=青
                        .foregroundColor(
                            day == "日" ? .red :
                                day == "土" ? .blue :
                                    .primary
                        )
                }
            }
            
            //--------------------------------------------------
            // 当月の日付を 7×n グリッドで表示
            //--------------------------------------------------
            let days = makeDays(for: selectedDate)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7),
                      spacing: 10) {
                
                ForEach(days, id: \.self) { date in
                    
                    if date != Date.distantPast {
                        VStack(spacing: 4) {
                            
                            //--------------------------------------------------
                            // 日付（選択日なら黒背景の丸）
                            //--------------------------------------------------
                            Text("\(calendar.component(.day, from: date))")
                                .frame(maxWidth: .infinity)
                                .padding(6)
                                .background(
                                    Circle()
                                        .fill(
                                            calendar.isDate(date, inSameDayAs: selectedDate)
                                            ? Color.black
                                            : .clear
                                        )
                                )
                                .foregroundColor(
                                    calendar.isDate(date, inSameDayAs: selectedDate)
                                    ? .white
                                    : .primary
                                )
                                .onTapGesture { selectedDate = date }
                            
                            
                            //--------------------------------------------------
                            // ● 作物カラーのドット
                            //   - アーカイブ除外
                            //   - 削除済み除外
                            //   - modelContext nil除外（invalid）
                            //--------------------------------------------------
                            HStack(spacing: 3) {
                                ForEach(cropColorsForDate(date), id: \.self) { color in
                                    Circle()
                                        .fill(color)
                                        .frame(width: 6, height: 6)
                                }
                            }
                            
                        }
                        .frame(height: 50)
                        
                    } else {
                        // 空白マス（前月分のプレースホルダ）
                        Color.clear.frame(height: 32)
                    }
                }
            }
        }
    }
    
    
    //==================================================//
    // MARK: - 指定月の日付一覧を生成
    //==================================================//
    func makeDays(for date: Date) -> [Date] {
        
        // 月の日数範囲
        guard let range = calendar.range(of: .day, in: .month, for: date),
              let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: date))
        else { return [] }
        
        var days: [Date] = []
        
        // 1日目が何曜日か → その前を空白で埋める
        let firstWeekday = calendar.component(.weekday, from: firstDay)
        for _ in 1..<firstWeekday {
            days.append(.distantPast)   // 空白セル
        }
        
        // 当月の日付を追加
        for day in range {
            if let d = calendar.date(byAdding: .day, value: day - 1, to: firstDay) {
                days.append(d)
            }
        }
        return days
    }
    
    
    //==================================================//
    // MARK: - 指定日の Crop 色一覧（安全版）
    //==================================================//
    func cropColorsForDate(_ date: Date) -> [Color] {
        
        // 指定日の Activity のみ抽出
        let dayActivities = activities.filter {
            calendar.isDate($0.date, inSameDayAs: date)
        }
        
        var validColors: [Color] = []
        
        for activity in dayActivities {
            
            // --- invalid Activity（modelContext=nil）防止 ---
            if activity.modelContext == nil { continue }
            
            // --- Crop が nil（孤立 Activity）を除外 ---
            guard let crop = activity.crop else { continue }
            
            // --- invalid Crop（削除済み）防止 ---
            if crop.modelContext == nil { continue }
            
            // --- SwiftData の isDeleted 判定 ---
            if crop.isDeleted { continue }
            
            // --- アーカイブ作物は表示しない ---
            if crop.isArchived { continue }
            
            // 完全に安全な Crop だけ反映
            validColors.append(crop.displayColor)
        }
        
        // 重複削除し、最大3色に制限
        return Array(Set(validColors)).prefix(3).map { $0 }
    }
}

//==================================================//
// MARK: - ActivityListView（右側リスト）
//==================================================//
struct ActivityListView: View {
    
    let selectedDate: Date
    let activities: [Activity]
    
    private let calendar = Calendar.current
    
    // 選択日の Activity で、かつ valid な Crop のものだけ表示
    var filteredActivities: [Activity] {
        activities.filter { activity in
            
            // --- 日付一致 ---
            guard calendar.isDate(activity.date, inSameDayAs: selectedDate) else { return false }
            
            // --- Crop が nil の Activity は非表示 ---
            guard let crop = activity.crop else { return false }
            
            // --- invalid Crop ---
            if crop.modelContext == nil { return false }
            
            // --- 削除済み ---
            if crop.isDeleted { return false }
            
            // --- アーカイブ済み ---
            if crop.isArchived { return false }
            
            return true
        }
    }
    
    //==================================================//
    // MARK: - 作物ごとに Activity をグループ化
    //==================================================//
    /// - Note:
    ///   Crop? をキーにしてグループ化。
    ///   Crop=nil の場合は作物未設定として扱われる。
    var groupedByCrop: [(crop: Crop?, activities: [Activity])] {
        Dictionary(grouping: filteredActivities, by: { $0.crop })
            .sorted { ($0.key?.name ?? "") < ($1.key?.name ?? "") }
            .map { (crop: $0.key, activities: $0.value) }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            //--------------------------------------------------
            // 日付ラベル
            //--------------------------------------------------
            Text(formattedDate(selectedDate))
                .font(.headline)
                .padding(.bottom, 4)
            
            //--------------------------------------------------
            // Activity がない場合の表示
            //--------------------------------------------------
            if filteredActivities.isEmpty {
                HStack {
                    Text("この日の作業はありません")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                        .padding(.vertical, 10)
                    Spacer()
                }
                
            } else {
                
                //--------------------------------------------------
                // 作物ごとにセクション表示
                //--------------------------------------------------
                ForEach(groupedByCrop, id: \.crop?.id) { group in
                    VStack(alignment: .leading, spacing: 8) {
                        
                        // 作物名ヘッダー
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
                        
                        // 作業一覧
                        ForEach(group.activities, id: \.self) { activity in
                            HStack {
                                Text(activity.activity.activityName)
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
    
    // "2025年11月10日" 形式に整形
    private func formattedDate(_ date: Date) -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ja_JP")
        f.dateFormat = "yyyy年M月d日"
        return f.string(from: date)
    }
}




//==================================================//
// MARK: - Preview
//==================================================//
#Preview {
    CalendarView()
        .modelContainer(PreviewData.calendarSample)
}


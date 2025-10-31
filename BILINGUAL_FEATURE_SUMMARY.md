# QAQ Flutter 雙語課程功能實現總結

## 📋 實現概述
成功實現了類似 TAT 的雙語課程顯示功能，讓 QAQ Flutter 能夠同時抓取中英文課程資料，並根據用戶的語言設定動態顯示對應語言的課程名稱。

## ✅ 已完成的修改

### 1. 核心基礎設施
- ✅ **語言工具類** (`lib/src/utils/language_utils.dart`)
  - 提供獲取當前語言代碼的方法
  - 支持從 Context 或 ThemeSettingsService 獲取語言設定

- ✅ **課程數據助手** (`lib/src/helpers/course_data_helper.dart`)
  - 提供課程名稱本地化方法
  - 處理中英文課程數據的合併邏輯
  - 支持按課號匹配中英文課程

### 2. 數據模型更新
- ✅ **Course 模型** (`lib/src/models/course.dart`)
  - 新增 `courseNameZh` 和 `courseNameEn` 欄位
  - 添加 `getLocalizedName(languageCode)` 方法

- ✅ **Grade 模型** (`lib/src/models/grade.dart`)
  - 新增 `courseNameZh` 和 `courseNameEn` 欄位
  - 添加 `getLocalizedName(languageCode)` 方法

- ✅ **CourseCreditInfo 模型** (`lib/src/models/course_credit_models.dart`)
  - 添加 `getLocalizedName(languageCode)` 方法
  - 已有 `nameZh` 和 `nameEn` 欄位

### 3. 服務層修改
- ✅ **課程服務** (`lib/src/services/ntut/ntut_course_service.dart`)
  - 修改 `getCourseTable` 方法同時請求中英文課表
  - 添加 `_parseCourseTableHtml` 的語言參數
  - 實現 `_mergeCoursesByLanguage` 合併中英文數據

- ✅ **成績服務** (`lib/src/services/ntut/ntut_grade_service.dart`)
  - 修改 `getGrades` 方法同時請求中英文成績
  - 添加 `_parseGradesFromHtml` 方法支持中英文
  - 實現 `_mergeGradesByLanguage` 合併中英文數據

### 4. UI 組件更新
- ✅ **課表組件** (`lib/src/widgets/weekly_course_table_tat.dart`)
  - 使用 `CourseDataHelper.getLocalizedCourseName` 顯示課程名稱
  - 支持顏色選擇器中的本地化顯示

- ✅ **成績組件** (`lib/src/widgets/grade_item_widget.dart`)
  - 使用 `CourseDataHelper.getGradeLocalizedName` 顯示成績課程名稱

- ✅ **學分頁面** (`lib/src/pages/credits_page.dart`)
  - 使用 `course.getLocalizedName(languageCode)` 顯示課程名稱
  - 支持課程列表、博雅課程、外系課程的本地化顯示

## 🔧 實現細節

### 數據流程
1. **抓取階段**：
   ```
   getCourseTable/getGrades
   ├─ 並發請求中文和英文 API
   ├─ 分別解析中英文 HTML
   └─ 按課號匹配並合併數據
   ```

2. **顯示階段**：
   ```
   UI 組件
   ├─ 獲取當前語言設定
   ├─ 調用 getLocalizedName(languageCode)
   └─ 優先顯示目標語言，回退到中文
   ```

### API 端點
- 中文課表：`/course/tw/Select.jsp`
- 英文課表：`/course/en/Select.jsp`
- 中文成績：`/StuQuery/QryScore.jsp`
- 英文成績：`/StuQuery/QryScoreEng.jsp`

### 數據結構
```dart
{
  'courseId': '7305086',
  'courseName': '資料結構',  // 顯示用（根據語言設定）
  'courseNameZh': '資料結構', // 中文名稱
  'courseNameEn': 'Data Structures', // 英文名稱
  // ... 其他欄位
}
```

## 🎯 核心特點

1. **參考 TAT 實現**：完全按照 TAT 的雙語實現邏輯
2. **向後兼容**：即使英文數據缺失也能正常顯示中文
3. **高效抓取**：使用 `Future.wait` 並發請求中英文 API
4. **智能匹配**：基於課號 (courseId) 精確匹配中英文課程
5. **動態切換**：根據用戶語言設定實時切換顯示語言

## 📱 影響的功能模組

1. ✅ 課表頁面 - 顯示中英文課程名稱
2. ✅ 成績頁面 - 顯示中英文課程名稱
3. ✅ 學分計算頁面 - 顯示中英文課程名稱
4. ✅ i學園相關頁面 - 已自動支持（使用相同的模型）

## 🧪 測試建議

1. **切換語言測試**：
   - 在設定中切換語言（繁體中文 / English）
   - 檢查課表、成績、學分頁面是否正確顯示對應語言

2. **數據完整性測試**：
   - 檢查是否所有課程都有中英文名稱
   - 確認課號匹配的準確性

3. **回退機制測試**：
   - 模擬英文 API 失敗的情況
   - 確保仍能顯示中文課程資料

## 📝 注意事項

1. **API 可用性**：英文 API 端點需要 NTUT 系統支持
2. **數據一致性**：中英文課程應該通過相同的課號匹配
3. **錯誤處理**：使用 `eagerError: false` 確保部分失敗不影響整體

## 🚀 後續優化建議

1. 考慮緩存英文課程名稱以減少重複請求
2. 添加手動刷新英文數據的功能
3. 在設定頁面提供「更新英文課程名稱」的選項
4. 記錄哪些課程缺少英文名稱，方便後續補充

---

**實現完成日期**：2025-10-31
**參考專案**：TAT Flutter
**主要修改文件數**：12+

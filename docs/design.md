# 食时设计与交互规范（实施版）

## 1. 视觉方向
- 品牌主色：深紫灰背景 + 暖金强调（登录页已体现）。
- 视觉关键词：温暖、信任、稳重、可访问。
- 设计目标：信息密度高但不压迫，重点信息通过层级与动效引导。

## 2. 组件层级（Flutter）
- 页面层：`Scaffold` / `NestedScrollView` / `CustomScrollView`
- 模块层：Header、筛选器、卡片列表、底部操作区、投票区
- 原子层：Button、Input、Tag、IconButton、Sheet、Toast、Dialog

建议目录：
- `lib/features/auth/`
- `lib/features/discovery/`
- `lib/features/vote/`
- `lib/features/property/`
- `lib/shared/ui/`
- `lib/shared/motion/`

## 3. 动效总规范（必须执行）
目标：所有交互“丝滑、有反馈、不打断”。

### 3.1 时长与曲线
- 快速反馈（点击态/图标）：120ms，`easeOut`
- 常规切换（Tab/筛选/卡片状态）：200-260ms，`easeOutCubic`
- 页面转场：280-360ms，`fastOutSlowIn`
- 大面板（BottomSheet/Drawer）：320-420ms，弹簧阻尼（`SpringSimulation`）

### 3.2 统一动效 token（建议）
- `MotionDuration.fast = 120ms`
- `MotionDuration.normal = 240ms`
- `MotionDuration.slow = 360ms`
- `MotionCurve.standard = Curves.easeOutCubic`
- `MotionCurve.emphasized = Curves.fastOutSlowIn`

## 4. 关键交互动画清单
- 登录页：
  - Logo 与标题入场：上移 + 淡入（Stagger）
  - 输入框聚焦：描边与阴影平滑过渡
  - 登录按钮点击：轻微缩放（0.98 -> 1.0）+ loading morph
  - 第三方登录按钮：涟漪 + 状态过渡
- 首页/寻店：
  - 筛选条件切换：Chip 背景与文字颜色补间
  - 列表刷新：骨架屏淡出到实体内容
  - 列表/地图切换：Shared Axis（X 或 Z）
- 详情页：
  - Hero 动画（封面图/店铺图）
  - 指标图表：数值与柱状图渐进增长（避免突变）
  - “立即前往”等 CTA：按下回弹 + 阴影变化
- 组队投票页：
  - 票数进度条：平滑插值更新（200-300ms）
  - 新消息/新候选项：从底部滑入 + 淡入
  - 发送态：按钮 morph 为发送中，再恢复
- B 端工单流：
  - 状态时间线：节点激活顺序动画
  - 图文上传区：占位到缩略图渐变
  - 统计卡片：数字滚动（odometer 风格）

## 5. 丝滑体验硬指标
- 页面首屏可交互时间：< 1.8s（中端 Android）
- 路由切换帧率：目标 60fps，低端机不低于 50fps
- 长列表滚动：无明显掉帧；首批渲染控制在 10-14 项
- 图片策略：缩略图优先、渐进加载、错误兜底

## 6. 可访问性与适老化
- 触控区域最小 44x44
- 文字对比度满足 WCAG AA
- 关键文本支持字体放大（系统字体系数）
- 动效可降级：跟随系统“减少动态效果”设置

## 7. 多端一致性（B 端）
- 同一任务流在手机/平板/桌面保留一致的信息顺序。
- 差异化只放在布局层（栅格与侧栏），不改业务语义。
- 交互反馈节奏一致，避免“端间手感割裂”。

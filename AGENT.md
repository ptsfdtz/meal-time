# AGENT.md - 食时项目技术设计与管理总纲

## 1. 项目目标
- 基于现有 Figma 设计稿落地“食时”多端产品（C 端 + 物业 B 端）。
- 以“可用 + 可维护 + 丝滑动效”为首要目标，先打通核心任务链路。

## 2. 版本范围（V1）
- C 端：登录、首页、寻店结果（列表/地图）、商场详情、店铺详情、Plan B、组队投票。
- B 端：首页、工单、数据统计、巡检、工单详情、个人。
- 非业务展示页（设计规范/竞品分析）不纳入开发范围。

## 3. 技术栈与工程约束
- 框架：Flutter（Dart）
- 状态管理：建议 `Riverpod`（或 `Bloc`，二选一后全局统一）
- 路由：`go_router`
- 网络：`dio` + 拦截器 + 统一错误模型
- 本地缓存：`shared_preferences`（轻量）+ 可扩展 `isar/hive`
- 图片：`cached_network_image`
- 图表：按设计选择（如 `fl_chart`）

统一约束：
- 全项目强制 `flutter analyze` 无告警。
- 禁止业务层直接操作 UI 细节；动效通过共享层统一封装。
- 所有页面必须具备 loading/empty/error 三态。

## 4. 架构分层
- `presentation`：页面、组件、动画控制
- `application`：用例编排、流程状态
- `domain`：实体、仓储接口、业务规则
- `infrastructure`：API、DTO、本地持久化

目录建议：
- `lib/features/<feature>/presentation`
- `lib/features/<feature>/application`
- `lib/features/<feature>/domain`
- `lib/features/<feature>/infrastructure`
- `lib/shared/{ui,motion,theme,network,utils}`

## 5. 动效与交互标准（强制）
- 任何可点击元素必须有视觉反馈（按压/hover/focus）。
- 任何状态变化必须有过渡动画（不允许突变闪烁）。
- 页面切换必须使用统一转场策略（禁用默认突兀切换）。
- 长耗时操作必须显示进度反馈（按钮 loading、骨架屏、局部 shimmer）。

推荐默认值：
- 快反馈：120ms
- 常规：240ms
- 转场：320ms
- 曲线：`easeOutCubic / fastOutSlowIn`

## 6. 数据与接口策略
- API 契约先行：页面开发前冻结字段与错误码。
- DTO -> Domain 显式映射，禁止在 UI 直接消费原始 JSON。
- 关键链路支持离线兜底（至少缓存最近一次可用数据）。

## 7. 质量保障
- 静态检查：`flutter analyze`
- 单元测试：核心业务用例与状态机
- Widget 测试：登录、筛选、投票、工单流
- Golden 测试：关键页面视觉回归
- 性能检查：主流程页切换与滚动帧率

发布门禁（必须全部满足）：
- P0 页面全链路可达
- 关键测试通过
- 无 P0/P1 级缺陷
- 动效与性能达标

## 8. 任务管理机制
- 需求拆分粒度：以“可独立验收页面/流程”为单位。
- 优先级：P0（链路）-> P1（多端/体验）-> P2（增强）。
- 每个任务需包含：
  - 目标页面/模块
  - 交互与动效要求
  - 数据依赖
  - 验收标准

节奏建议：
- 每日：开发进展 + 风险同步
- 每周：里程碑演示（真实可点击流程）

## 9. 风险清单与对策
- 设计变更频繁：建立 token 与组件化降低返工。
- 多端适配复杂：先统一信息架构，再做布局差异。
- 动效性能风险：优先隐式动画，复杂动效按低端机降级。
- 接口波动：Mock 层与真实 API 可切换。

## 10. 当前结论（本轮分析）
- 已识别核心业务界面 14 个（C 端 8 + B 端 6）。
- 已输出文档：
  - `docs/pages.md`
  - `docs/design.md`
  - `docs/todo.md`
- 后续开发与评审均以该总纲为基线执行。

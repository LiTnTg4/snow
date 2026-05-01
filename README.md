# Roblox Universal UI

一个模块化的 Roblox 通用 UI 脚本框架，集成多种实用功能。

## 功能

- **无头** - 隐藏角色头部和脸部
- **断腿** - R6/R15 角色断腿效果
- **画质简化** - 降低画质提升性能
- **隐藏饰品** - 按类型独立控制8种饰品可见性
- **灵敏度调节** - 触摸灵敏度 0.1-10倍可调
- **FFlag工具** - JSON粘贴、保存、加载、应用
- **FPS监控** - 实时显示FPS和PING
- **记忆功能** - 面板尺寸和位置自动保存
- **Toast提示** - 操作反馈通知

## 使用方法

1. 将所有文件放入 Roblox 脚本执行器中
2. 运行 `src/Main.lua`
3. 点击屏幕上的 FPS 显示器打开控制面板
4. 拖动 FPS 显示器和面板标题栏移动位置

## 模块结构

| 模块 | 说明 |
|------|------|
| `Config.lua` | 颜色、默认值配置 |
| `Core/Sensitivity.lua` | 灵敏度核心 |
| `Core/Headless.lua` | 无头效果 |
| `Core/BrokenLegs.lua` | 断腿效果 |
| `Core/Graphics.lua` | 画质简化 |
| `Core/Accessories.lua` | 饰品隐藏 |
| `UI/Toast.lua` | Toast提示 |
| `UI/PerfButton.lua` | FPS显示按钮 |
| `UI/UI.lua` | 主面板框架 |
| `FF/FFlagTool.lua` | FFlag工具 |

## 许可证

MIT
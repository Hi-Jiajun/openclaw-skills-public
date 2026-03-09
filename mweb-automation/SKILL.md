---
name: mweb-automation
description: |
  MWeb小组自动化部署完整流程：获取任务 → 下载 → 发布 → 做种。
  使用场景：(1) 开始每日的MWeb任务处理 (2) 自动化执行完整工作流
---

# MWeb自动化部署

MWeb小组视频自动化处理完整流程。

## 流程概述

1. **获取任务** → 使用 mweb-get-task
2. **下载视频** → 使用 mweb-download  
3. **发布站点** → 使用 mweb-publish
4. **做种出种** → 使用 mweb-seed

## 快速开始

```
运行每日自动化任务
```

## 子Skill调用

根据任务需要，依次调用：

1. **mweb-get-task** - 获取今日任务列表
2. **mweb-download** - 逐个下载视频
3. **mweb-publish** - 发布到站点
4. **mweb-seed** - 做种管理

## 任务记录

每次任务保存到 `{USER_PATH}\Documents\mttools\MWebCache\`

文件名格式：`YYYY-MM-DD-任务名.md`

内容包含：
- 执行日期
- 任务内容
- 执行步骤
- 遇到的问题
- 处理结果

保留30天

## 遇到问题

- Cookie过期：汇报用户手动更新
- 下载失败：记录错误，继续下一个任务
- 发布失败：检查错误，汇报用户
- 做种问题：记录并汇报用户


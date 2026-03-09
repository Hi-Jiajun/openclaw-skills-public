---
name: mweb-get-task
description: |
  从Telegram MBot获取MWeb今日任务。需要提供cookie后自动从MBot获取任务列表。
  使用场景：(1) 获取今日MWeb下载任务 (2) 查看待处理的视频列表
---

# MWeb获取任务

从Telegram MBot (@MToffBot) 获取今日MWeb小组任务。

## 前提条件

1. Telegram已配置并登录
2. Chrome浏览器已安装OpenClaw Browser Relay扩展

## 执行步骤

1. 打开Chrome，访问 https://web.telegram.org
2. 找到MBot聊天窗口，点击进入
3. 读取任务消息，解析以下信息：
   - 平台 (iQIYI/TX)
   - 视频名称
   - 豆瓣ID
   - TMDB/IMDB ID
   - 发布时间

## 输出格式

返回任务列表，包含：
- 平台
- 视频名称
- 豆瓣ID
- TMDB ID
- 视频链接（如果MBot提供）

## 常见问题

- 如果Chrome未登录Telegram，让用户先登录
- 如果找不到MBot，搜索 "MToffBot"

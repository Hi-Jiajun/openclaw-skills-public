---
name: mweb-download
description: |
  使用Scissors工具下载iQIYI/腾讯视频。需要cookie配置完成后使用。
  使用场景：(1) 下载MWeb任务中的视频 (2) 根据TMDB/豆瓣信息下载对应视频
---

# MWeb视频下载

使用Scissors工具从iQIYI或腾讯视频下载内容。

## 工具路径

- Scissors: `{USER_PATH}\Documents\mttools\Scissors_v1.3.3_20260302\Scissors.exe`
- Cookies: `{USER_PATH}\Documents\mttools\Scissors_v1.3.3_20260302\Cookies\`
- 下载目录: `{USER_PATH}\Documents\mttools\ScissorsDownloads`
- 日志目录: `{USER_PATH}\Documents\mttools\logs\mweb-download`

## Cookie配置

首次使用需配置：
- iQIYI: `Cookies\iQIYI.txt`
- TX: `Cookies\TX_RAW.txt` (需用netspace2header.py转换)

## 命令格式（正确版）

### iQIYI下载
```cmd
# 先用 --list 查看可用画质
Scissors.exe dl -q {画质} -r {HDR} --list iQIYI {视频链接}

# 电视剧/综艺/动画
Scissors.exe dl -q {画质} -r {HDR} -f --tmdb {TMDB_ID} --douban {豆瓣_ID} iQIYI {视频链接}

# 电影（不需要 -w）
Scissors.exe dl -q {画质} -r {HDR} -f --tmdb {TMDB_ID} --douban {豆瓣_ID} iQIYI {视频链接}

# 指定集数下载（如 -w S01E07-S01E08）
Scissors.exe dl -q {画质} -r {HDR} -f -w S01E07-S01E08 --tmdb {TMDB_ID} --douban {豆瓣_ID} iQIYI {视频链接}
```

### TX下载
```cmd
# 电视剧/综艺/动画
Scissors.exe dl -q {画质} -r HDR10 -f --tmdb {TMDB_ID} --douban {豆瓣_ID} TX -s {季数} -v {视频链接}

# 电影
Scissors.exe dl -q {画质} -r HDR10 -f --tmdb {TMDB_ID} --douban {豆瓣_ID} TX -m {视频链接}
```

## 参数说明

### 通用参数
| 参数 | 说明 | 示例 |
|------|------|------|
| -q | 画质 | 2160p, 1080p, 720p |
| -r | HDR选项 | SDR, HDR10, DV |
| -f | 显示下载路径 | -f |
| --tmdb | TMDB ID | --tmdb 848880 |
| --douban | 豆瓣 ID | --douban 38197624 |
| -w | 集数范围 | S01, S01E07-S01E08 |

### iQIYI 专属参数
| 参数 | 说明 |
|------|------|
| (无) | 平台参数放在最后 |

### TX 专属参数（放在平台后面）
| 参数 | 说明 |
|------|------|
| -s | 季数修正（默认1） |
| -v | 获取非正片（花絮等） |
| -m | 电影模式 |

## 画质要求

### iQIYI
| 类型 | 画质要求 |
|------|----------|
| 电影/纪录片 | 1080p, 4k(2160p), 4k HFR, HDR10, DV |
| 连续剧 | 1080p, 4k(2160p), 4k HFR, HDR10, DV |
| 综艺 | 1080p, 4k(2160p)，需在副标题加当期名称 |
| 动画 | 1080p, 4k(2160p), 4k HFR |

### TX（必须加 -r HDR10 获取4K）
| 类型 | 画质要求 |
|------|----------|
| 电影/纪录片 | 1080p, 4k HDR10 |
| 连续剧 | 1080p, 4k HDR10 |
| 综艺 | 1080p, 4k HDR10（注意跳集问题） |
| 动画 | 1080p, 4k HDR10 |

## 重要注意事项

### 1. 画质参数
- `-q 4k` 无效，必须用 `-q 2160p`
- 先用 `--list` 查看平台提供的实际画质
- 如果没有对应画质会返回 "No suitable manifest found"

### 2. TMDB/Douban 查询失败
- 如果 TMDB API 查询失败（404），会导致命名错误
- **处理方式**：立即汇报用户，等待用户指令后再继续
- 常见错误：`Got an error when requesting tmdb api -> 404 Client Error`

### 3. 跳集问题（TX）
- TX 平台可能出现跳集（缺少某些集数）
- **处理方式**：记录并汇报用户，等待用户确认

### 4. 中配/原配同时下载
- 默认目录：`ScissorsDownloads`
- 中配目录：`ScissorsDownloads1`（先下载中配移到该目录，再下载原配）

### 5. Cookie 过期
- 错误提示含 "program" → Cookie 过期
- 需要更新对应平台的 Cookie

## 日志记录

每次下载完成后自动记录日志：

**日志目录结构：**
```
{USER_PATH}\Documents\mttools\logs\mweb-download\
├── 电视剧\
│   └── {剧集名}\
│       ├── {日期}-{任务名}-readable.md
│       └── {日期}-{任务名}-detailed.md
├── 电影\
├── 综艺\
├── 动画\
└── 其他\
```

**日志内容：**
- readable: 人类可读的简要记录
- detailed: 完整的操作步骤和命令记录

**自动清理：**
- 定时任务每天检查，删除 30 天前的日志

## 工作流程

1. **解析任务**：从 MBot 消息提取平台、链接、ID
2. **判断类型**：电视剧/电影/综艺/动画
3. **查看画质**：用 `--list` 查看可用画质
4. **选择画质**：根据类型选择对应画质参数
5. **执行下载**：运行下载命令
6. **检查结果**：
   - 如果 TMDB 查询失败 → 汇报用户
   - 如果跳集问题 → 汇报用户
   - 如果画质不符要求 → 汇报用户
7. **重命名**：根据用户指令重命名
8. **记录日志**：保存到对应分类目录


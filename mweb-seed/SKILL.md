---
name: mweb-seed
description: |
  使用qBittorrent进行做种和出种操作。
  使用场景：(1) 发布完成后做种 (2) 监控出种并清理文件
---

# MWeb做种出种

使用qBittorrent进行做种和出种管理。

## 目录配置

- 原配: `{USER_PATH}\Downloads\qb\mweb`
- 中配/同名文件: `{USER_PATH}\Downloads\qb\mweb1`

## qBittorrent Web UI

- 地址: http://localhost:8080
- 用户名: (config中配置)
- 密码: (config中配置)

## 做种步骤

### 1. 添加种子
- 从站点下载种子文件
- 或通过Web UI添加种子URL

### 2. 设置分类和标签
| 文件夹 | 分类 | 标签 | 目录 |
|--------|------|------|------|
| mweb | MWeb | MWeb | {USER_PATH}\Downloads\qb\mweb |
| mweb1 | MWeb中配及其他 | MWeb | {USER_PATH}\Downloads\qb\mweb1 |

### 3. 可选：跳过校验
加速添加种子，可跳过文件校验

## 出种后清理

出种后15~60分钟（视种子热门程度）删除：
1. 种子文件
2. 做种文件夹中的文件
3. ScissorsDownloads中的对应文件

放入回收站（方便复原）

## 检查做种状态

定期检查：
- 做种数量
- 上传速度
- 种子健康度


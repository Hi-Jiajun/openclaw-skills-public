---
name: mweb-publish
description: |
  使用AutoPublisher将下载的视频发布到M-Team站点。
  使用场景：(1) 视频下载完成后发布到站点 (2) 管理发布缓存和重试
---

# MWeb视频发布

使用AutoPublisher工具将下载的视频发布到M-Team PT站点。

## 工具路径

- AutoPublisher: `{USER_PATH}\Documents\mttools\AutoPublisher_v2.2.4_260125\AutoPublisher.exe`
- 配置: `{USER_PATH}\Documents\mttools\AutoPublisher_v2.2.4_260125\config.toml`
- 缓存: `{USER_PATH}\Documents\mttools\AutoPublisher_v2.2.4_260125\temp\`

## 命令格式

```cmd
cmd /c "chcp 65001 >nul & set PYTHONIOENCODING=utf-8 & cd /d "{USER_PATH}\Documents\mttools\AutoPublisher_v2.2.4_260125" & AutoPublisher.exe upload -c -d {豆瓣ID} -cid {分类ID} {-nc} "{文件夹路径}""
```

## 参数说明

| 参数 | 说明 | 示例 |
|------|------|------|
| -c | 缓存(默认加) | -c |
| -d | 豆瓣ID | -d 38197624 |
| -cid | 站点分类ID | 见下表 |
| -nc | 未完结标志 | 见下表 |
| 路径 | 文件夹路径 | 见下表 |

### 分类ID (cid)
- 电影: 419
- 动漫: 405
- 纪录片: 404
- 影视剧/综艺: 402

### -nc 选项
- 未完结剧集：加 -nc
- 电影/已完结剧集：不加 -nc

### 路径格式
- 剧集：父文件夹路径（包含季命名）
- 电影：视频文件路径

## 发布后处理

1. 检查站点信息是否正确
2. 中配需勾选"中配"
3. 综艺/纪录片需在副标题添加剧集名称
4. 电影：移动视频文件到工具创建的文件夹

## 缓存处理

如图片上传失败（-c选项）：
1. 检查 `temp\{hash}\` 文件夹
2. 手动上传缺失图片到站点
3. 重新发布


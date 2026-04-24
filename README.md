# Hugging Face Spaces Docker 部署配置
# HF Spaces 会自动读取此文件获取元数据
---
title: A股自选股AI智能分析系统
emoji: 📈
colorFrom: blue
colorTo: green
sdk: docker
app_port: 8000
short_description: 基于NVIDIA AI的A股自选股智能分析系统
pinned: false
license: mit
---

# 📈 A股自选股 AI 智能分析系统

基于 NVIDIA DeepSeek 模型的 A 股自选股智能分析平台。

## 功能特性

- 🤖 **AI 智能分析**：使用 deepseek-v3.2 模型进行深度股票分析
- 📊 **实时行情**：自动获取 A 股实时/历史行情数据
- 📰 **资讯聚合**：聚合财经新闻与公告信息
- 🌐 **Web 界面**：完整的 Web UI 操作界面

## 环境变量

部署前请在 Space Settings > Secrets 中设置：

| 变量名 | 说明 | 必填 |
|--------|------|------|
| `NVIDIA_API_KEY` | NVIDIA API 密钥 | ✅ |

## 本地运行

```bash
docker build -t stock-analysis -f docker/Dockerfile .
docker run -d \
  --name stock-analysis \
  -p 8000:8000 \
  -e NVIDIA_API_KEY=your_key_here \
  -e LLM_CHANNELS=custom_nvidia \
  -e LLM_CUSTOM_NVIDIA_PROTOCOL=openai \
  -e LLM_CUSTOM_NVIDIA_BASE_URL=https://integrate.api.nvidia.com/v1 \
  -e LITELLM_MODEL=openai/deepseek-ai/deepseek-v3.2 \
  stock-analysis \
  python main.py --serve-only --host 0.0.0.0 --port 8000
```

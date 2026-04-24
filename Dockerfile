# ===================================
# Hugging Face Spaces 专用 Dockerfile
# ===================================
# HF Spaces 要求：
#   - Dockerfile 在仓库根目录
#   - 服务需监听 7860 端口（或通过 app_port 指定）
#   - 镜像大小建议 < 10GB

FROM node:20-slim AS web-builder

WORKDIR /app/apps/dsa-web

COPY apps/dsa-web/package.json apps/dsa-web/package-lock.json ./
RUN npm ci

COPY apps/dsa-web/ ./
RUN npm run build

FROM python:3.11-slim-bookworm

WORKDIR /app

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 系统依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc curl wkhtmltopdf fontconfig \
    libjpeg62-turbo libxrender1 libxext6 \
    && rm -rf /var/lib/apt/lists/*

# Python 依赖
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 应用代码
COPY *.py ./
COPY api/ ./api/
COPY data_provider/ ./data_provider/
COPY bot/ ./bot/
COPY patch/ ./patch/
COPY src/ ./src/
COPY strategies/ ./strategies/
COPY --from=web-builder /app/static ./static/

# 数据目录
RUN mkdir -p /app/data /app/logs /app/reports

# 环境变量
ENV PYTHONUNBUFFERED=1
ENV LOG_DIR=/app/logs
ENV DATABASE_PATH=/app/data/stock_analysis.db
ENV WEBUI_HOST=0.0.0.0
ENV API_PORT=7860

EXPOSE 7860

# 启动命令：纯 Web 服务模式（HF Spaces 需要 foreground 运行）
CMD ["python", "main.py", "--serve-only", "--host", "0.0.0.0", "--port", "7860"]

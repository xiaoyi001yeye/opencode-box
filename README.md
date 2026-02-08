# OpenCode Docker 镜像

这个 Dockerfile 用于构建基于 Alpine 的 Docker 镜像，包含 OpenCode、Node.js v24.13.0 和 ohmyopencode。

## 镜像特性

- **基础镜像**: Alpine Linux（最小化镜像体积）
- **Node.js 版本**: v24.13.0（通过 nvm 安装）
- **全局包**: opencode, ohmyopencode
- **用户**: opencode（非 root 用户运行）
- **工作目录**: `/app`

## 构建镜像

```bash
docker build -t opencode-box .
```

## 运行容器

### 基本运行
```bash
docker run -it --rm -v $(pwd):/app opencode-box
```

### 交互式访问
```bash
docker run -it --rm -v $(pwd):/app --entrypoint /bin/bash opencode-box
```

## 验证安装

### 验证 Node.js 版本
```bash
node -v    # 应该输出 v24.13.0
npm -v
```

### 验证 OpenCode
```bash
opencode --version
which opencode
```

### 验证全局包
```bash
npm list -g opencode ohmyopencode
```

## 使用说明

1. 构建镜像后，可以进入容器使用 OpenCode
2. 容器中的工作目录是 `/app`
3. 将本地项目目录挂载到容器中：`-v $(pwd):/app`
4. 容器以非 root 用户 `opencode` 运行

## 进入容器后使用 OpenCode

```bash
opencode
```

## 配置 OpenCode

首次运行 opencode 时，需要配置 LLM 提供商。可以使用环境变量或创建配置文件。

### 环境变量配置
```bash
export OPENCODE_API_KEY="your-api-key"
export OPENCODE_MODEL="gpt-4"
```

### 配置文件
在 `~/.opencode/config.json` 中创建配置文件。

## 已安装的工具

- Node.js v24.13.0
- npm
- git
- curl
- bash
- sudo
- openssh-client
- opencode
- ohmyopencode

## 故障排除

### "npm not found" 错误
确保 Node.js PATH 配置正确，检查 nvm 安装是否成功。

### 权限被拒绝
检查用户创建和 sudoers 配置，验证文件权限。

### 镜像体积过大
- 清理缓存
- 移除不必要的包
- 使用 .dockerignore 文件

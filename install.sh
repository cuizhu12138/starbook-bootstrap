#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/cuizhu12138/starbook-agent-memory.git"
VERSION="v0.3.6"
INSTALL_DIR="${HOME}/.starbook/starbook-agent-memory"
FORWARD_ARGS=()
NEEDS_YES="true"

usage() {
  cat <<'EOF'
StarBook public bootstrap

用法：
  install.sh --project-dir /path/to/project
  install.sh --scope user

选项：
  --repo-url <url>      StarBook private repo；默认 https://github.com/cuizhu12138/starbook-agent-memory.git。
  --version <tag>      StarBook tag；默认 v0.3.6。
  --install-dir <dir>  StarBook clone 目录；默认 ~/.starbook/starbook-agent-memory。
  其它参数会透传给 StarBook 安装器。
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo-url)
      REPO_URL="${2:-}"
      shift 2
      ;;
    --version)
      VERSION="${2:-}"
      FORWARD_ARGS+=("--version" "$VERSION")
      shift 2
      ;;
    --install-dir)
      INSTALL_DIR="${2:-}"
      FORWARD_ARGS+=("--install-dir" "$INSTALL_DIR")
      shift 2
      ;;
    --help|-h)
      NEEDS_YES="false"
      usage
      exit 0
      ;;
    --yes|-y)
      NEEDS_YES="false"
      FORWARD_ARGS+=("$1")
      shift
      ;;
    *)
      FORWARD_ARGS+=("$1")
      shift
      ;;
  esac
done

if [[ -z "$REPO_URL" ]]; then
  echo "--repo-url 不能为空。" >&2
  exit 2
fi

if ! command -v git >/dev/null 2>&1; then
  echo "未找到 git；请先安装 git。" >&2
  exit 1
fi

mkdir -p "$(dirname "$INSTALL_DIR")"
if [[ -d "$INSTALL_DIR/.git" ]]; then
  git -C "$INSTALL_DIR" remote set-url origin "$REPO_URL"
  git -C "$INSTALL_DIR" fetch --tags --prune origin
else
  rm -rf "$INSTALL_DIR"
  git clone "$REPO_URL" "$INSTALL_DIR"
fi

git -C "$INSTALL_DIR" checkout --detach "$VERSION"

if [[ "$NEEDS_YES" == "true" ]]; then
  FORWARD_ARGS+=("--yes")
fi

exec bash "$INSTALL_DIR/scripts/install-codex.sh" "${FORWARD_ARGS[@]}"

#!/usr/bin/env bash
# 谈参生成器 一键安装脚本
# 把技能安装到 ~/.workbuddy/skills/tancan-generator/
set -euo pipefail

SKILL_NAME="tancan-generator"
SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST_DIR="${HOME}/.workbuddy/skills/${SKILL_NAME}"

echo "==> 安装 ${SKILL_NAME} ..."
echo "    来源: ${SRC_DIR}"
echo "    目标: ${DEST_DIR}"

mkdir -p "${HOME}/.workbuddy/skills"

if [ -d "${DEST_DIR}" ]; then
  BACKUP="${DEST_DIR}.bak.$(date +%Y%m%d%H%M%S)"
  echo "    检测到已存在旧版本，备份至: ${BACKUP}"
  mv "${DEST_DIR}" "${BACKUP}"
fi

cp -R "${SRC_DIR}" "${DEST_DIR}"

# 清理可能随包带入的噪音文件
find "${DEST_DIR}" -name ".DS_Store" -delete 2>/dev/null || true
find "${DEST_DIR}" -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true

# 冒烟测试：确认核心文件就位
if [ -f "${DEST_DIR}/SKILL.md" ]; then
  echo "==> 安装成功 ✓"
  echo "    已安装: ${DEST_DIR}"
  echo "    重启 WorkBuddy 后，对话中说「写XX的谈参」即可触发。"
else
  echo "!! 安装异常：未找到 SKILL.md，请检查安装包完整性。" >&2
  exit 1
fi

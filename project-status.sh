#!/bin/bash

# 作業進捗の簡易ステータス確認

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
TMP_DIR="${SCRIPT_DIR}/tmp"

echo "=================================="
echo "Multi-Agent Status"
echo "Time: $(date '+%Y/%m/%d %H:%M:%S')"
echo "=================================="

if [ ! -d "$TMP_DIR" ]; then
    echo ""
    echo "tmpディレクトリが見つかりません: $TMP_DIR"
    exit 1
fi

check_worker() {
    local name="$1"
    local marker="${TMP_DIR}/${name}_done.txt"
    if [ -f "$marker" ]; then
        echo "${name}: DONE"
    else
        echo "${name}: IN PROGRESS"
    fi
}

echo ""
echo "[Team]"
check_worker "worker1"
check_worker "worker2"
check_worker "worker3"

echo ""
echo "[Done Files]"
if ls -1 "${TMP_DIR}/worker"*"_done.txt" >/dev/null 2>&1; then
    ls -1 "${TMP_DIR}/worker"*"_done.txt"
else
    echo "none"
fi

echo ""
echo "=================================="

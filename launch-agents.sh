#!/bin/bash

# AIエージェント一括起動スクリプト

set -e

log_info() {
    echo -e "\033[1;32m[INFO]\033[0m $1"
}

log_success() {
    echo -e "\033[1;34m[SUCCESS]\033[0m $1"
}

log_warning() {
    echo -e "\033[1;33m[WARNING]\033[0m $1"
}

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
AGENT_SEND="${SCRIPT_DIR}/agent-send.sh"

CLAUDE_CMD=${CLAUDE_CMD:-"claude"}
CLAUDE_ARGS=${CLAUDE_ARGS:-""}
FULL_CMD="$CLAUDE_CMD"
if [ -n "$CLAUDE_ARGS" ]; then
    FULL_CMD="$CLAUDE_CMD $CLAUDE_ARGS"
fi

check_sessions() {
    local missing=false

    if ! tmux has-session -t president 2>/dev/null; then
        log_warning "presidentセッションが存在しません"
        missing=true
    fi

    if ! tmux has-session -t multiagent 2>/dev/null; then
        log_warning "multiagentセッションが存在しません"
        missing=true
    fi

    if [ "$missing" = true ]; then
        echo ""
        echo "必要なセッションが見つかりません。先に ./setup.sh を実行してください。"
        exit 1
    fi
}

launch_agent() {
    local name="$1"

    log_info "${name} を起動中..."
    "$AGENT_SEND" "$name" "$FULL_CMD"
}

main() {
    if [ ! -x "$AGENT_SEND" ]; then
        echo "agent-send.sh が見つからないか、実行権限がありません: $AGENT_SEND"
        exit 1
    fi

    check_sessions

    echo "起動コマンド: $FULL_CMD"
    echo "起動対象: PRESIDENT, boss1, worker1, worker2, worker3"
    echo ""

    if [[ "${1:-}" != "-y" && "${1:-}" != "--yes" ]]; then
        read -p "全エージェントを起動しますか? (y/N): " confirm
        if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
            echo "キャンセルしました"
            exit 0
        fi
    fi

    echo ""
    log_info "起動を開始します..."
    echo ""

    launch_agent "president"
    launch_agent "boss1"
    launch_agent "worker1"
    launch_agent "worker2"
    launch_agent "worker3"

    echo ""
    log_success "全エージェントの起動コマンドを送信しました"
}

main "$@"

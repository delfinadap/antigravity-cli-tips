#!/bin/bash

# Color theme: gray, orange, blue, teal, green, lavender, rose, gold, slate, cyan
# Preview colors with: bash scripts/color-preview.sh
COLOR="blue"

# Color codes
C_RESET='\033[0m'
C_GRAY='\033[38;5;245m'  # explicit gray for default text
C_BAR_EMPTY='\033[38;5;238m'
case "$COLOR" in
    orange)   C_ACCENT='\033[38;5;173m' ;;
    blue)     C_ACCENT='\033[38;5;74m' ;;
    teal)     C_ACCENT='\033[38;5;66m' ;;
    green)    C_ACCENT='\033[38;5;71m' ;;
    lavender) C_ACCENT='\033[38;5;139m' ;;
    rose)     C_ACCENT='\033[38;5;132m' ;;
    gold)     C_ACCENT='\033[38;5;136m' ;;
    slate)    C_ACCENT='\033[38;5;60m' ;;
    cyan)     C_ACCENT='\033[38;5;37m' ;;
    *)        C_ACCENT="$C_GRAY" ;;  # gray: all same color
esac

input=$(cat)

# Extract model and directory
model=$(echo "$input" | jq -r '.model.display_name // .model.id // "?"')
cwd=$(echo "$input" | jq -r '.cwd // empty')
dir=$(basename "$cwd" 2>/dev/null || echo "?")

# Get git branch from JSON, fall back to git command
branch=$(echo "$input" | jq -r '.vcs.branch // empty')
if [[ -z "$branch" && -n "$cwd" && -d "$cwd" ]]; then
    branch=$(git -C "$cwd" branch --show-current 2>/dev/null)
fi

git_status=""
if [[ -n "$branch" && -n "$cwd" && -d "$cwd" ]]; then
    # Count uncommitted files
    file_count=$(git -C "$cwd" --no-optional-locks status --porcelain -uall 2>/dev/null | wc -l | tr -d ' ')

    # Check sync status with upstream
    sync_status=""
    upstream=$(git -C "$cwd" rev-parse --abbrev-ref @{upstream} 2>/dev/null)
    if [[ -n "$upstream" ]]; then
        # Get last fetch time
        fetch_head="$cwd/.git/FETCH_HEAD"
        fetch_ago=""
        if [[ -f "$fetch_head" ]]; then
            fetch_time=$(stat -f %m "$fetch_head" 2>/dev/null || stat -c %Y "$fetch_head" 2>/dev/null)
            if [[ -n "$fetch_time" ]]; then
                now=$(date +%s)
                diff=$((now - fetch_time))
                if [[ $diff -lt 60 ]]; then
                    fetch_ago="<1m ago"
                elif [[ $diff -lt 3600 ]]; then
                    fetch_ago="$((diff / 60))m ago"
                elif [[ $diff -lt 86400 ]]; then
                    fetch_ago="$((diff / 3600))h ago"
                else
                    fetch_ago="$((diff / 86400))d ago"
                fi
            fi
        fi

        counts=$(git -C "$cwd" rev-list --left-right --count HEAD...@{upstream} 2>/dev/null)
        ahead=$(echo "$counts" | cut -f1)
        behind=$(echo "$counts" | cut -f2)
        if [[ "$ahead" -eq 0 && "$behind" -eq 0 ]]; then
            if [[ -n "$fetch_ago" ]]; then
                sync_status="synced ${fetch_ago}"
            else
                sync_status="synced"
            fi
        elif [[ "$ahead" -gt 0 && "$behind" -eq 0 ]]; then
            sync_status="${ahead} ahead"
        elif [[ "$ahead" -eq 0 && "$behind" -gt 0 ]]; then
            sync_status="${behind} behind"
        else
            sync_status="${ahead} ahead, ${behind} behind"
        fi
    else
        sync_status="no upstream"
    fi

    # Build git status string
    if [[ "$file_count" -eq 0 ]]; then
        git_status="(0 files uncommitted, ${sync_status})"
    elif [[ "$file_count" -eq 1 ]]; then
        single_file=$(git -C "$cwd" --no-optional-locks status --porcelain -uall 2>/dev/null | head -1 | sed 's/^...//')
        git_status="(${single_file} uncommitted, ${sync_status})"
    else
        git_status="(${file_count} files uncommitted, ${sync_status})"
    fi
fi

# Get context usage from JSON
max_context=$(echo "$input" | jq -r '.context_window.context_window_size // 1048576')
max_k=$((max_context / 1000))
if [[ $max_k -ge 1000 ]]; then
    max_display="$((max_k / 1000))M"
else
    max_display="${max_k}k"
fi

pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
[[ -z "$pct" || "$pct" == "null" ]] && pct=0
[[ $pct -gt 100 ]] && pct=100

bar_width=10
bar=""
for ((i=0; i<bar_width; i++)); do
    bar_start=$((i * 10))
    progress=$((pct - bar_start))
    if [[ $progress -ge 8 ]]; then
        bar+="${C_ACCENT}█${C_RESET}"
    elif [[ $progress -ge 3 ]]; then
        bar+="${C_ACCENT}▄${C_RESET}"
    else
        bar+="${C_BAR_EMPTY}░${C_RESET}"
    fi
done

ctx="${bar} ${C_GRAY}${pct}% of ${max_display} tokens"

# Get terminal width from JSON
term_width=$(echo "$input" | jq -r '.terminal_width // 120')

# Build output: Model | Dir | Branch (status) | Context
output="${C_ACCENT}${model}${C_GRAY} | 📁${dir}"
[[ -n "$branch" ]] && output+=" | 🔀${branch} ${git_status}"
output+=" | ${ctx}${C_RESET}"

# Expand ANSI codes, then wrap at terminal width
expanded=$(printf '%b' "$output")
col=0
in_esc=0
result=""
for (( i=0; i<${#expanded}; i++ )); do
    c="${expanded:i:1}"
    if (( in_esc )); then
        result+="$c"
        [[ "$c" == [a-zA-Z] ]] && in_esc=0
    elif [[ "$c" == $'\033' ]]; then
        result+="$c"
        in_esc=1
    else
        if (( col >= term_width )); then
            result+=$'\n'
            col=0
        fi
        result+="$c"
        (( col++ ))
        # Emojis are 2 columns wide in the terminal
        case "$c" in 📁|🔀|💬) (( col++ )) ;; esac
    fi
done
printf '%s\n' "$result"

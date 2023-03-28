# Haiku (chat-gpt powered) plugin for oh-my-zsh
# ----------------
# Description: This plugin will print a haiku promoting work-life balance and stress management once every 24 hours if your terminal has been open for more than 3 hours.
# Author: Alessandro Resta (alesr)
# URL: https://github.com/alesr/haiku

function haiku_check_duration() {
    local haiku_file=~/.haikuplugin_last_run
    local period=10800 # 3 hours
    local interval=86400 # 24 hours
    local last_run=$(cat $haiku_file 2> /dev/null)

    if [[ -z $last_run ]]; then
        last_run=0
    fi

    local now=$(date +%s)
    local duration=$((now - last_run))
    local is_open_for_more_than_3_hours=$(echo "$duration > $period" | bc)
    local printed_in_last_24_hours=$(echo "$duration < $interval" | bc)

    if [[ $is_open_for_more_than_3_hours -eq 1 && $printed_in_last_24_hours -eq 0 ]]; then
        check_api_key || return 1
        check_curl_or_wget || return 1
        check_jq || return 1

        local haiku=$(get_haiku)

        echo "$haiku"
        echo $now > $haiku_file
    fi
}

function check_api_key() {
  if [[ -z "$OPENAI_API_KEY" ]]; then
    echo "OPENAI_API_KEY environment variable must be set."
    return 1
  fi
  return 0
}

function check_curl_or_wget() {
    if ! command -v curl > /dev/null && ! command -v wget > /dev/null; then
        echo "Either curl or wget is required to make this request."
        return 1
    fi
    return 0
}

function check_jq() {
    if ! command -v jq > /dev/null; then
        echo "jq is not installed. Please install jq to parse the response."
        return 1
    fi
    return 0
}

function get_haiku() {
    local url="https://api.openai.com/v1/completions"
    local model="text-davinci-003"
    local max_tokens=300
    local temperature=0.9
    local prompt="Generate a short, hilarious and sarcastic haiku about the importance of work-life balance and stress management. \
    The poem should have a maximum of three lines and should convey the importance of taking breaks, \
    getting fresh air, and prioritizing self-care, being in touch with friends, meditation, \
    do good things for yourself and others, and things like that."

    local request_payload=$(printf '{"prompt": "%s", "model": "%s", "max_tokens": %d, "temperature": %f}' "$prompt" "$model" "$max_tokens" "$temperature")

    if command -v curl > /dev/null; then
        local response=$(curl -s -X POST \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer $OPENAI_API_KEY" \
            -d "$request_payload" \
            "$url")
    elif command -v wget > /dev/null; then
        local response=$(wget -qO- --header="Content-Type: application/json" \
            --header="Authorization: Bearer YOUR_API_KEY" \
            --post-data="$request_payload" \
            "$url")
    else
        echo "Either curl or wget is required to make this request."
        exit 1
    fi

    local haiku=$(echo "$response" | tr -d '\n' | jq -r '.choices[0].text' | sed -E 's/([A-Z])/\n\1/g' | sed -E 's/^\n//g')
    echo "$haiku"
}

add-zsh-hook precmd haiku_check_duration

#!/usr/bin/env bash

# Settings
GAME_EXEC="BaldursGateII"
TITLE="Baldur's Gate - Enhanced Edition Trilogy"
GAME_DIR="games/eet"
XSETICON_PATH="resources/xseticon"
ICON="resources/icon.png"


# Quit game when script is killed
trap "trap - SIGTERM && kill -SIGKILL -- -\${$}" SIGINT SIGTERM EXIT

# Colorful messages
log_work() { echo -e "\e[34;1m${*}\e[0m" >&2; }
log_info() { echo -e "\e[36;1m${*}\e[0m" >&2; }
log_warn() { echo -e "\e[33m${*}\e[0m" >&2; }
log_err()  { echo -e "\e[31m${*}\e[0m" >&2; }

# Accept relative paths
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" 2>"/dev/null" && pwd)"
cd "${SCRIPT_DIR}" || exit

# Include XSETICON_PATH in PATH
if [ -d "${XSETICON_PATH}" ]; then
    PATH="$(realpath -e "${XSETICON_PATH}")${PATH:+:${PATH}}"
fi

# Preload libmtrandom if present
LIBMTRANDOM="$(find . -iwholename "./resources/libmtrandom-*/libmtrandom.so" | head -n1)"
if [ -n "${LIBMTRANDOM}" ]; then
    log_info "Preloading ${LIBMTRANDOM}."
    LD_PRELOAD="${LD_PRELOAD:+${LD_PRELOAD} }$(realpath -e "${LIBMTRANDOM}")"
    export LD_PRELOAD
else
    log_warn "libmtrandom not found."
fi

# Start the game
if [ ! -d "${GAME_DIR}" ]; then
    log_info "Game not found in $(realpath -em "${GAME_DIR}")."
    exit 1
fi
cd "${GAME_DIR}" || exit
log_work "Starting the game..."
"./${GAME_EXEC}" &
JOB="${!}"
cd "${SCRIPT_DIR}" || exit

# Replace icon if present
if [ -n "$(which "xseticon")" ] && [ -e "${ICON}" ]; then
    log_work "Trying to set icon..."
    WINDOWS=""
    while [ -z "${WINDOWS}" ]; do
        WINDOWS="$(wmctrl -l | tr -s " " | cut -d" " -f"1,4-" | grep "^0x[0-9a-f]* ${TITLE}")"
        sleep "0.1"
        kill -0 "${JOB}" 2>"/dev/null" || break
    done

    WID="$(cut -d" " -f1 <<<"${WINDOWS}" | head -n1)"
    log_info "Window found: ${WID}."

    xseticon -id "${WID}" "${ICON}"
    log_info "Icon set to ${ICON}."
elif [ -z "$(which "xseticon")" ]; then
    log_warn "xseticon not found."
elif [ ! -e "${ICON}" ]; then
    log_warn "Icon not found in $(realpath -em "${ICON}")."
fi

# Wait for the game to quit
wait "${JOB}"
log_info "Game process (${JOB}) ended."

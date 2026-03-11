export PATH="$HOME/.local/bin:$PATH"
. "$HOME/.cargo/env"
. "/home/sk/.deno/env"

if [ -n "$BASH" ] && [ -x "$HOME/.local/bin/mise" ]; then
    case "$-" in
        *i*) ;;
        *) eval "$("$HOME/.local/bin/mise" activate bash)" ;;
    esac
fi

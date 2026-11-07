# Entry-point repository: every component is a submodule, so the gates are
# "are the mounts complete and on the pinned commits" plus the Markdown gate.
set shell := ["bash", "-euo", "pipefail", "-c"]

check: lint-md pins

lint-md:
    markdownlint-cli2 --config .markdownlint-cli2.jsonc

# Fail when a mount is missing (-), off its pin (+), conflicted (U) or dirty.
pins:
    ./script/check-pins.sh

update:
    git submodule update --init --recursive

# Move a pin deliberately: change the mount, commit here, review the diff.
status:
    @git submodule status --recursive

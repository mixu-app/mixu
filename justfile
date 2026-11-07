# Entry-point repository: every component is a submodule, so the gates are
# "are the mounts complete and on the pinned commits" plus the Markdown gate.
set shell := ["bash", "-euo", "pipefail", "-c"]

check: lint-md pins

lint-md:
    markdownlint-cli2 --config .markdownlint-cli2.jsonc

# Fail when a mount is missing (-), off its pin (+), conflicted (U) or dirty.
pins:
    @git submodule status --recursive | awk '\
        /^-/ { print "UNINITIALISED: " $$2 " (run `just update`)"; bad = 1 } \
        /^\+/ { print "PIN MISMATCH: " $$2 " (commit does not match the pin)"; bad = 1 } \
        /^U/ { print "CONFLICT: " $$2; bad = 1 } \
        /dirty/ { print "DIRTY MOUNT: " $$2 " (uncommitted or off-pin content)"; bad = 1 } \
        END { if (bad) exit 1 }'
    @echo "pins ok"

update:
    git submodule update --init --recursive

# Move a pin deliberately: change the mount, commit here, review the diff.
status:
    @git submodule status --recursive

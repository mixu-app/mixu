# mixu entry-point agent guide

## Scope and authority

- Governs only this repository. Workspace rules in `../AGENTS.md` apply; the
  roster is `../workspace.toml`.
- Public repository, **Apache-2.0 for the scaffolding only**. The mounts keep their
  own licenses (MPL-2.0 client, Apache-2.0 libraries and contracts, CC0-1.0 corpus,
  Apache-2.0 site) — see `NOTICE`.
- This repository is an **entry point, not a component**: it exists so a reader can
  clone one URL and get everything, and so the organization profile has one place
  to send people.

## What lives here

| Path | Owned by this repository |
|---|---|
| `README.md`, `NOTICE`, `LICENSE` | yes |
| `justfile`, `.markdownlint-cli2.jsonc`, `.github/workflows/` | yes |
| `client/ graph/ spoiler/ renderer/ contracts/ fixtures/ website/` | **no — read-only mounts** |

## Hard rules

1. **Never edit inside a mount.** Change the owning repository, then move the pin:
   `cd <mount> && git fetch && git checkout <sha>`, back here `git add <mount>`.
   A commit that modifies a file under a mount is a defect, not a shortcut.
2. **Pins are exact commits**, never branches or tags. `just pins` fails on `-`
   (uninitialised), `+` (off-pin) and `U` (conflict), locally and in CI.
3. **No vendoring.** Do not copy a component's source into this repository to
   "make cloning easier"; that breaks its license boundary and its history.
4. **No secrets, no build output.** This repository stays tiny: text, pins, CI.
5. **One mount per component.** Adding a second path to the same repository is a
   layout change that needs a decision, not a convenience.

## Adding or removing a component

1. Land the component repository first, public, with its own license and gate.
2. `git submodule add https://github.com/mixu-app/<repo>.git <path>`.
3. Update `README.md` (table), `repo.toml` (`mounts`), `NOTICE` (licenses) and the
   ignore list in `.markdownlint-cli2.jsonc` in the same commit.
4. Update the organization profile in `mixu-app/.github` only if the public
   component list changes for readers.

## Gates

```sh
just check      # markdownlint + submodule pin consistency
just update     # materialise mounts after a plain git clone
just status     # human-readable pin table
```

A mount that is present but off-pin is an error, not a warning: a reader who clones
this repository must get exactly the commits the project tested.

## CarryCtx

- `cd` here before `carryctx` or Git; branches `ctx-XXXX/<type>-<slug>`.
- A pin bump is its own task, referencing what changed in the component.
- No commit, push or release without authorization.

## Review checklist

1. Does the diff touch a file inside a mount?
2. Are `README.md`, `repo.toml`, `NOTICE` and the lint ignores still consistent?
3. Is every pin an exact commit?
4. Would `git clone --recurse-submodules` on a clean machine produce a complete tree?

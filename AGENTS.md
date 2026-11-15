# Agent Context — nix config

Multi-platform system configuration using Nix flakes, home-manager, and nix-darwin.

## Key Commands

**Rebuild macOS:**
```bash
sudo darwin-rebuild switch --flake ~/nix#darwin
```

**Rebuild NixOS:**
```bash
sudo nixos-rebuild switch --flake ~/nix
```

**Update nixpkgs only:**
```bash
nix flake update nixpkgs
```

**Update all inputs:**
```bash
nix flake update
```

## Structure

```
flake.nix           # Inputs + wires flake-parts + import-tree
flake.lock          # Pinned revs — edit via `nix flake update`
modules/
  nixos/            # NixOS system modules (audio, boot, desktop, networking…)
  darwin/           # macOS system modules (fonts, packages, system, users)
  home/             # Home Manager modules shared across platforms
  hosts/            # Host-specific configs
  defaults.nix      # Wires nixos/darwin/home modules into flake outputs
```

## Flake Inputs

- **nixpkgs** — `nixos-unstable`; all packages come from here unless overridden
- **home-manager** — follows nixpkgs
- **nix-darwin** — follows nixpkgs
- **hermes-agent** — disabled/commented out (see comment in flake.nix)

## Gotchas

- `darwin-rebuild` requires `#darwin` at the end of the flake path — omitting it fails silently or errors.
- Packages have no explicit version pins in .nix files; version is determined by the nixpkgs rev in `flake.lock`.
- `nix eval "nixpkgs#<pkg>.version"` uses the global registry, not the project's flake.lock — use the explicit rev from flake.lock to verify actual versions.
- `hermes-agent` is disabled; to re-enable it, follow the instructions in `flake.nix` and `modules/nixos/hermes.nix`.

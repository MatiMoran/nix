{ lib, ... }:

{
  config.homeManager.sharedModules = lib.mkAfter [
    ({ config, pkgs, ... }: {
      # Shell config is NixOS-only: macOS keeps its shell setup outside this repo.
      home.file = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
        ".zshrc".source =
          config.lib.file.mkOutOfStoreSymlink
            "${config.home.homeDirectory}/nix/dotfiles/nixos/zshrc";
      };

      xdg.configFile."zsh/.ls-colors".source = ../../dotfiles/zsh/.ls-colors;
    })
  ];
}

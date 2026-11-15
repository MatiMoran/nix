{ lib, ... }:

{
  config.homeManager.sharedModules = lib.mkAfter [
    ({ config, pkgs, ... }:

    let
      repoDir = "${config.home.homeDirectory}/nix";
    in
    {
      home.packages = [ pkgs.neovim ];

      xdg.configFile."nvim" = {
        source = config.lib.file.mkOutOfStoreSymlink "${repoDir}/dotfiles/nvim";
      };
    })
  ];
}

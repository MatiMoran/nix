{ lib, ... }:

{
  config.homeManager.sharedModules = lib.mkAfter [
    ({ config, ... }:

    let
      repoDir = "${config.home.homeDirectory}/nix";
      agentsSrc = "${repoDir}/dotfiles/agents";
    in
    {
      home.file = {
        ".codex/AGENTS.md".source = config.lib.file.mkOutOfStoreSymlink "${agentsSrc}/AGENTS.md";
      };
    })
  ];
}

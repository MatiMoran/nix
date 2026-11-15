{ lib, ... }:

{
  config.homeManager.darwinModules = lib.mkAfter [
    ({ config, ... }:

    let
      repoDir = "${config.home.homeDirectory}/nix";
      claudeSrc = "${repoDir}/dotfiles/claude";
    in
    {
      home.file = {
        ".claude/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${claudeSrc}/settings.json";
        ".claude/CLAUDE.md".text = "@${repoDir}/dotfiles/agents/AGENTS.md";
        ".claude/statusline-command.sh".source = config.lib.file.mkOutOfStoreSymlink "${claudeSrc}/statusline-command.sh";
      };
    })
  ];
}

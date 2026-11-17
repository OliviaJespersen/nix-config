{ ... }: {
  flake.modules.nixos.hyfetch = { ... }: {
    programs.bash.shellAliases.fetch = "clear && hyfetch";
  };

  flake.modules.homeManager.hyfetch = { pkgs, ... }: {
    home.packages = [
      pkgs.hyfetch
    ];
  };
}

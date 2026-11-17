{ ... }: {
  flake.modules.nixos.display3d = { ... }: {
    programs.bash.shellAliases.shark = "display3d ~/Blahaj/blahaj.obj -t 0,0,5.5";
  };

  flake.modules.homeManager.display3d = { pkgs, ... }: {
    home.packages = [
      pkgs.display3d
    ];
  };
}

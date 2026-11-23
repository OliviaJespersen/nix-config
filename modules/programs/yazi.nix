{ ... }: {
  flake.modules.homeManager.yazi = { pkgs, ... }:
    let
      rosePine = pkgs.fetchFromGitHub {
        owner = "rose-pine";
        repo = "yazi";
        rev = "c89d745573d4fcfe0550fe6646f9f9ab1c0e51db";
        hash = "sha256-9e3dXViWl1rK9BPrGAFfs9ZL/tsG6Njz6ksuU6AIrFY=";
      };
    in
    {
      programs.yazi = {
        enable = true;
        flavors.rose-pine = "${rosePine}/flavors/rose-pine.yazi";
        theme.flavor.dark = "rose-pine";
      };
    };
}

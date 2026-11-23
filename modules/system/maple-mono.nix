{ ... }:
let
  fontFamily = "Maple Mono NF";
in
{
  flake.modules.nixos.maple-mono = { pkgs, ... }: {
    fonts = {
      packages = [ pkgs.maple-mono.NF ];
      fontconfig.defaultFonts.monospace = [ fontFamily ];
    };
  };

  flake.modules.homeManager.maple-mono = { ... }: {
    programs.ghostty.settings.font-family = fontFamily;
  };
}

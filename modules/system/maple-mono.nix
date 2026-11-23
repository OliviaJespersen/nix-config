{ ... }: {
  flake.modules.nixos.maple-mono = { pkgs, ... }: {
    fonts = {
      packages = [ pkgs.maple-mono.NF ];
      fontconfig.defaultFonts.monospace = [ "Maple Mono NF" ];
    };
  };
}

{ inputs, ... }: {
  flake.modules.homeManager.blahaj = { pkgs, ... }:
  let
    blahaj = pkgs.writeShellScriptBin "blahaj" ''
      cd ${inputs.display3d-src}/resources
      exec ${pkgs.display3d}/bin/display3d blahaj.obj -t 0,0,5.5 "$@"
    '';
  in
  {
    home.packages = [
      blahaj
    ];
  };
}

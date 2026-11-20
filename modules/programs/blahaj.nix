{ ... }: {
  flake.modules.homeManager.blahaj = { pkgs, ... }:
  let
    display3dSource = pkgs.fetchFromGitHub {
      owner = "renpenguin";
      repo = "display3d";
      rev = "642764a87bf4f20628d3d6416d8d94f74e44a431";
      hash = "sha256-Gmf3X13rCwypulwXfVOwXvtny9HVK9jW035kVLqSoMk=";
    };

    blahaj = pkgs.writeShellScriptBin "blahaj" ''
      cd ${display3dSource}/resources || exit 1
      exec ${pkgs.display3d}/bin/display3d blahaj.obj -t 0,0,5.5 "$@"
    '';
  in
  {
    home.packages = [
      blahaj
    ];
  };
}

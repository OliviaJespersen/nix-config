{ config, inputs, ... }:
let
  inherit (config.flake.modules) nixos homeManager;
in
{
  flake.nixosConfigurations.orion = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      nixos.orion
    ];
  };

  flake.modules.nixos.orion = { ... }: {
    imports = [
      ./_hardware.nix

      nixos.bluetooth
      nixos.boot
      nixos.display3d
      nixos.ghostty
      nixos.hyfetch
      nixos.locale
      nixos.mango
      nixos.networking
      nixos.nix
      
      inputs.home-manager.nixosModules.home-manager
    ];

    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    networking.hostName = "orion";

    nixpkgs.hostPlatform = "x86_64-linux";

    users.users.puppy = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;

      users.puppy = { ... }: {
        imports = [
          homeManager.btop
          homeManager.display3d
          homeManager.firefox
          homeManager.ghostty
          homeManager.helix
          homeManager.hyfetch
          homeManager.mango
          homeManager.noctalia
        ];

        home = {
          username = "puppy";
          homeDirectory = "/home/puppy";
          stateVersion = "24.11";
        };
      };
    };

    system.stateVersion = "24.11";
  };
}

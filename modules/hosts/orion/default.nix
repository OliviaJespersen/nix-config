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
      nixos.hyfetch
      nixos.ghostty
      nixos.locale
      nixos.mango
      nixos.maple-mono
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
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;

      users.puppy = { ... }: {
        imports = [
          homeManager.bitwarden
          homeManager.blahaj
          homeManager.btop
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

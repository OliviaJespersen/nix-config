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

      nixos.boot
      nixos.cursor
      nixos.hyfetch
      nixos.ghostty
      nixos.git
      nixos.locale
      nixos.maple-mono
      nixos.nix
      nixos.noctalia
      nixos.noctalia-greeter
      nixos.umbriel

      inputs.home-manager.nixosModules.home-manager
    ];

    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    networking.hostName = "orion";

    nixpkgs.hostPlatform = "x86_64-linux";

    programs.bash.shellAliases.rebuild = "git pull origin main && sudo nixos-rebuild switch --flake .#orion";

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
          homeManager.cursor
          homeManager.firefox
          homeManager.ghostty
          homeManager.helix
          homeManager.hyfetch
          homeManager.noctalia
          homeManager.umbriel
          homeManager.yazi
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

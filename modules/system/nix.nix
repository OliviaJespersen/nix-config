{ ... }: {
  flake.modules.nixos.nix = { ... }: {
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    programs.bash.shellAliases = {
      home = "sudo -E hx /etc/nixos/home.nix";
      config = "sudo -E hx /etc/nixos/configuration.nix";
      flake = "sudo -E hx /etc/nixos/flake.nix";
      update = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
    };
  };
}

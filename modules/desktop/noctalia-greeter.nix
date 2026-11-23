{ ... }: {
  flake.modules.nixos.noctalia-greeter = { ... }: {
    services.displayManager.noctalia-greeter = {
      enable = true;
      settings = {
        keyboard.layout = "dk";
        session.default = "Mango";
      };
    };
  };
}

{ ... }: {
  flake.modules.nixos.noctalia-greeter = { ... }: {
    services.displayManager.noctalia-greeter = {
      enable = true;
      settings = {
        appearance.scheme = "Rosé Pine";
        appearance.scheme_selector_position = "hidden";
        keyboard.layout = "dk";
        session.default = "Mango";
      };
    };
  };
}

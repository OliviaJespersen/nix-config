{ ... }: {
  flake.modules.nixos.noctalia-greeter = { pkgs, ... }: {
    services.displayManager.noctalia-greeter = {
      enable = true;
      cursorTheme = {
        package = pkgs.rose-pine-cursor;
        name = "BreezeX-RosePine-Linux";
      };
      settings = {
        appearance = {
          scheme = "Rosé Pine";
          scheme_selector_position = "hidden";
          hide_logo = true;
        };
        cursor.size = 24;
        keyboard.layout = "dk";
        session.default = "Mango";
      };
    };
  };
}

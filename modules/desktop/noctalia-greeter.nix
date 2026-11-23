{ ... }: {
  flake.modules.nixos.noctalia-greeter = { pkgs, ... }: {
    services.displayManager.noctalia-greeter = {
      enable = true;
      passwordlessSyncUsers = [ "puppy" ];
      cursorTheme = {
        package = pkgs.rose-pine-cursor;
        name = "BreezeX-RosePine-Linux";
      };
      settings = {
        appearance = {
          scheme_selector_position = "hidden";
          hide_logo = true;
        };
        keyboard.layout = "dk";
      };
    };
  };
}

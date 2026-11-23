{ ... }: {
  flake.modules.homeManager.cursor = { pkgs, ... }: {
    home.pointerCursor = {
      enable = true;
      package = pkgs.rose-pine-cursor;
      name = "BreezeX-RosePine-Linux";
      size = 24;
      gtk.enable = true;
    };

    gtk.enable = true;
  };
}

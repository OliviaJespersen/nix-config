{ inputs, ... }: {
  flake.modules.nixos.mango = { ... }: {
    imports = [
      inputs.mangowm.nixosModules.mango
    ];

    programs.mango.enable = true;

    services = {
      power-profiles-daemon.enable = true;
      upower.enable = true;
    };
  };
  
  flake.modules.homeManager.mango = { config, lib, ... }: {
    imports = [
      inputs.mangowm.hmModules.mango
    ];

    wayland.windowManager.mango = {
      enable = true;
      settings = lib.mkMerge [
        {
          exec_once = "noctalia";
          xkb_rules_layout = "dk";
          border_radius = 8;
          trackpad_natural_scrolling = 1;
          trackpad_accel_speed = 0.2;
          source = "~/.config/mango/noctalia.conf";
          bind = [
            "SUPER,r,reload_config"
            "SUPER,w,killclient"
          ];
        }
        (lib.mkIf config.home.pointerCursor.enable {
          cursor_theme = config.home.pointerCursor.name;
          cursor_size = config.home.pointerCursor.size;
        })
      ];
    };
  };
}

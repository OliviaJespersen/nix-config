{ inputs, ... }: {
  flake.modules.nixos.mango = { pkgs, ... }: {
    imports = [
      inputs.mangowm.nixosModules.mango
    ];

    services = {
      power-profiles-daemon.enable = true;
      upower.enable = true;
      greetd = {
        enable = true;
        settings.default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --cmd mango";
          user = "greeter";
        };
      };
    };
  };
  
  flake.modules.homeManager.mango = { ... }: {
    imports = [
      inputs.mangowm.hmModules.mango
    ];

    wayland.windowManager.mango = {
      enable = true;
      settings = {
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
      };
    };
  };
}

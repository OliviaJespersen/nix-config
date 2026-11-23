{ inputs, ... }: {
  flake.modules.nixos.noctalia = { ... }: {
    imports = [ inputs.noctalia.nixosModules.default ];

    programs.noctalia = {
      enable = true;
      recommendedServices.enable = true;
    };
  };

  flake.modules.homeManager.noctalia = { ... }: {
    imports = [
      inputs.noctalia.homeModules.default
    ];

    programs.noctalia = {
      enable = true;
      settings = {
        shell = {
          font_family = "Maple Mono NF";
          greeter_sync.auto_sync = true;
        };
        hooks.started = "noctalia msg greeter-sync";
        theme = {
          source = "builtin";
          builtin = "Rosé Pine";
          mode = "dark";
          templates = {
            enable_builtin_templates = true;
            builtin_ids = [ "umbriel" ];
          };
        };
        wallpaper = {
          enabled = true;
          directory = "~/nix-config/wallpapers";
          default.path = "~/nix-config/wallpapers/lain.jpg";
        };
        bar.default = {
          margin_ends = 0;
          scale = 1.2;
          radius = 0;
          start = ["launcher" "wallpaper" "workspaces"];
          center = ["clock"];
          end = ["network" "volume" "battery" "control-center" "session"];
        };
        widget = {
          network.show_label = false;
          volume.show_label = false;
        };
        plugins = {
          enabled = [
            "noctalia/bitwarden"
          ];
          source = {
            name = "official";
            kind = "git";
            location = "https://github.com/noctalia-dev/official-plugins";
            enable = true;
          };
        };
        plugin_settings."noctalia/bitwarden".hide_actions_when_searching = true;
      };
    };
  };
}

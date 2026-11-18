{ inputs, ... }: {
  flake.modules.homeManager.noctalia = { ... }: {
    imports = [
      inputs.noctalia.homeModules.default
    ];

    programs.noctalia = {
      enable = true;
      settings = {
        theme = {
          source = "builtin";
          builtin = "Rosé Pine";
          mode = "dark";
          templates = {
            enable_builtin_templates = true;
            builtin_ids = [
              "btop"
              "helix"
              "mango"
            ];
          };
        };
        wallpaper = {
          enabled = true;
          default.path = "~/Wallpapers/wallpaper.jpg";
        };
        bar.default = {
          margin_ends = 0;
          scale = 1.2;
          radius = 0;
          start = ["launcher" "workspaces"];
          center = ["clock"];
          end = ["network" "volume" "battery" "control-center" "session"];
        };
        widget = {
          network.show_label = false;
          volume.show_label = false;
        };
      };
    };
  };
}

{ inputs, ... }: {
  flake.modules.nixos.umbriel = { ... }: {
    imports = [ inputs.umbriel.nixosModules.default ];

    programs.umbriel.enable = true;
  };

  flake.modules.homeManager.umbriel = { config, ... }: {
    imports = [ inputs.umbriel.homeModules.default ];

    programs.umbriel = {
      enable = true;
      settings = {
        general= {
          autostart = [ "noctalia" ];
          show_cheatsheet = false;
        };
        include.optional.files = [ "${config.xdg.configHome}/umbriel/noctalia.toml" ];
        layout = {
          gap = 5;
          mode = "scrolling";
        };
        input.keyboard.layout = "dk";
        keybinds = {
          "Mod+Left" = "window-focus-left";
          "Mod+Right" = "window-focus-right";
          "Mod+Up" = "workspace-previous";
          "Mod+Down" = "workspace-next";
          
          "Mod+Shift+Left" = "column-move-left";
          "Mod+Shift+Right" = "column-move-right";
          "Mod+Shift+Up" = "window-move-to-workspace-previous";
          "Mod+Shift+Down" = "window-move-to-workspace-next";

          "Mod+Space" = "spawn noctalia msg panel-toggle launcher";
          "Mod+Q" = "window-close";
          "Mod+T" = "spawn ghostty";
          "Mod+F" = "spawn firefox";

          "Mod+M" = "window-toggle-maximize";
        };
      };
    };
  };
}

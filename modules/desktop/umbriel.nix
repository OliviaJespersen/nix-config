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
        general.autostart = [ "noctalia" ];
        include.optional.files = [ "${config.xdg.configHome}/umbriel/noctalia.toml" ];
        layout.gap = 5;
        input.keyboard.layout = "dk";
        keybinds = {
          "Mod+Return" = "spawn ghostty";
          "Mod+Q" = "window-close";
          "Mod" = "spawn noctalia msg panel-toggle launcher";
        };
      };
    };
  };
}

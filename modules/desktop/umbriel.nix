{ ... }: {
  flake.modules.nixos.umbriel = { ... }: {
    programs.umbriel.enable = true;
  };

  flake.modules.homeManager.umbriel = { ... }: {
    programs.umbriel.settings = {
      general.autostart = [ "noctalia" ];
      layout.gap = 5;
      input.keyboard.layout = "dk";
      keybinds = {
        "Mod+Return" = "spawn ghostty";
        "Mod+Q" = "window-close";
        "Mod" = "spawn noctalia msg panel-toggle launcher";
      };
    };
  };
}

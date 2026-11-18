{ ... }: {
  flake.modules.homeManager.helix = {
    programs.helix = {
      enable = true;

      settings = {
        theme = "rose_pine_transparent";
        editor.cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };
      };

      themes = {
        rose_pine_transparent = {
          "inherits" = "rose_pine";
          "ui.background" = { };
        };
      };
    };
  };
}

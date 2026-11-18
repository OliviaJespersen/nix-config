{ ... }: {
  flake.modules.homeManager.ghostty = { ... }: {
    programs.ghostty = {
      enable = true;
      settings = {
        theme = "Rose Pine";
        background-opacity = "0.80";
      };
    };
  };
}

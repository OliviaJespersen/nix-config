{ ... }: {
  flake.modules.nixos.ghostty = { ... }: {
    environment.sessionVariables.GTK_IM_MODULE = "simple";
  };

  flake.modules.homeManager.ghostty = { ... }: {
    programs.ghostty = {
      enable = true;
      settings = {
        font-family = "Maple Mono NF";
        theme = "Rose Pine";
        background-opacity = "0.80";
      };
    };
  };
}

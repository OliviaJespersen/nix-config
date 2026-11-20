{ ... }: {
  flake.modules.homeManager.btop = { pkgs, ... }: {
    programs.btop = {
      enable = true;

      settings = {
        color_theme = "rose-pine";
        theme_background = false;
      };

      themes.rose-pine = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/rose-pine/btop/c27e5d48e44e8bd115a2838ecf8cf1f3ea39475e/rose-pine.theme";
        hash = "sha256-CIZ1OHsLNmXwQkrGslB0jezY8jh6Cs+CG8j0eoDP0sY=";
      };
    };
  };
}

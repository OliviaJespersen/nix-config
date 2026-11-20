{ ... }: {
  flake.modules.homeManager.firefox = { pkgs, ... }:
  let
    rosePine = pkgs.fetchFromGitHub {
      owner = "rose-pine";
      repo = "firefox";
      rev = "efc1896fb77b5e6984e15338659c1c7a23af2fa3";
      hash = "sha256-5QOVoAWYI7qZGaf62Yv+8saJw/Iv8GMK2sJl2xd+JNo=";
    };
  in
  {
    home.file.".mozilla/firefox/default/chrome" = {
      source = "${rosePine}/dist";
      recursive = true;
    };

    programs.firefox = {
      enable = true;
      configPath = ".mozilla/firefox";
      policies = {
        DisableFirefoxAccounts = true;
        Homepage.StartPage = "previous-session";
        ExtensionSettings = {
          "*".installation_mode = "blocked";
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
            updates_disabled = true;
          };
        };
      };
      profiles.default.settings = {
        "ui.systemUsesDarkTheme" = 1;
        "sidebar.main.tools" = [];
        "sidebar.verticalTabs" = true;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };
    };
  };
}

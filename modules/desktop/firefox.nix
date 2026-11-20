{ ... }: {
  flake.modules.homeManager.firefox = { config, ... }: {
    programs.firefox = {
      enable = true;
      configPath = "${config.xdg.configHome}/mozilla/firefox";
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
      };
    };
  };
}
